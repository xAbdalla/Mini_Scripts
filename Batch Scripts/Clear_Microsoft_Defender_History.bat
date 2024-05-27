@ECHO off
Title Clear Microsoft Defender History Script By: Abdallah NouR ...
:: BatchGotAdmin
:: -------------------------------------
REM  --> Check for permissions
IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
	>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
	>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

REM --> If error flag set, we do not have admin.
IF '%errorlevel%' NEQ '0' (
	ECHO Requesting administrative privileges...
	GOTO UACPrompt
) ELSE ( GOTO gotAdmin )

:UACPrompt
ECHO Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
SET params= %*
ECHO UAC.ShellExecute "wt.exe", "%~s0", "", "runas", 1 >> "%temp%\getadmin.vbs"

"%temp%\getadmin.vbs"
DEL "%temp%\getadmin.vbs"
EXIT /B

:gotAdmin
PUSHD "%CD%"
CD /D "%~dp0"
:: --------------------------------------  
Title Clear Microsoft Defender History Script By: Abdallah NouR ...
: START
ECHO. & ECHO Clear Microsoft Defender History Script By: Abdallah NouR ... & ECHO. & ECHO.

DEL /F/S/Q "C:\ProgramData\Microsoft\Windows Defender\Scans\History\Service" > nul
rmdir /S /Q "C:\ProgramData\Microsoft\Windows Defender\Scans\History\Service"
wevtutil.exe cl "Microsoft-Windows-Windows Defender/Operational"

ECHO Done ....
PAUSE
GOTO :eof