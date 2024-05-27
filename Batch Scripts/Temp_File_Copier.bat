@echo off 
setlocal enableDelayedExpansion 
Title File Copier
set CHECKDIR="%temp%"
set TARGETDIR="%userprofile%\Desktop\Temp"

mkdir "%TARGETDIR%" 2>nul
pushd %CHECKDIR%

echo *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
echo *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=* File Copier v1.0 *=*=*=*=*=*=*=*=*=*=*=*=*=
echo *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
echo.
echo Source Folder: %CHECKDIR%
echo Target Folder: %TARGETDIR%
echo.

:loop
 for /f "delims=" %%f in ('dir /O-D /T:W /B') do (
	:: echo "Copying %%f"
	xcopy "%CHECKDIR%\%%f" "%TARGETDIR%\" /h /i /c /k /e /r /y >nul
	)
echo|set /p="Number of Files and Folders --> "
dir /B "%TARGETDIR%" | find /c /v ""
goto loop

popd
pause