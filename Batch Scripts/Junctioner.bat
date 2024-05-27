: START
@ECHO off
SETLOCAL ENABLEDELAYEDEXPANSION
Title Junctioner
ECHO. & ECHO Junctioner Script By: Abdallah NouR ... & ECHO.
SET yes=Y YES T TRUE
SET no=N NO F FALSE
SET ans=
SET target=
SET link=

Echo "<Target>  |  Specifies the path (relative or absolute) that the new symbolic link refers to."
Echo "<Link>    |  Specifies the name of the symbolic link being created." & ECHO.

:Q1
SET /p target="Enter the <Target> : "
IF NOT ["!target!"] == [""] SET target=!target:"=!
IF ["!target!"] == [""] GOTO :IF1
IF ["!target:~-1!"]==["\"] SET target=!target:~0,-1!
IF NOT EXIST "!target!" (
	: IF1
	ECHO ***  ERROR: Target Does Not Exist --- "!target!"
	GOTO :Q1
)

:Q2
SET /p link="Enter the <Link>   : "
IF NOT ["!link!"] == [""] SET link=!link:"=!
IF ["!link!"] == [""] ECHO ***  ERROR: Empty Directory --- "!link!" & GOTO :Q2
IF ["!link:~-1!"]==["\"] SET link=!link:~0,-1!
IF EXIST "!link!"  Echo "<Link> should not exist. Rename, Move, or Delete it"  & GOTO :Q2

ECHO. & MkLink /J "!link!" "!target!"
ECHO Done... & ECHO.

: END
SET /p ans="Do you want to continue? [N/Y]: "
IF [!ans!] == [] SET ans=no
FOR %%y IN (%yes%) DO (IF /I [!ans!] == [%%y] SETLOCAL DISABLEDELAYEDEXPANSION & CLS & GOTO :START)
GOTO :eof