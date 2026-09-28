param(
    [ValidateSet('qrendertest', 'qrenderdoc')]
    [string]$App = 'qrendertest',
    [switch]$ReplaceExisting
)

$ErrorActionPreference = 'Stop'
$project = $PSScriptRoot
$uv = Get-Command uv -ErrorAction SilentlyContinue
if (-not $uv) {
    throw 'uv is required. Install uv, then run this script again.'
}

$running = Get-Process -Name $App -ErrorAction SilentlyContinue
if ($running) {
    throw "$App is running. Close it before installing the MCP bridge so UI.config is not overwritten on exit."
}

& $uv.Source sync --project $project --locked --python 3.12
if ($LASTEXITCODE -ne 0) {
    throw 'uv sync failed.'
}

$python = Join-Path $project '.venv\Scripts\python.exe'
if (-not (Test-Path -LiteralPath $python)) {
    throw "Python virtual environment was not created at $python"
}

$arguments = @((Join-Path $project 'install_bridge.py'), '--app', $App)
if ($ReplaceExisting) {
    $arguments += '--replace'
}
& $python @arguments
if ($LASTEXITCODE -ne 0) {
    throw 'Bridge installation failed.'
}

Write-Host 'RenderDoc MCP is ready. Start the GUI, open an .rdc file, then connect an MCP client.'
