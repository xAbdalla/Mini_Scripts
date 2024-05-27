@ECHO off
Title Custom Icon Changer Script By: Abdallah NouR ...
REM :: BatchGotAdmin
REM :: -------------------------------------
REM REM  --> Check for permissions
REM IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
	REM >nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
REM ) ELSE (
	REM >nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
REM )

REM REM --> If error flag set, we do not have admin.
REM IF '%errorlevel%' NEQ '0' (
	REM ECHO Requesting administrative privileges...
	REM GOTO UACPrompt
REM ) ELSE ( GOTO gotAdmin )

REM :UACPrompt
REM ECHO Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
REM SET params= %*
REM ECHO UAC.ShellExecute "wt.exe", "%~s0", "", "runas", 1 >> "%temp%\getadmin.vbs"

REM "%temp%\getadmin.vbs"
REM DEL "%temp%\getadmin.vbs"
REM EXIT /B

REM :gotAdmin
REM PUSHD "%CD%"
REM CD /D "%~dp0"
REM :: --------------------------------------  
Title Custom Icon Changer Script By: Abdallah NouR ...
SET dir=%cd%
: START
SETLOCAL ENABLEDELAYEDEXPANSION
ECHO. & ECHO Custom Icon Changer Script By: Abdallah NouR ... & ECHO. & ECHO.
: Q1
SET r1=yes
REM ECHO Current Directory is --- "%dir%"
REM SET /p r1="Do you want to change this directory icon [Y/N]: "
SET yes=Y YES T TRUE
SET no=N NO F FALSE
FOR %%y IN (%yes%) DO ( 
	IF /I [!r1!] == [%%y] (
		: Q2
		SET dir=
		SET /p dir="Enter the directory: "
		GOTO :CODE
	)
)
FOR %%n IN (%no%) DO ( 
	IF /I [!r1!] == [%%n] (
		SET dir=%cd%
		GOTO :CODE
	)
)
IF /I ["!r1!"] == ["q"] GOTO :ClearCache
GOTO :Q1
: CODE
IF /I ["!dir!"] == ["q"] GOTO :ClearCache
IF NOT ["!dir!"] == [""] SET dir=!dir:"=!
IF ["!dir!"] == [""] GOTO :IF1
IF ["%dir:~-1%"]==["\"] SET dir=%dir:~0,-1%
IF NOT EXIST "%dir%" (
	: IF1
	ECHO *********************************************
	ECHO ***  ERROR: Bad Directory --- "%dir%"
	ECHO *********************************************
	GOTO :Q1
)
SET letters=A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
FOR %%l IN (%letters%) DO (
	IF /I "%dir%\" == "%%l:\" (
		SET r3=yes
		SET delete =
		SET dir2=
		IF EXIST "%dir%\drive.ico" (
			: DEL
			SET /p delete="Do you want to change the current icon [Y/N]: "
		)
		IF EXIST "%dir%\drive.ico" (
			IF [!delete!] == [] GOTO :DEL
			FOR %%y IN (%yes%) DO ( 
				IF /I [!delete!] == [%%y] (
					attrib -S -H -R "%dir%\drive.ico"
					REM DEL /F /Q "%dir%\drive.ico"
					MOVE /Y "%dir%\drive.ico" "%dir%\Old drive_%date:~10,4%%date:~7,2%%date:~4,2%_%time:~0,2%%time:~3,2%%time:~6,2%.ico" >nul
				)
			)
			FOR %%n IN (%no%) DO ( 
				IF /I [!delete!] == [%%n] (
					attrib -S -H -R "%dir%\drive.ico"
					attrib +S +H "%dir%\drive.ico"
					SET dir2="%dir%\drive.ico"
				)
			)
		)
		IF NOT EXIST "%dir%\drive.ico" (
			REM ECHO ERROR: "drive.ico" file has not been founded.
			: Q3
			SET r3=yes
			REM SET /p r3="Do you want to specify icon directory [Y/N]: "
		)
		IF NOT EXIST "%dir%\drive.ico" (
			IF [!r3!] == [] GOTO :Q3
			FOR %%y IN (%yes%) DO ( 
				IF /I [!r3!] == [%%y] (
					SET /p dir2="Enter the drive icon directory: "
					GOTO :YES1
				)
			)
			FOR %%n IN (%no%) DO ( 
				IF /I [!r3!] == [%%n] (
					GOTO :NO1
				)
			)
			IF /I ["!r3!"] == ["q"] GOTO :ClearCache
			GOTO :Q3
			: YES1
			IF /I ["!dir2!"] == ["q"] GOTO :ClearCache
			IF NOT ["!dir2!"] == [""] SET dir2=!dir2:"=!
			IF ["!dir2!"] == [""] GOTO :IF2
			IF ["!dir2:~-1!"]==["\"] SET dir2=%dir2:~0,-1%
			IF NOT EXIST "%dir2%" (
				: IF2
				ECHO *********************************************
				ECHO ***  ERROR: Bad Directory --- "%dir2%"
				ECHO *********************************************
				GOTO :Q3
			)
			SET ext=
			SET filename=
			FOR %%i IN ("%dir2%") DO (
				SET ext=%%~xi
				SET filename=%%~nxi
			)
			SET driveicon=
			IF ["%ext%"]==[".ico"] (
				XCOPY "%dir2%" "%dir%\drive.ico*" /H /Y  /C /I /Q /R > nul
				attrib +S +H "%dir%\drive.ico"
				SET driveicon=drive.ico
			)
			IF NOT ["%ext%"]==[".ico"] (
				IF NOT ["%dir2%"]==["%dir%\%filename%"] (
					SET driveicon=%dir2%
				)
				IF ["%dir2%"]==["%dir%\%filename%"] (
					SET driveicon=%filename%
				)
			)
		)
		: NO1
		IF EXIST "%dir%\drive.ico" (
			attrib -S -H -R "%dir%\drive.ico"
			attrib +S +H "%dir%\drive.ico"
			REM ECHO SUCCESS : "drive.ico" file has been founded.
		)
		attrib -S -H "%dir%\autorun.inf"
		ECHO [autorun] >"%dir%\autorun.in"
		ECHO icon=%driveicon%,0 >>"%dir%\autorun.in"
		MOVE "%dir%\autorun.in" "%dir%\autorun.inf" >nul
		attrib +S +H "%dir%\autorun.inf"
		ECHO. & ECHO ***********************************************************
		ECHO ***  Current Directory is --- "%dir%" & ECHO.
		ECHO ***  SUCCESS : "autorun.inf" file has been created successfully.
		IF ["%driveicon%"]==["drive.ico"] ECHO ***  SUCCESS : "drive.ico" file has been founded.
		IF NOT ["%driveicon%"]==["drive.ico"] (
			IF NOT ["%driveicon%"]==[""] ECHO ***  SUCCESS : "%driveicon%" file has been founded.
			IF ["%driveicon%"]==[""] ECHO ***  SUCCESS : "drive.ico" file has been founded.
		)
		ECHO *********************************************************** & ECHO.
		:: PAUSE
		GOTO :END
	)
)
SET r4=yes
SET delete =
SET dir3=
IF EXIST "%dir%\icon.ico" (
	: DEL2
	SET /p delete="Do you want to change the current icon [Y/N]: "
)
IF EXIST "%dir%\icon.ico" (
	IF [!delete!] == [] GOTO :DEL2
	FOR %%y IN (%yes%) DO ( 
		IF /I [!delete!] == [%%y] (
			attrib -S -H -R "%dir%\icon.ico"
			REM DEL /F /Q "%dir%\icon.ico"
			MOVE /Y "%dir%\icon.ico" "%dir%\Old Icon_%date:~10,4%%date:~7,2%%date:~4,2%_%time:~0,2%%time:~3,2%%time:~6,2%.ico" >nul
		)
	)
	FOR %%n IN (%no%) DO ( 
		IF /I [!delete!] == [%%n] (
			attrib -S -H -R "%dir%\icon.ico"
			attrib +S +H "%dir%\icon.ico"
			SET dir3="%dir%\icon.ico"
		)
	)
)
IF NOT EXIST "%dir%\icon.ico" (
	REM ECHO ERROR: "icon.ico" file has not been founded.
	: Q4
	SET r4=yes
	REM SET /p r4="Do you want to specify icon directory [Y/N]: "
)
IF NOT EXIST "%dir%\icon.ico" (
	IF [!r4!] == [] GOTO :Q4
	FOR %%y IN (%yes%) DO ( 
		IF /I [!r4!] == [%%y] (
			SET dir3=
			SET /p dir3="Enter the folder icon directory: "
			GOTO :YES2
		)
	)
	FOR %%n IN (%no%) DO ( 
		IF /I [!r4!] == [%%n] (
			GOTO :NO2
		)
	)
	IF /I ["!r4!"] == ["q"] GOTO :ClearCache
	GOTO :Q4
	: YES2
	IF NOT ["!dir3!"] == [""] SET dir3=!dir3:"=!
	IF ["!dir3!"] == [""] GOTO :IF3
	IF ["!dir3:~-1!"]==["\"] SET dir3=%dir3:~0,-1%
	IF NOT EXIST "%dir3%" (
		: IF3
		ECHO *********************************************
		ECHO ***  ERROR: Bad Directory --- "%dir3%"
		ECHO *********************************************
		GOTO :Q4
	)
	SET ext=
	SET filename=
	FOR %%i IN ("%dir3%") DO (
		SET ext=%%~xi
		SET filename=%%~nxi
	)
	SET foldericon=
	IF ["%ext%"]==[".ico"] (
		XCOPY "%dir3%" "%dir%\icon.ico*" /H /Y  /C /I /Q /R > nul
		attrib -S -H -R "%dir%\icon.ico"
		attrib +S +H "%dir%\icon.ico"
		SET foldericon=icon.ico
	)
	IF NOT ["%ext%"]==[".ico"] (
		IF NOT ["%dir3%"]==["%dir%\%filename%"] (
			SET foldericon=%dir3%
		)
		IF ["%dir3%"]==["%dir%\%filename%"] (
			SET foldericon=%filename%
		)
	)
)
: NO2
IF EXIST "%dir%\icon.ico" (
	attrib -S -H -R "%dir%\icon.ico"
	attrib +S +H "%dir%\icon.ico"
	REM ECHO SUCCESS : "icon.ico" file has been founded.
)
ECHO [.ShellClassInfo] >"%dir%\desktop.in"
ECHO IconResource=%foldericon%,0 >>"%dir%\desktop.in"
ECHO IconFile=%foldericon% >>"%dir%\desktop.in"
ECHO IconIndex=0 >>"%dir%\desktop.in"
MOVE "%dir%\desktop.in" "%dir%\desktop.ini" >nul
attrib -S -H -R "%dir%\desktop.ini"
attrib +S +H "%dir%\desktop.ini"
attrib -S -R "%dir%"
attrib +S +R "%dir%"
ECHO. & ECHO ******************************************************
ECHO ***  Current Directory is --- "%dir%" & ECHO.
ECHO ***  SUCCESS : "desktop.ini" has been created successfully.
IF ["%foldericon%"]==["icon.ico"] ECHO ***  SUCCESS : "icon.ico" file has been founded.
IF NOT ["%foldericon%"]==["icon.ico"] (
	IF NOT ["%foldericon%"]==[""] ECHO ***  SUCCESS : "%foldericon%" file has been founded.
	IF ["%foldericon%"]==[""] ECHO ***  SUCCESS : "icon.ico" file has been founded.
)
ECHO ****************************************************** & ECHO.
: END
SET r5 =
SET /p r5="Do you want to continue? [Y/N]: "
FOR %%n IN (%no%) DO ( 
	IF /I [!r5!] == [%%n] (
		GOTO :ClearCache
	)
)
FOR %%y IN (%yes%) DO ( 
	IF /I [!r5!] == [%%y] (
		ENDLOCAL
		ECHO =*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
		ECHO =*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
		CLS
		GOTO :START
	)
)
IF /I ["!r5!"] == ["q"] GOTO :ClearCache
GOTO :END
:ClearCache
ECHO Clear icon and thumbnails caches ....
CD /d C:
CD "%UserProfile%\AppData\Local\Microsoft\Windows\Explorer"
DEL iconcache*
DEL thumbcache*
ECHO Done ....
GOTO :eof