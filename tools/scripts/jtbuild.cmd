@ECHO off
:: -----------------------------------------------------------------------------
:: Name ..............: jtbuild.cmd
:: Description .......: Test Build script for WSJT-X (limited functionality)
:: Author ............: Greg, Beam, KI7MT, <ki7mt@yahoo.com>
::                      and subsequent JTSDK Contributors 
:: Copyright .........: Copyright (C) 2018 Greg Beam, KI7MT
:: License ...........: GPL-3
::
:: Adjustments made by Steve VK3VM to work with JTSDK 3.1 12-04-2020 - 11-12(Dec)-2020
::
:: :: Code should now be capable of auto-downloading from a WSJTX, JTDX or JS8CALL
:: Repository based on flag src-wsjtx | src-jtdx | src-js8call in
:: C:\JTSDK64-Tools\config
::
:: jtbuild-cmd.cmd is free software: you can redistribute it and/or modify it
:: under the terms of the GNU General Public License as published by the Free
:: Software Foundation either version 3 of the License, or (at your option) any
:: later version. 
::
:: jtbuild.cmd is distributed in the hope that it will be useful, but WITHOUT
:: ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
:: FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
:: details.
::
:: You should have received a copy of the GNU General Public License
:: along with this program.  If not, see <http://www.gnu.org/licenses/>.
::-----------------------------------------------------------------------------::

:: Used to prevent CMake errors with MinGW Makefiles
PUSHD %JTSDK_HOME%\tools\msys64\usr\bin
ren sh.exe sh-bak.exe >NUL 2>&1
POPD

:: Check to see if a source marker file exists

set exfl=No
if exist %JTSDK_CONFIG%\src-wsjtx set exfl=Yes
if exist %JTSDK_CONFIG%\src-jtdx set  exfl=Yes
if exist %JTSDK_CONFIG%\src-js8call set exfl=Yes
if %exfl%==No goto NOSOURCE 

goto RESTART

:RESTART
:: Setup process variables -----------------------------------------------------

:: Sets srcd => Source Location
:: Sets dest => Desctination Location
:: Sets cfgd => JTSDK_CONFIG location
:: Sets qtv => QTV

IF NOT EXIST %JTSDK_HOME%\tmp\build.txt GOTO FIRST-RUN

cat %JTSDK_HOME%\tmp\build.txt |grep "SRCD" |awk "{print $2}" >s.d & SET /p srcd=<s.d & rm s.d
cat %JTSDK_HOME%\tmp\build.txt |grep "DEST" |awk "{print $2}" >d.d & SET /p dest=<d.d & rm d.d

set cfgd=%JTSDK_CONFIG%
set qtv=%QTV%

:: option parameters -----------------------------------------------------------
:: SET qt59=No :: Deprecated
SET clean-first=No
SET reconfigure=No
SET autorun=No
SET JJ=%NUMBER_OF_PROCESSORS%

goto SETDOWNLOAD

:SETDOWNLOAD
:: Set Code to download source based on switch in %cfgd%
:: Switch is src-wsjtx, src-jtdx or src-js8call

IF NOT EXIST %srcd% GOTO DOWN-SRC

:: Source selection has change detection block : FAULTY
IF EXIST %cfgd%\src-wsjtx ( IF EXIST %JTSDK_HOME%\tmp\src-wsjtx GOTO CHECK-OPTIONS )
IF EXIST %cfgd%\src-jtdx ( IF EXIST %JTSDK_HOME%\tmp\src-jtdx GOTO CHECK-OPTIONS )
IF EXIST %cfgd%\src-js8call ( IF EXIST %JTSDK_HOME%\tmp\src-js8call GOTO CHECK-OPTIONS )

:: Source selection has changed so delete old source
ECHO .
echo|set /p="Deleting Original Source: " 
rm -rf %JTSDK_HOME%\tmp\wsjtx >nul 2>&1
echo Done

GOTO DOWN-SRC

:DOWN-SRC
IF EXIST %cfgd%\src-wsjtx GOTO CLONE-WSJTX
IF EXIST %cfgd%\src-jtdx GOTO CLONE-JTDX
IF EXIST %cfgd%\src-js8call GOTO CLONE-JS8CALL

:CLONE-WSJTX
ECHO.
ECHO Downloading WSJTX from Home Repository
ECHO.
git clone git://git.code.sf.net/p/wsjt/wsjtx %srcd%
DEL %JTSDK_HOME%\tmp\src-* >nul 2>&1
ECHO ^[WSJTX Set as Previous^] 
COPY NUL %JTSDK_HOME%\tmp\src-wsjtx >nul 2>&1 
GOTO RESTART

:CLONE-JTDX	
ECHO.
ECHO Downloading JTDX from Home Repository
ECHO.
git clone https://github.com/jtdx-project/jtdx.git %srcd%
DEL %JTSDK_HOME%\tmp\src-* >nul 2>&1 
ECHO ^[JTDX Set as Previous^]
COPY NUL %JTSDK_HOME%\tmp\src-jtdx >nul 2>&1
GOTO RESTART

:CLONE-JS8CALL
ECHO.
ECHO Downloading JS8CALL from Home Repository
ECHO.
git clone https://widefido@bitbucket.org/widefido/js8call.git %srcd%
DEL %JTSDK_HOME%\tmp\src-* >nul 2>&1 
ECHO ^[JS8CALL Set as Previous^]
COPY NUL %JTSDK_HOME%\tmp\src-js8call  >nul 2>&1
GOTO RESTART

GOTO CHECK-OPTIONS

:CHECK-OPTIONS

:: if no Version.cmake in source
IF EXIST "%srcd%\Versions.cmake" ( GOTO STARTPROC ) ELSE ( GOTO NOVERSIONS )

:STARTPROC

:: QT CMake Tool Chain File Selection
:: Code crudely via horrid Nested IF's falls back to Qt 5.12.10

IF EXIST %cfgd%\qt6.0.0 ( 
	SET tchain=%JTSDK_HOME%/tools/tc-files/QT600.cmake
	) ELSE IF EXIST %cfgd%\qt5.15.2 (
			SET tchain=%JTSDK_HOME%/tools/tc-files/QT5152.cmake
		) ELSE IF EXIST %cfgd%\qt5.14.2 (
				SET tchain=%JTSDK_HOME%/tools/tc-files/QT5142.cmake
			) ELSE (
				SET tchain=%JTSDK_HOME%/tools/tc-files/QT51210.cmake
			)
		)
	)
)

:: clean-first parameter
IF EXIST %cfgd%\clean (
	SET clean-first=Yes
)

:: reconfigure parameter
IF EXIST %cfgd%\reconfigure (
	SET reconfigure=Yes
)

:: Autorun parameter
IF EXIST %cfgd%\autorun (
	SET autorun=Yes
)

GOTO START

:: Start Main Script -----------------------------------------------------------
::
:: One of the worst Nested-If's seen in a bacth file !!!
 
:START
IF /I [%1]==[] (
    GOTO HELP-OPTIONS
)
IF /I [%1]==[help] (
	GOTO HELP-OPTIONS
) ELSE IF /I [%1]==[-h] (
			GOTO HELP-OPTIONS
		) ELSE IF /I [%1]==[-o] (
				GOTO OPTION-STATUS
			) ELSE IF /I [%1]==[rconfig] (
					SET copt=Release
					SET topt=config
					GOTO GET-AVER
				) ELSE IF /I [%1]==[dconfig] (
						SET copt=Debug
						SET topt=config
						GOTO GET-AVER
					) ELSE IF /I [%1]==[rinstall] (
							SET copt=Release
							SET topt=install
							GOTO GET-AVER
						) ELSE IF /I [%1]==[dinstall] (
								SET copt=Debug
								SET topt=install
								GOTO GET-AVER
							) ELSE IF /I [%1]==[package] (
									SET copt=Release
									SET topt=package
									GOTO GET-AVER
								) ELSE IF /I [%1]==[docs] (
										SET copt=Release
										SET topt=docs
										GOTO GET-AVER
									) ELSE ( 
										GOTO EOF 
									)
								)
							)
						)
					)
				)
			)
		)
	)
	
GOTO GET-AVER


::
:: Updated VK3SIR 22-11-2020
::
:GET-AVER
:: Get the WSJT-X Version from Versions.cmake-----------------------------------
IF NOT EXIST %srcd%\Versions.cmake GOTO NOVERSIONS

SET vfile="%srcd%\Versions.cmake"
cat %vfile% |grep "_MAJOR" |awk "{print $3}" | tr -d ")" >ma.v & SET /p mav=<ma.v & rm ma.v
cat %vfile% |grep "_MINOR" |awk "{print $3}" | tr -d ")" >mi.v & SET /p miv=<mi.v & rm mi.v
cat %vfile% |grep "_PATCH" |awk "{print $3}" | tr -d ")" >pa.v & SET /p pav=<pa.v & rm pa.v
cat %vfile% |grep "_RC" |awk "{print $3}" |tr -d ")" >rcx.v & SET /p rcx=<rcx.v & rm rcx.v
cat %vfile% |grep "_RELEASE" |awk "{print $3}" | tr -d ")" >rel.v & SET /p relx=<rel.v & rm rel.v

:: For when we get a reliable method to deal with No Versions.cmake
::	set /p mav
::	set /p miv
::	set /p pav
::	set /p rcx
::	set /p relx

IF [%relx%]==[1] (
	SET aver=%mav%.%miv%.%pav%
	SET desc=GA Release
)

IF %rcx% GTR 0 (
	IF [%relx%]==[1] (
		SET aver=%mav%.%miv%.%pav%
		SET desc=GA Release
	)
)

IF [%rcx%]==[0] (
	IF [%relx%]==[0] (
		SET aver=%mav%.%miv%.%pav%
		SET desc=devel
	)
)

IF %rcx% GTR 0 (
	IF [%relx%]==[0] (
		SET aver=%mav%.%miv%.%pav%
		SET desc=Release Candidate
	)
)
GOTO SETUP-DIRS

:: setup directories -----------------------------------------------------------
:SETUP-DIRS
ECHO.
ECHO --------------------------------------------
ECHO  Folder Locations
ECHO --------------------------------------------
ECHO.
SET buildd=%dest%\qt\%qtv%\%aver%\%copt%\build
SET installd=%dest%\qt\%qtv%\%aver%\%copt%\install
SET pkgd=%dest%\qt\%qtv%\%aver%\%copt%\package
mkdir %buildd% >NUL 2>&1
mkdir %installd% >NUL 2>&1
mkdir %pkgd% >NUL 2>&1
ECHO  Build .......^: %buildd%
ECHO  Install .....^: %installd%
ECHO  Package .....^: %pkgd%
ECHO.
GOTO START-MAIN

:START-MAIN
ECHO --------------------------------------------
ECHO  Build Information
ECHO --------------------------------------------
ECHO.
ECHO  Description ...^: %desc%
ECHO  Version .......^: %aver%
ECHO  Type ..........^: %copt%
ECHO  Target ........^: %topt%
ECHO  Tool Chain ....^: %qtv%
ECHO  SRC ...........^: %srcd%
ECHO  Build .........^: %buildd%
ECHO  Install .......^: %installd%
ECHO  Package .......^: %pkgd%
ECHO  TC File .......^: %tchain%
ECHO  Clean .........^: %clean-first%
ECHO  Reconfigure ...^: %reconfigure%
ECHO.
GOTO BUILD-SELECT

:: select build type ---------------------------------------------- BUILD SELECT
:BUILD-SELECT
IF /I [%topt%]==[config] ( GOTO CONFIG-ONLY )
IF /I [%topt%]==[install] ( GOTO INSTALL-TARGET )
IF /I [%topt%]==[package] ( GOTO PKG-TARGET )
IF /I [%topt%]==[docs] (
GOTO DOCS-TARGET
) ELSE (
GOTO UD-TARGET
)
GOTO EOF

REM  --------------------------------------------------------------- CONFIG-ONLY
:CONFIG-ONLY
CD /D %buildd%
ECHO.
ECHO --------------------------------------------
ECHO  Configuring Build Tree
ECHO --------------------------------------------
ECHO.
cmake -G "MinGW Makefiles" -Wno-dev -D CMAKE_TOOLCHAIN_FILE=%tchain% ^
-D CMAKE_COLOR_MAKEFILE=OFF ^
-D CMAKE_BUILD_TYPE=%copt% ^
-D CMAKE_INSTALL_PREFIX=%installd% %srcd%
IF ERRORLEVEL 1 ( GOTO ERROR-CMAKE )
GOTO FINISH-CONFIG
GOTO EOF

REM  ---------------------------------------------------------------- USER GUIDE
:DOCS-TARGET
CD /D %buildd%
ECHO.
ECHO --------------------------------------------
ECHO  Building User Guide
ECHO --------------------------------------------
ECHO.
ECHO.
IF NOT EXIST Makefile ( GOTO DT1 )
IF /I [%reconfigure%]==[Yes] (
GOTO DT1
) ELSE (
GOTO DT2
)

:DT1
cmake -G "MinGW Makefiles" -Wno-dev -D CMAKE_TOOLCHAIN_FILE=%tchain% ^
-D CMAKE_BUILD_TYPE=%copt% ^
-D CMAKE_INSTALL_PREFIX=%installd% %srcd%
IF ERRORLEVEL 1 ( GOTO ERROR-CMAKE )
GOTO DT2

:DT2
IF /I [%clean-first%]==[Yes] (
mingw32-make -f Makefile clean >NUL 2>&1
)
ECHO.
cmake --build . --target docs
IF ERRORLEVEL 1 ( GOTO ERROR-CMAKE )
DIR /B %buildd%\doc\*.html >d.n & SET /P docname=<d.n & rm d.n
GOTO FINISH-UG

REM  ------------------------------------------------------------ INSTALL-TARGET
:INSTALL-TARGET
CD /D %buildd%
ECHO.
ECHO --------------------------------------------
ECHO  Building Install Target
ECHO --------------------------------------------
ECHO.
IF NOT EXIST Makefile ( GOTO IT1 )
IF /I [%reconfigure%]==[Yes] (
GOTO IT1
) ELSE (
GOTO IT2
)

:IT1
cmake -G "MinGW Makefiles" -Wno-dev -D CMAKE_TOOLCHAIN_FILE=%tchain% ^
-D CMAKE_BUILD_TYPE=%copt% ^
-D CMAKE_COLOR_MAKEFILE=OFF ^
-D CMAKE_INSTALL_PREFIX=%installd% %srcd%
IF ERRORLEVEL 1 ( GOTO ERROR-CMAKE )
GOTO IT2

:IT2
IF /I [%clean-first%]==[Yes] (
mingw32-make -f Makefile clean >NUL 2>&1
)
ECHO.
cmake --build . --target %topt% -- -j %JJ%
IF ERRORLEVEL 1 ( GOTO ERROR-CMAKE )
IF /I [%copt%]==[Debug] ( GOTO IT3 )
GOTO FINISH-INSTALL

:: DEBUG MAKE BATCH FILE -------------------------------------- DEBUG BATCH FILE
:IT3
ECHO -- Generating Debug Batch File
CD /D %installd%\bin
IF EXIST wsjtx.cmd (
DEL /Q wsjtx.cmd
)
>wsjtx.cmd (
ECHO @ECHO OFF
ECHO REM -- Debug Batch File
ECHO REM -- Part of the JTSDK v2.0 Project
ECHO SETLOCAL
ECHO TITLE WSJT-X Debug Terminal
ECHO SET PATH=.;.\data;.\doc;%fft%;%gccd%;%qt5d%;%qt5a%;%qt5p%;%hl3%
ECHO CALL wsjtx.exe
ECHO CD /D %dest%
ECHO ENDLOCAL
ECHO COLOR 0B
ECHO EXIT /B 0
)
GOTO FINISH-INSTALL

REM  ------------------------------------------------------------------- PACKAGE
:PKG-TARGET
CD /D %buildd%
ECHO.
ECHO --------------------------------------------
ECHO  Building Windows Installer
ECHO --------------------------------------------
ECHO.
REM The following line added by Steve VK3VM 30-4-2020 
REM removes an ald annoyance in final info screens !
ECHO Removing Old Install Packages (if exist)
if exist %buildd%\*-win64.exe del -f %buildd%\*-win64.exe 
IF NOT EXIST Makefile ( GOTO PT1 )
IF /I [%reconfigure%]==[Yes] (
GOTO PT1
) ELSE (
GOTO PT2
)

:PT1
cmake -G "MinGW Makefiles" -Wno-dev -D CMAKE_TOOLCHAIN_FILE=%tchain% ^
-D CMAKE_BUILD_TYPE=%copt% ^
-D CMAKE_INSTALL_PREFIX=%pkgd% %srcd%
IF ERRORLEVEL 1 ( GOTO ERROR-CMAKE )
GOTO PT2

:PT2
IF /I [%clean-first%]==[Yes] (
mingw32-make -f Makefile clean >NUL 2>&1
)
ECHO.
cmake --build . --target %topt% -- -j %JJ%
IF ERRORLEVEL 1 ( GOTO NSIS-ERROR )
DIR /B %buildd%\*-win64.exe >p.k & SET /P wsjtxpkg=<p.k & rm p.k
ECHO Copying package to^: %pkgd%
COPY /Y %buildd%\%wsjtxpkg% %pkgd% > NUL
GOTO FINISH-PKG

REM  ***************************************************************************
REM   FINISH MESSAGES
REM  ***************************************************************************
:FINISH-INSTALL
ECHO.
ECHO --------------------------------------------
ECHO  Build Summary
ECHO --------------------------------------------
ECHO.
ECHO   Description ...^: %desc%
ECHO   Version .......^: %aver%
ECHO   Type ..........^: %copt%
ECHO   Target ........^: %topt%
ECHO   Tool Chain ....^: %qtv%
ECHO   Clean .........^: %clean-first%
ECHO   Reconfigure ...^: %reconfigure%
ECHO   SRC ...........^: %srcd%
ECHO   Build .........^: %buildd%
ECHO   Install .......^: %installd%
ECHO.
GOTO FRUN

:: AUTO RUN ----------------------------------------------------------- AUTO RUN
:FRUN
IF /I [%autorun%]==[Yes] (
ECHO   JTSDK Option^ ..: Autorun Enabled
ECHO   Starting ......: wsjtx %aver% r%sver% %desc% in %copt% mode
GOTO FRUN1
) ELSE (
GOTO EOF
)

:FRUN1
IF /I [%copt%]==[Debug] (
CD /D %installd%\bin
CALL wsjtx.cmd
GOTO EOF
) ELSE (
CALL wsjtx.exe
GOTO EOF
)
GOTO EOF

:: ----------------------------------------------------------- FINISH CONFIG MSG
:FINISH-CONFIG
ECHO.
ECHO --------------------------------------------
ECHO  Configure Summary
ECHO --------------------------------------------
ECHO.
ECHO   Description .^: %desc%
ECHO   Version .....^: %aver%
ECHO   Type ........^: %copt%
ECHO   Target ......^: %topt%
ECHO   Tool Chain ..^: %qtv%
ECHO   Clean .........^: %clean-first%
ECHO   Reconfigure ...^: %reconfigure%
ECHO   SRC .........^: %srcd%
ECHO   Build .......^: %buildd%
ECHO   Install .....^: %installd%
ECHO.
ECHO   Config Only builds simply configure the build tree with
ECHO   default options. To further configure or re-configure this build,
ECHO   run the following commands:
ECHO.
ECHO   cd %buildd%
ECHO   cmake-gui .
ECHO   Once the CMake-GUI opens, click on Generate, then Configure
ECHO.
ECHO   You now have have a fully configured build tree. If you make 
ECHO   changes be sure click on Generate and Configure again.
ECHO.
ECHO   To return to the main menu, type: main-menu
ECHO.
GOTO EOF

:: ------------------------------------------------------------- FINISHED UG MSG
:FINISH-UG
ECHO.
ECHO --------------------------------------------
ECHO  User Guide Summary
ECHO --------------------------------------------
ECHO.
ECHO   Name ........^: %docname%
ECHO   Version .....^: %aver%
ECHO   Type ........^: %copt%
ECHO   Target ......^: %topt%
ECHO   Tool Chain ..^: %qtv%
ECHO   SRC .........^: %srcd%
ECHO   Build .......^: %buildd%
ECHO   Location ....^: %buildd%\doc\%docname%
ECHO.
ECHO   The user guide does ^*not^* get installed like normal install
ECHO   builds, it remains in the build folder to aid in browser
ECHO   shortcuts for quicker refresh during development iterations. 
ECHO.
ECHO   The name ^[ %docname% ^] also remains constant rather
ECHO   than including the version infomation.
ECHO.
GOTO EOF

:: ---------------------------------------------------------- FINISH PACKAGE MSG
:FINISH-PKG
ECHO.
ECHO --------------------------------------------
ECHO  Windows Installer Summary
ECHO --------------------------------------------
ECHO.
ECHO   Name ........^: %wsjtxpkg%
ECHO   Version .....^: %aver%
ECHO   Type ........^: %copt%
ECHO   Target ......^: %topt%
ECHO   Tool Chain ..^: %qtv%
ECHO   Clean .......^: %clean-first%
ECHO   Reconfigure .^: %reconfigure%
ECHO   SRC .........^: %srcd%
ECHO   Build .......^: %buildd%
ECHO   Location ....^: %pkgd%\%wsjtxpkg%
ECHO.
ECHO   To Install the package, browse to Location and
ECHO   run as you normally do to install Windows applications.
ECHO.
GOTO EOF

REM  ***************************************************************************
REM   HELP MESSAGES
REM  ***************************************************************************

:: ---------------------------------------------------------------- HELP OPTIONS
:HELP-OPTIONS
CLS
ECHO --------------------------------------------
ECHO  Default Build Commands
ECHO --------------------------------------------
ECHO.
ECHO  Usage .....^: jtbuild ^[ OPTION ^]
ECHO  Example....^: jtbuild rinstall
ECHO.
ECHO  OPTIONS:
ECHO     rconfig    Release, Config Only
ECHO     dconfig    Debug, Config Only
ECHO     rinstall   Release, Non-packaged Install
ECHO     dinstall   Debug, Non-packaged Install
ECHO     package    Release, Windows Package
ECHO     docs       Release, User Guide
ECHO.
ECHO  ^* To Display this message, type .....^: jtbuild ^-h
ECHO.
GOTO EOF

:: ----------------------------------------------------------- OPTION STATUS MSG
:OPTION-STATUS
//dotnet %JTSDK_HOME%\tools\apps\JTConfig.dll -l
ECHO No Longer Implemented.
ECHO .
PAUSE
GOTO EOF

REM  ***************************************************************************
REM   ERROR MESSAGES
REM  ***************************************************************************
:ERROR-CMAKE
ECHO.
ECHO --------------------------------------------
ECHO  CMAKE BUILD ERROR
ECHO --------------------------------------------
ECHO.
ECHO  There was a problem building ^( %desc% ^)
ECHO.
ECHO  Check the screen for error messages, correct, then try to
ECHO  re-build ^( jtbuild %desc% %copt% %topt% ^)
ECHO.
ECHO.
GOTO EOF

:NSIS-ERROR
ECHO.
ECHO --------------------------------------------
ECHO  WINDOWS INSTALLER BUILD ERROR
ECHO --------------------------------------------
ECHO.
ECHO  There was a problem building the package, or the script
ECHO  could not find:
ECHO.
ECHO  %buildd%\%WSJTXPKG%
ECHO.
ECHO  Check the Cmake logs for any errors, or correct any build
ECHO  script issues that were obverved and try to rebuild the package.
ECHO.
GOTO EOF

:FIRST-RUN
:: generate build.txt file if not exist --------------------------------------

MKDIR %JTSDK_HOME%\tmp >NUL 2>&1

>%JTSDK_HOME%\tmp\build.txt (
ECHO # This file is auto-generated by : %~n0.cmd
ECHO.
ECHO # For use with jtbuild.cmd only.
ECHO # - Only the paths needs to be changed, not the prefix
ECHO # - Do not use spaces in the paths as the build will fail
ECHO # - Ensure there is only one space between the prefix and path
ECHO.
ECHO # Edit the next line to set Source Location
ECHO SRCD %JTSDK_HOME%\tmp\wsjtx
ECHO.
ECHO # Edit the next line to set Destination Directory
ECHO DEST %JTSDK_HOME%\tmp\wsjtx-output
ECHO.
ECHO # END Default Text File
)
::CLS
ECHO.
ECHO --------------------------------------------
ECHO  First Run of jtbuild
ECHO --------------------------------------------
ECHO.
ECHO  A file named %JTSDK_HOME%\tmp\build.txt
ECHO  was auto-generated.
ECHO.
ECHO  Check this file to ensure srcd and dest
ECHO  values are set to the appropriate locations.
ECHO.
ECHO  If need be, clone the source code repository from
ECHO  Sourceforge first, then set the location values
ECHO  as appropriate.
ECHO. 
ECHO  After verifying the build.txt file, re-run
ECHO  your commands.
ECHO.
GOTO EOF

REM  ***************************************************************************
REM  END QTENV-BUILD-WSJTX.CMD
REM  ***************************************************************************

:NOSOURCE
cls
echo.
echo --------------------------------------------
echo  NO SOURCE CODE
echo --------------------------------------------
echo.
echo Place ONE of the following marker files in %cfgd%
echo.
echo ^- src-wsjtx ..... Pull git package for WSJT-X 
echo                   ^(Set for a custom package^)    
echo ^- src-jtdx ...... Pull git package for JTDX
echo ^- src-js8call ... Pull git package for JS8CALL
echo.
goto EOF

:NOVERSIONS
cls
echo.
echo --------------------------------------------
echo  NO ^'Versions.cmake^' IN SOURCE CODE
echo --------------------------------------------
echo.
echo No Versions.cmake file. Please create in %srcd%
echo.
echo Sample Versions.cmake
echo.
echo # Version number components
echo set (WSJTX_VERSION_MAJOR 2)
echo set (WSJTX_VERSION_MINOR 3)
echo set (WSJTX_VERSION_PATCH 0)
echo set (WSJTX_RC 2)                 # release candidate number, comment out or zero for development versions
echo set (WSJTX_VERSION_IS_RELEASE 0) # set to 1 for final release build 
goto EOF

:EOF
POPD
PUSHD %JTSDK_HOME%\tools\msys64\usr\bin
ren sh-bak.exe sh.exe >NUL 2>&1
POPD
:END
EXIT /B 0