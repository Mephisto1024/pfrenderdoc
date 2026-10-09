param(
    [string]$ToolDir = 'E:\pfrenderdoc\x64\Release',
    [string]$RunName = 'elevated-current-build',
    [switch]$UseCompatibleVulkanLayer
)
$ErrorActionPreference = 'Stop'
$runDirectory = Join-Path $PSScriptRoot $RunName
New-Item -ItemType Directory -Path $runDirectory -Force | Out-Null
Set-Content -LiteralPath (Join-Path $runDirectory 'started.txt') -Value (Get-Date -Format o)
$identity = [Security.Principal.WindowsIdentity]::GetCurrent()
$isAdministrator = [Security.Principal.WindowsPrincipal]::new($identity).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
Set-Content -LiteralPath (Join-Path $runDirectory 'elevation.txt') -Value $isAdministrator
if (-not $isAdministrator) { throw 'Administrator privileges are required by Endfield.exe.' }
$env:RDC_AUTO_CAPTURE_DELAY_MS = '30000,60000,90000'
$env:RDC_SELFDUMP_DIR = $runDirectory
$layerRegistryKey = $null
$layerBackup = @()
$compatibleManifest = Join-Path $ToolDir 'rendertest.json'
try {
if ($UseCompatibleVulkanLayer) {
    if (-not (Test-Path -LiteralPath $compatibleManifest)) { throw 'Compatible Vulkan manifest not found' }
    $layerRegistryKey = [Microsoft.Win32.Registry]::LocalMachine.OpenSubKey('SOFTWARE\Khronos\Vulkan\ImplicitLayers', $true)
    if (-not $layerRegistryKey) { throw 'Vulkan layer registry key is not accessible' }
    foreach ($layerName in $layerRegistryKey.GetValueNames()) {
        if ($layerName -match '(?i)rendertest\.json$') {
            $layerBackup += [pscustomobject]@{ Name=$layerName; Value=$layerRegistryKey.GetValue($layerName); Kind=[string]$layerRegistryKey.GetValueKind($layerName) }
        }
    }
    $layerBackup | Export-Clixml -LiteralPath (Join-Path $runDirectory 'vulkan-registration-before.xml')
    foreach ($layerEntry in $layerBackup) { $layerRegistryKey.SetValue($layerEntry.Name, 1, [Microsoft.Win32.RegistryValueKind]::DWord) }
    $layerRegistryKey.SetValue($compatibleManifest, 0, [Microsoft.Win32.RegistryValueKind]::DWord)
    $env:DISABLE_VULKAN_RENDERDOC_CAPTURE_1_46 = '1'
    Set-Content -LiteralPath (Join-Path $runDirectory 'vulkan-manifest-used.txt') -Value $compatibleManifest
}
$ErrorActionPreference = 'Continue'
& (Join-Path $ToolDir 'rendertestcmd.exe') capture --wait-for-exit --diagnostic-log (Join-Path $runDirectory 'diagnostic.log') --working-dir 'D:\Hypergryph Launcher\games\Arknights Endfield' --capture-file (Join-Path $runDirectory 'Endfield') 'D:\Hypergryph Launcher\games\Arknights Endfield\Endfield.exe' 1> (Join-Path $runDirectory 'stdout.txt') 2> (Join-Path $runDirectory 'stderr.txt')
$toolExitCode = $LASTEXITCODE
$ErrorActionPreference = 'Stop'
Set-Content -LiteralPath (Join-Path $runDirectory 'tool-exit-code.txt') -Value $toolExitCode
Set-Content -LiteralPath (Join-Path $runDirectory 'finished.txt') -Value (Get-Date -Format o)
} finally {
    if ($layerRegistryKey) {
        $layerRegistryKey.DeleteValue($compatibleManifest, $false)
        foreach ($layerEntry in $layerBackup) { $layerRegistryKey.SetValue($layerEntry.Name, $layerEntry.Value, [Enum]::Parse([Microsoft.Win32.RegistryValueKind], $layerEntry.Kind)) }
        $layerRegistryKey.Close()
        Set-Content -LiteralPath (Join-Path $runDirectory 'vulkan-registration-restored.txt') -Value (Get-Date -Format o)
    }
}
