# run-rendertestui.ps1
#
# Purpose: launch the RenderTest GUI (rendertestui.exe) with the switches the target needs,
#          elevated, in one step.
#
# Why this exists
# ---------------
# rendertestui.exe just runs qrendertest.exe with an inherited environment, and the GUI launches
# the target through the same code path as `rendertestcmd capture`. So the injection and hooking
# behaviour is identical - the only difference is how the switches get there:
#
#   * rendertestcmd capture passes an EMPTY environment-modification list and relies on the shell
#     environment being inherited, which is why the CLI runs work.
#   * The GUI passes the list from its "Environment Variables" box, and when launched from
#     Explorer that list is empty, so the target gets RenderDoc's default behaviour.
#
# Default behaviour rewrites the import table of EVERY loaded module, and mhypbase.dll - the
# anti-cheat module - imports CreateDXGIFactory itself. Rewriting that entry points the module at
# rendertest.dll, and the process is then hard-killed at ~22-26 s with a NULL-write AV inside
# ntdll's unwind code. Setting RDC_SKIP_IAT_MODULE=mhypbase.dll removes that entirely: full
# capture still works and the process survives 79-130 s.
#
# The GUI also has to run elevated, because the target refuses to start unelevated (Win32 error
# 740). This script elevates itself, so launching it is the only elevated step needed.
#
# Usage (from a normal shell - the script elevates itself):
#   double-click run-rendertestui.cmd
#   or use that .cmd file from a command prompt to pass the options below
#   ... -AutoCaptureDelayMs ''          no automatic capture; press F12 yourself
#   ... -AutoCaptureDelayMs '45000 65000 80000'   more chances to land in-game
#   ... -SkipIatModule ''               back to stock behaviour (expect the hard kill again)
#
# After it starts: set Executable/Working Directory in the GUI's launch dialog on each computer,
# press Launch, then either wait for the automatic capture or
# press F12 / use Live Capture's "Queue Capture".
#
# NOTE: keep this file ASCII-only. Windows PowerShell reads BOM-less files as ANSI and would
#       mangle non-ASCII text, which silently eats trailing quotes and breaks the parser.

[CmdletBinding()]
param(
    # Modules whose import tables RenderDoc must leave alone. Empty means stock behaviour.
    [string]$SkipIatModule = 'mhypbase.dll',
    # Comma/space separated wall-clock auto-captures, in ms after injection. Empty disables the
    # automatic trigger; the GUI's own F12 / "Queue Capture" keep working either way.
    [string]$AutoCaptureDelayMs = '60000',
    # Optional frame-number triggers (counted from the first Present of the wrapped device).
    [string]$AutoCaptureFrame = '',
    # Where the injected DLL drops self-dump artifacts. Empty leaves it to the DLL's default.
    [string]$SelfDumpDir = '',
    [string]$UiExe = ''
)

$ErrorActionPreference = 'Stop'
$ProgressPreference    = 'SilentlyContinue'
$ScriptDir = Split-Path -Parent $PSCommandPath
if (-not $PSBoundParameters.ContainsKey('SelfDumpDir')) {
    $SelfDumpDir = Join-Path $ScriptDir 'dumps'
}
if (-not $PSBoundParameters.ContainsKey('UiExe')) {
    $UiExe = Join-Path $ScriptDir 'x64\Release\rendertestui.exe'
}

# A tiny append-only log, because the elevated instance runs in its own console window: without
# this there is no way to tell afterwards whether it even reached the launch step.
$LogFile = Join-Path $ScriptDir 'run-rendertestui.log'
function Write-RunLog([string]$msg)
{
    try {
        Add-Content -Path $LogFile -Encoding UTF8 -Value ("{0}  {1}" -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'), $msg)
    } catch { }
}

# The UI stub looks for qrendertest.exe beside itself and may exit silently if it is missing.
# Check the files needed by this build before showing a UAC prompt.
if (-not [Environment]::Is64BitOperatingSystem) {
    throw 'This build requires 64-bit Windows.'
}
if ([string]::IsNullOrWhiteSpace($UiExe)) {
    throw 'UiExe must name the GUI executable.'
}
$UiExe = [System.IO.Path]::GetFullPath($UiExe)
$UiDir = Split-Path -Parent $UiExe
$requiredFiles = @(
    $UiExe,
    (Join-Path $UiDir 'qrendertest.exe'),
    (Join-Path $UiDir 'rendertest.dll'),
    (Join-Path $UiDir 'Qt5Core.dll'),
    (Join-Path $UiDir 'Qt5Gui.dll'),
    (Join-Path $UiDir 'Qt5Widgets.dll'),
    (Join-Path $UiDir 'qtplugins\platforms\qwindows.dll')
)
foreach ($file in $requiredFiles) {
    if (-not (Test-Path -LiteralPath $file -PathType Leaf)) {
        $message = "Required program file not found: $file. Copy the complete x64\Release folder with the launcher."
        Write-RunLog $message
        throw $message
    }
}

# ---------------- self-elevate ----------------
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
    [Security.Principal.WindowsBuiltInRole]::Administrator)

Write-RunLog ("start  admin={0}  pid={1}  skipIat='{2}'  autoCapture='{3}'" -f $isAdmin, $PID, $SkipIatModule, $AutoCaptureDelayMs)

if (-not $isAdmin) {
    Write-Host '[*] The target refuses to start unelevated (Win32 error 740), so the GUI needs' -ForegroundColor Yellow
    Write-Host '    administrator rights. Requesting elevation (one UAC prompt)...' -ForegroundColor Yellow

    $psExe = Join-Path $env:SystemRoot 'System32\WindowsPowerShell\v1.0\powershell.exe'
    $relaunchArgs = @(
        '-NoProfile', '-ExecutionPolicy', 'Bypass',
        '-File', ('"' + $PSCommandPath + '"'),
        '-SkipIatModule', ('"' + $SkipIatModule + '"'),
        '-AutoCaptureDelayMs', ('"' + $AutoCaptureDelayMs + '"'),
        '-AutoCaptureFrame', ('"' + $AutoCaptureFrame + '"'),
        '-SelfDumpDir', ('"' + $SelfDumpDir + '"'),
        '-UiExe', ('"' + $UiExe + '"')
    )
    try {
        Start-Process -FilePath $psExe -Verb RunAs -ArgumentList $relaunchArgs
        Write-RunLog "elevation requested (waiting on the UAC prompt)"
    } catch {
        Write-RunLog ("elevation FAILED: {0}" -f $_.Exception.Message)
        Write-Host ''
        Write-Host "[!] Elevation was refused or cancelled: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host '    Run this script again and accept the UAC prompt.' -ForegroundColor Red
        throw
    }
    return
}

Write-Host '[*] Elevated. Preparing the GUI environment.' -ForegroundColor Green

# ---------------- environment the target will inherit ----------------
# The GUI process inherits this environment, and with an empty Environment Variables box in its
# launch dialog it passes NULL to CreateProcess - so the target inherits it too.
#
# Clear the other bisection switches first: whichever shell launched this script may still have
# one set from an earlier experiment, and it would silently change this run.
$env:RDC_NO_HOOKS            = ''
$env:RDC_NO_WIN32_HOOKS      = ''
$env:RDC_NO_D3D_HOOKS        = ''
$env:RDC_NO_DXGI_HOOKS       = ''
$env:RDC_NO_D3D11_HOOKS      = ''
$env:RDC_NO_WRAP             = ''
$env:RDC_REDIRECT_NULL_WRITE = ''

$env:RDC_SKIP_IAT_MODULE       = $SkipIatModule
$env:RDC_AUTO_CAPTURE_DELAY_MS = $AutoCaptureDelayMs
$env:RDC_AUTO_CAPTURE_FRAME    = $AutoCaptureFrame
if ($SelfDumpDir) {
    New-Item -ItemType Directory -Path $SelfDumpDir -Force | Out-Null
    $env:RDC_SELFDUMP_DIR = $SelfDumpDir
}

# ---------------- report ----------------
$uiConfig = Join-Path $env:APPDATA 'qrendertest\UI.config'
$saveDir  = '(unset)'
$tempDir  = Join-Path $env:TEMP 'RenderTest'
if (Test-Path $uiConfig) {
    $m = Select-String -Path $uiConfig -Pattern '"DefaultCaptureSaveDirectory"\s*:\s*"([^"]*)"' -ErrorAction SilentlyContinue
    if ($m) { $saveDir = $m.Matches[0].Groups[1].Value }
    if (-not $saveDir) { $saveDir = '(unset)' }
}

Write-Host ''
Write-Host '  switches handed to the target:' -ForegroundColor Cyan
Write-Host ("    RDC_SKIP_IAT_MODULE        = '{0}'" -f $SkipIatModule)
Write-Host ("    RDC_AUTO_CAPTURE_DELAY_MS  = '{0}'" -f $AutoCaptureDelayMs)
Write-Host ("    RDC_AUTO_CAPTURE_FRAME     = '{0}'" -f $AutoCaptureFrame)
Write-Host ("    RDC_SELFDUMP_DIR           = '{0}'" -f $(if ($SelfDumpDir) { $SelfDumpDir } else { '(unset)' }))
Write-Host ''
Write-Host '  where captures land:' -ForegroundColor Cyan
Write-Host ("    temporary capture dir : {0}" -f $tempDir)
Write-Host ("    GUI save directory    : {0}" -f $saveDir)
Write-Host '    (the GUI writes to the temporary dir first; use Save Capture As, or set' -ForegroundColor DarkGray
Write-Host '     DefaultCaptureSaveDirectory under Tools > Settings, to keep them elsewhere)' -ForegroundColor DarkGray
if (-not $AutoCaptureDelayMs) {
    Write-Host ''
    Write-Host '  automatic capture is OFF - press F12/PrintScreen once the game is in-world,' -ForegroundColor Yellow
    Write-Host '  or use Live Capture > Queue Capture. The process only lives ~79-130 s.' -ForegroundColor Yellow
}
Write-Host ''
Write-Host '  reminders:' -ForegroundColor Cyan
Write-Host '    - launch the target from the GUI; do NOT use "inject into running process",'
Write-Host '      because there the env vars are applied only after the DLL is loaded and the'
Write-Host '      hook registration has already run.'
Write-Host '    - keep "Reference All Resources" and "Capture Callstacks" OFF: an in-game frame'
Write-Host '      is already ~100-500 MB without them.'
Write-Host ''

if (Get-Process YuanShen -ErrorAction SilentlyContinue) {
    Write-Host '  [!] YuanShen.exe is already running - the game is single-instance, so launching' -ForegroundColor Yellow
    Write-Host '      another copy may exit immediately. Close it first.' -ForegroundColor Yellow
    Write-Host ''
}

Write-Host ("[*] Starting {0}" -f $UiExe) -ForegroundColor Green
Write-RunLog ("launching UI: {0}" -f $UiExe)
try {
    Start-Process -FilePath $UiExe -WorkingDirectory $UiDir | Out-Null
    Write-RunLog "UI process started"
} catch {
    Write-RunLog ("UI launch FAILED: {0}" -f $_.Exception.Message)
    throw
}
Write-Host '[*] GUI launched. This window can be closed.' -ForegroundColor Green
