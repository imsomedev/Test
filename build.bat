
::  Copyright (c) 2020-2021 Thakee Nathees
::  Distributed Under The MIT License

@echo off
Pushd %cd%
cd %~dp0

:: ----------------------------------------------------------------------------
::                      INITIALIZE MSVC ENV
:: ----------------------------------------------------------------------------
:CHECK_MSVC

if not defined INCLUDE goto :MSVC_INIT
goto :START

:MSVC_INIT
echo Not running on MSVC prompt, searching for one...

:: Find vswhere
if exist "%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe" (
	set VSWHERE_PATH="%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe"
) else ( if exist "%ProgramFiles%\Microsoft Visual Studio\Installer\vswhere.exe" (
	set VSWHERE_PATH="%ProgramFiles%\Microsoft Visual Studio\Installer\vswhere.exe"
) else (
	echo Can't find vswhere.exe
	goto :NO_VS_PROMPT
))

:: Get the VC installation path
%VSWHERE_PATH% -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -latest -property installationPath > _path_temp.txt
set /p VSWHERE_PATH= < _path_temp.txt
del _path_temp.txt
if not exist "%VSWHERE_PATH%" (
	echo Error: can't find VisualStudio installation directory
	goto :NO_VS_PROMPT
)

echo Found at - %VSWHERE_PATH%

:: Initialize VC for X86_64
call "%VSWHERE_PATH%\VC\Auxiliary\Build\vcvars64.bat"
if errorlevel 1 goto :NO_VS_PROMPT
echo Initialized MSVC x86_64
goto :START

:NO_VS_PROMPT
echo You must open a "Visual Studio .NET Command Prompt" to run this script
goto :END

:: ----------------------------------------------------------------------------
::                                START
:: ----------------------------------------------------------------------------
:START

cl hello.c

:: ----------------------------------------------------------------------------
::                              END
:: ----------------------------------------------------------------------------

:SUCCESS
echo.
echo Compilation Success
goto :END

:FAIL
popd
endlocal
echo Build failed. See the error messages.
exit /b 1

:END
popd
endlocal
goto :eof

