@echo off
setlocal
set "ROOT=%~dp0"
set "PATH=%SystemRoot%\System32;%SystemRoot%;%PATH%"
where cl.exe >nul 2>&1
if errorlevel 1 (
  if exist "C:\Program Files\Microsoft Visual Studio\18\Community\Common7\Tools\VsDevCmd.bat" (
    call "C:\Program Files\Microsoft Visual Studio\18\Community\Common7\Tools\VsDevCmd.bat" -arch=x64 -host_arch=x64 >nul
  ) else (
    echo cl.exe is unavailable. Run this in a Visual Studio x64 developer prompt. 1>&2
    exit /b 1
  )
)
cl /nologo /std:c++20 /EHsc /O2 /utf-8 /I "%ROOT%." /Fo:"%ROOT%dxil-decompiler.obj" /Fe:"%ROOT%dxil-decompiler.exe" "%ROOT%decompile.cpp"
exit /b %errorlevel%
