# RenderDoc shader processor path for DXBC compute shaders.
# Exit 10 means this is not a compute shader; decompile.bat then uses 3Dmigoto.
param([Parameter(Mandatory = $true)][string]$InputPath)

$ErrorActionPreference = 'Stop'

function Get-ShaderKind([byte[]]$Bytes) {
    if ($Bytes.Length -lt 36 -or [Text.Encoding]::ASCII.GetString($Bytes, 0, 4) -ne 'DXBC') {
        throw 'Input is not a DXBC container.'
    }
    $chunkCount = [BitConverter]::ToInt32($Bytes, 28)
    if ($chunkCount -lt 1 -or $chunkCount -gt 1024 -or 32 + 4 * $chunkCount -gt $Bytes.Length) {
        throw 'Invalid DXBC chunk table.'
    }
    for ($i = 0; $i -lt $chunkCount; $i++) {
        $offset = [BitConverter]::ToInt32($Bytes, 32 + 4 * $i)
        if ($offset -lt 0 -or $offset + 12 -gt $Bytes.Length) { continue }
        $tag = [Text.Encoding]::ASCII.GetString($Bytes, $offset, 4)
        if ($tag -eq 'SHDR' -or $tag -eq 'SHEX') {
            $version = [BitConverter]::ToUInt32($Bytes, $offset + 8)
            return [int]($version -shr 16)
        }
    }
    throw 'DXBC has no SHDR/SHEX shader program.'
}

function Invoke-Checked([string]$Executable, [string[]]$Arguments) {
    $result = & $Executable @Arguments 2>&1
    if ($LASTEXITCODE -ne 0) {
        throw ("{0} exited {1}: {2}" -f [IO.Path]::GetFileName($Executable), $LASTEXITCODE, ($result -join ' '))
    }
    return ($result -join [Environment]::NewLine)
}

$work = $null
try {
    $bytes = [IO.File]::ReadAllBytes($InputPath)
    $kind = Get-ShaderKind $bytes
    if ($kind -ne 5) { exit 10 }

    $bin = Join-Path $PSScriptRoot 'compute-bin'
    $dxbc2dxil = Join-Path $bin 'dxbc2dxil.exe'
    $dxilSpirv = Join-Path $bin 'dxil-spirv.exe'
    $spirvCross = Join-Path $bin 'spirv-cross.exe'
    foreach ($tool in @($dxbc2dxil, $dxilSpirv, $spirvCross)) {
        if (-not [IO.File]::Exists($tool)) { throw "Missing compute decompiler tool: $tool" }
    }

    $fxcCommand = Get-Command fxc.exe -ErrorAction SilentlyContinue
    if ($fxcCommand) {
        $fxc = $fxcCommand.Source
    } else {
        $sdk = Join-Path ${env:ProgramFiles(x86)} 'Windows Kits\10\bin'
        $fxc = Get-ChildItem -Path (Join-Path $sdk '*\x64\fxc.exe') -File -ErrorAction SilentlyContinue |
            Sort-Object FullName -Descending | Select-Object -First 1 -ExpandProperty FullName
    }
    if (-not $fxc) { throw 'fxc.exe from the Windows SDK is required to validate compute output.' }

    $root = [IO.Path]::GetFullPath([IO.Path]::GetTempPath()).TrimEnd('\')
    $work = Join-Path $root ('rendertest-cs-' + [guid]::NewGuid().ToString('N'))
    [IO.Directory]::CreateDirectory($work) | Out-Null
    $dxil = Join-Path $work 'shader.dxil'
    $spv = Join-Path $work 'shader.spv'
    $hlsl = Join-Path $work 'shader.hlsl'
    $compiled = Join-Path $work 'shader.dxbc'

    $originalAsm = Invoke-Checked $fxc @('/nologo', '/dumpbin', $InputPath)
    [void](Invoke-Checked $dxbc2dxil @($InputPath, '-o', $dxil, '-emit-bc'))
    [void](Invoke-Checked $dxilSpirv @($dxil, '--output', $spv, '--raw-llvm'))
    [void](Invoke-Checked $spirvCross @($spv, '--output', $hlsl, '--hlsl', '--shader-model', '50'))

    $enc = New-Object System.Text.UTF8Encoding($false)
    $source = [IO.File]::ReadAllText($hlsl, $enc)

    # SPIRV-Cross can emit a typed RWBuffer for a DXBC structured UAV. For
    # 4-byte scalar elements the HLSL declaration can be restored exactly.
    $structured = [regex]::Matches($originalAsm, '(?m)^dcl_uav_structured u(?<slot>\d+),\s*(?<stride>\d+)\s*$')
    foreach ($decl in $structured) {
        $slot = $decl.Groups['slot'].Value
        $stride = [int]$decl.Groups['stride'].Value
        if ($stride -ne 4) { throw "Structured UAV u$slot has unsupported stride $stride." }
        $match = [regex]::Match($source, "(?m)^RWBuffer<(?<type>[^>]+)>\s+U$slot\s*:\s*register\(u$slot\);[ \t]*\r?$")
        if (-not $match.Success) { throw "Cannot restore structured UAV u$slot in generated HLSL." }
        $scalar = $match.Groups['type'].Value
        if ($scalar -notin @('uint', 'int', 'float')) {
            throw "Structured UAV u$slot has unsupported scalar type $scalar."
        }
        $replacement = "RWStructuredBuffer<$scalar> U$slot : register(u$slot);"
        $source = $source.Replace($match.Value, $replacement)
    }
    [IO.File]::WriteAllText($hlsl, $source, $enc)

    [void](Invoke-Checked $fxc @('/nologo', '/T', 'cs_5_0', '/E', 'main', '/WX', '/Fo', $compiled, $hlsl))
    $compiledAsm = Invoke-Checked $fxc @('/nologo', '/dumpbin', $compiled)
    foreach ($decl in $structured) {
        $slot = $decl.Groups['slot'].Value
        if ($compiledAsm -notmatch "(?m)^dcl_uav_structured u$slot, 4\s*$") {
            throw "Recompiled shader did not retain structured UAV u$slot."
        }
    }

    $output = $enc.GetBytes($source)
    $stdout = [Console]::OpenStandardOutput()
    $stdout.Write($output, 0, $output.Length)
    $stdout.Flush()
} catch {
    [Console]::Error.WriteLine('Compute decompile failed: ' + $_.Exception.Message)
    exit 1
} finally {
    if ($work -and [IO.Directory]::Exists($work)) {
        $root = [IO.Path]::GetFullPath([IO.Path]::GetTempPath()).TrimEnd('\')
        $resolved = [IO.Path]::GetFullPath($work)
        if ($resolved.StartsWith($root + '\', [StringComparison]::OrdinalIgnoreCase)) {
            Get-ChildItem -LiteralPath $resolved -File | Remove-Item -Force
            Remove-Item -LiteralPath $resolved -Force
        }
    }
}
