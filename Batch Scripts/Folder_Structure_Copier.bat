@ECHO off
Title Folder Structure Copier Script By: Abdallah NouR ...
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
Title Folder Structure Copier Script By: Abdallah NouR ...
: START
SETLOCAL ENABLEDELAYEDEXPANSION
ECHO. & ECHO Folder Structure Copier Script By: Abdallah NouR ... & ECHO. & ECHO.
: Q1
SET Source=
SET /p Source="What is the Source Directory: "
IF /I ["!Source!"] == ["q"] GOTO :ClearCache
IF NOT ["!Source!"] == [""] SET Source=!Source:"=!
IF ["!Source!"] == [""] GOTO :IF1
IF ["%Source:~-1%"]==["\"] SET Source=%Source:~0,-1%
IF NOT EXIST "%Source%" (
	: IF1
	ECHO *********************************************
	ECHO ERROR: Bad Directory --- "%Source%"
	ECHO *********************************************
	GOTO :Q1
)
: Q2
SET Distination=
SET /p Distination="What is the Distination Directory: "
IF /I ["!Distination!"] == ["q"] GOTO :ClearCache
IF NOT ["!Distination!"] == [""] SET Distination=!Distination:"=!
IF ["!Distination!"] == [""] GOTO :IF2
IF ["%Distination:~-1%"]==["\"] SET Distination=%Distination:~0,-1%
IF NOT EXIST "%Distination%" (
	: IF2
	ECHO *********************************************
	ECHO ERROR: Bad Directory --- "%Distination%"
	ECHO *********************************************
	GOTO :Q2
)

: Q3
SET LEV=4
SET /p LEV="What is the Levels you want to copy (4 is Recommended): "
IF /I ["!LEV!"] == ["q"] GOTO :ClearCache
IF NOT ["!LEV!"] == [""] SET LEV=!LEV:"=!
IF ["!LEV!"] == [""] GOTO :IF3
SET /a param=!LEV!+0
IF %param%==0  (
	: IF3
	ECHO *********************************************
	ECHO ERROR: Bad Entry --- "%LEV%"
	ECHO *********************************************
	GOTO :Q3
)
SET RoboCopyDir=C:\Windows\System32\
CD /D "%RoboCopyDir%"
@RoboCopy.exe "%Source%" "%Distination%" desktop.ini icon.ico /LEV:%LEV% /E /ZB /J

: END
SET yes=Y YES T TRUE
SET no=N NO F FALSE
SET answer =
ECHO *********************************************
SET /p answer="Do you want to continue? [Y/N]: "
FOR %%n IN (%no%) DO ( 
	IF /I [!answer!] == [%%n] (
		GOTO :ClearCache
	)
)
FOR %%y IN (%yes%) DO ( 
	IF /I [!answer!] == [%%y] (
		ENDLOCAL
		ECHO =*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
		ECHO =*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
		CLS
		GOTO :START
	)
)
IF /I ["!answer!"] == ["q"] GOTO :ClearCache
GOTO :END
:ClearCache
ECHO *********************************************
ECHO Clear icon and thumbnails caches ....
CD /d C:
CD "%UserProfile%\AppData\Local\Microsoft\Windows\Explorer"
DEL iconcache*
DEL thumbcache*
ECHO Done ....
GOTO :eof