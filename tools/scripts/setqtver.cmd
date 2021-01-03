::-----------------------------------------------------------------------------::
:: Name .........: setqtver.cmd
:: Project ......: Part of the JTSDK64 Tools Project
:: Version ......: 3.1.1.3
:: Description ..: Temporary Script to set Qt Version in main environment
:: Project URL ..: https://github.com/KI7MT
:: Usage ........: Call this file directly, or from command line
::
:: Author .......: Greg, Beam, KI7MT, <ki7mt@yahoo.com>
:: Copyright ....: Copyright (C) 2013-2019 Greg Beam, KI7MT
::               : And (c) 2020 JTSDK Contributors
:: License ......: GPL-3
:: 
:: Adjusted by Steve VK3VM for main QT versions > 5.12.10 12-4-2020 - 11-12(Dec)-2020
::
::-----------------------------------------------------------------------------::

@ECHO OFF
SetLocal EnableDelayedExpansion
SET "validArgs=5.12.10,5.14.2,5.15.2,6.0.0"
GOTO _MAIN

:_MAIN
CLS
ECHO ----------------------------------
ECHO JTSDK64 Tools QT Version Selection
ECHO ----------------------------------
ECHO.
ECHO Valid Qt Versions:
for %%a in ("%validArgs:,=" "%") do (
    echo    %%~a
)
ECHO.
ECHO At the prompt, type the version number
ECHO you whish to use:
ECHO.
set /p selection="Selection : "
GOTO _VALIDATE

:_VALIDATE
IF ["%selection%"]==["5.12.10"] ( GOTO _FOUND )
IF ["%selection%"]==["5.14.2"] ( GOTO _FOUND )
IF ["%selection%"]==["5.15.2"] ( GOTO _FOUND )
IF ["%selection%"]==["6.0.0"] ( GOTO _FOUND )

GOTO _NOTFOUND

:_FOUND
DEL /F /Q "%JTSDK_CONFIG%\qt?.*.*" >NUL 2>&1
TYPE nul > %JTSDK_CONFIG%\qt%selection%
if %ERRORLEVEL% == 0 (
    ECHO.
    ECHO New Version set to : %selection%
    ECHO.
    ECHO IMPORTANT: Changing QT Versions requires restarting
    ECHO the main JTSDK64 Tools Environment.
    ECHO.
    GOTO EOF
)
GOTO EOF

:_NOTFOUND
ECHO.
ECHO The version you you set ( %selection% ) is not valid.
ECHO Please use one of the following versions:
ECHO.
FOR %%a in ("%validArgs:,=" "%") DO (
    echo    %%~a
)
GOTO EOF

:EOF
exit /b 0
