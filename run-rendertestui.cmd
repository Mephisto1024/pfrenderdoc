@echo off
setlocal DisableDelayedExpansion

set "script=%~dp0run-rendertestui.ps1"
set "powershell=%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe"

if not exist "%powershell%" (
    echo Windows PowerShell was not found: "%powershell%"
    pause
    exit /b 1
)
if not exist "%script%" (
    echo Launcher script was not found: "%script%"
    pause
    exit /b 1
)

"%powershell%" -NoProfile -ExecutionPolicy Bypass -NoExit -File "%script%" %*
exit /b %errorlevel%
