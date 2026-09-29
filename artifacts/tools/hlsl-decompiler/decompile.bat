@echo off
rem ============================================================================
rem  RenderDoc "Shader Processor" wrapper for 3Dmigoto's HLSL decompiler
rem  (etnlgd/HLSLDecompiler -> cmd_Decompiler.exe -D).
rem
rem  Contract expected by RenderDoc (qrenderdoc/Code/Interface/ShaderProcessingTool.cpp):
rem    - RenderDoc writes the shader blob to %TEMP%\shader_input  (NO extension)
rem    - it passes that path in place of {input_file}
rem    - because the args contain no {output_file}, RenderDoc redirects this
rem      process's STDOUT to %TEMP%\shader_output and reads the HLSL from there
rem    - STDERR goes to a separate file (%TEMP%\shader_stdout) and is only shown
rem      in the log, so progress messages on stderr do NOT pollute the shader
rem
rem  So: run the decompiler, then copy its .hlsl output to stdout.
rem
rem  The output also goes through fixup.ps1, which repairs a 3Dmigoto bug that
rem  RenderDoc turns into a fatal error (uninitialized uiDest -> X4000).
rem ============================================================================
setlocal EnableExtensions

set "TOOL=%~dp0cmd_Decompiler.exe"
set "INFILE=%~1"
set "OUTFILE=%~dpn1.hlsl"
set "PS=%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe"

if "%~1"=="" goto :noinput

rem Compute shaders need UAV, groupshared and thread semantics that the 3Dmigoto
rem decompiler does not reconstruct. The PowerShell route returns 10 for other
rem shader stages so the existing 3Dmigoto path remains unchanged.
if not exist "%PS%" goto :legacy
if not exist "%~dp0compute-decompile.ps1" goto :legacy
"%PS%" -NoProfile -ExecutionPolicy Bypass -File "%~dp0compute-decompile.ps1" "%INFILE%"
set "COMPUTE_CODE=%ERRORLEVEL%"
if "%COMPUTE_CODE%"=="0" goto :computesuccess
if not "%COMPUTE_CODE%"=="10" goto :computefailed

:legacy
if not exist "%TOOL%" goto :notool

rem RenderDoc reuses the same temp file name for every shader it decompiles, so a
rem leftover .hlsl from a previous run would be silently returned if this run
rem fails. Delete it first.
if exist "%OUTFILE%" del /q "%OUTFILE%" >nul 2>&1

rem Progress/warning text goes to stderr, which RenderDoc keeps separate.
"%TOOL%" -D "%INFILE%"

if not exist "%OUTFILE%" goto :nooutput

rem Repair the 3Dmigoto GetDimensions/uiDest bug before RenderDoc compiles the
rem result with warnings-as-errors. Falls back to a plain copy if PowerShell or
rem the fixup script is unavailable.
if not exist "%~dp0fixup.ps1" goto :plaincopy
if not exist "%PS%" goto :plaincopy

"%PS%" -NoProfile -ExecutionPolicy Bypass -File "%~dp0fixup.ps1" "%OUTFILE%"
if errorlevel 1 goto :fixupfailed
endlocal
exit /b 0

:plaincopy
type "%OUTFILE%"
endlocal
exit /b 0

:noinput
echo ERROR: HLSLDecompiler wrapper: no input file was passed. 1>&2
endlocal
exit /b 1

:notool
echo ERROR: HLSLDecompiler wrapper: "%TOOL%" was not found next to this script. 1>&2
endlocal
exit /b 1

:nooutput
echo ERROR: HLSLDecompiler wrapper: decompiler produced no HLSL for "%INFILE%". 1>&2
endlocal
exit /b 1

:fixupfailed
echo ERROR: HLSLDecompiler wrapper: fixup.ps1 failed on "%OUTFILE%". 1>&2
endlocal
exit /b 1

:computesuccess
endlocal
exit /b 0

:computefailed
echo ERROR: HLSLDecompiler wrapper: compute shader conversion failed. 1>&2
endlocal
exit /b 1
