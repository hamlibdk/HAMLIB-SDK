#-----------------------------------------------------------------------------::
# Name .........: jtsdk64.ps1
# Project ......: Part of the JTSDK64 Tools Project
# Version ......: 3.4.1 Beta
# Description ..: Main Development Environment Script
#                 Sets environment variables for development and MSYS2
# Original URL .: https://github.com/KI7MT/jtsdk64-tools.git
# Project URL ..: https://sourceforge.net/projects/hamlib-sdk
# Usage ........: Call this file directly from the command line
# 
# Author .......: Hamlib SDK Contributors <hamlibdk@outlook.com>
#
# Concept ......: Greg Beam, KI7MT, <ki7mt@yahoo.com>
#
# Copyright ....: (C) 2013-2021 Greg Beam, KI7MT
#                 (C) 2020-2024 JTSDK Contributors
# License ......: GPL-3
#
# Adjustments...: Steve VK3VM 8-12-2020 to 5-06-2021
#				: Need for qt-gen-tc.cmd and some markers eliminated 5-06-2021 Steve VK3VM
#               : Refactoring and modularisation 26-02-2021 Steve VK3VM
#               : Support for Tools Package supplied PortAudio 5-06-2021 Steve VK3VM
#               : General maintenance and Support for DLL Builds 2/3-01-2022 Steve VK3VM
#               : Read LibUSB DLL path from Versions.ini 6-1-2022 Steve VK3VM
#               : Reorganisation for MSYS2 Paths Not added to Environment Path by preference
#                 mitigating an evolving JTSDK architectural flaw 11/1/2022 Steve VK3VM
#               : Added in a FUDGE (add .NET directories to path) so that JTDX builds can  
#                 complete its packaging. 14/1/2022 Mike W9MDB & Steve VK3VM
#               : Fudge to handle MinGW 9.0.0 Tools with Qt 18-1-2022 Steve VK3VM
#               : Refactoring to cater for Qt 6.2.2 and MinGW 9.0.0 18-19-1-2022 Steve VK3VM 
#               : Further refactoring as Qt 6.2.2 and later now refers to MinGW 11.2.0 16-05-2022 Uwe DG2YCB with Steve VK3VM
#               : Improvements and refactoring preparing for HLSDK (JTSDK) 4.0 02/03-06-202 Coordinated by Steve VK3VM
#               --> Primarily fixes to better support the kit residing on drives rather than just C:
#               : Addition of PSS for support for Powershell interpreter to be used 10-1-2024 Steve I VK3VM
#               : Inclusion of CMAKE config variables to fins LibUSB 14-7-2024 Steve I VK3VM
#               : Major enhancements and removal of "Fudges" to hopefully support Qt 6.7 and MinGW 13.1  18-9-2024 Steve I VK3VM
#               : Minor legacy bugfix with JTSDK_MSYS2_F fixed 18-9-2024 Steve I VK3VM
#
#-----------------------------------------------------------------------------::

# --- GENERATE ERROR ----------------------------------------------------------

function GenerateError($type) {
	Write-Host ""
	Write-Host "*** Error: $type ***"
	Write-Host ""
	pause
	exit($code)
}

# --- Create Folders ----------------------------------------------------------
# --> Perhaps redundant? Review necessity of this in the future ***

function CreateFolders {

	Write-Host "* Creating essential directories if they do not exist"
	if (!(Test-Path $env:JTSDK_CONFIG)) { 
		New-Item -Path $env:JTSDK_HOME -Name  "config" -ItemType "directory" | Out-Null
		Write-Host "  --> Created $env:JTSDK_CONFIG"	
	}
	if (!(Test-Path $env:JTSDK_SRC)) { 
		New-Item -Path $env:JTSDK_HOME -Name "src" -ItemType "directory"  | Out-Null 
		Write-Host "  --> Created $env:JTSDK_SRC"
	}
	if (!(Test-Path $env:JTSDK_TMP)) { 
		New-Item -Path $env:JTSDK_HOME -Name "tmp" -ItemType "directory"  | Out-Null 
		Write-Host "  --> Created $env:JTSDK_TMP"
	}
	if (!(Test-Path $env:JTSDK_SCRIPTS)) { 
		New-Item -Path $env:JTSDK_TOOLS -Name "\scripts" -ItemType "directory"  | Out-Null 
		Write-Host "  --> Created $env:JTSDK_SCRIPTS"
	}
}

# --- CONVERT FORWARD ---------------------------------------------------------
# --> Converts to Unix/MinGW/MSYS2 Path format !

function ConvertForward($inValue) {
	$inValue = ($inValue).substring(0,1).tolower() + ($inValue).substring(1)
	$inValue = ($inValue).replace("\","/")
	$inValue = ($inValue).Insert(0,'/')
	return $inValue.replace(":","")
}

# --- CONVERT NUMBER  ---------------------------------------------------------
# --> Converts input string into numbers only

function ConvertNumber($inValue) {
	$retval = $inValue -replace '\D+(\d+)\D+','$1'
	return [int]$retval
}

# --- SQlite ------------------------------------------------------------------

function SetSQLiteEnviron ($configTable) {
	$env:sqlitev = $configTable.Get_Item("sqlitev")
	$env:sqlite_dir = $env:JTSDK_TOOLS + "\sqlite\" + $env:sqlitev
	$env:sqlite_dir_f = ConvertForward($env:sqlite_dir)
	$env:JTSDK_PATH += ";"+$env:sqlite_dir   
}

# --- FFTW --------------------------------------------------------------------

function SetFFTWEnviron($configTable, [ref]$fftw3f_dir_ff) {
	$env:fftwv = $configTable.Get_Item("fftwv")
	$env:fftw3f_dir = $env:JTSDK_TOOLS + "\fftw\" + $env:fftwv
	$fftw3f_dir_ff.Value = ($env:fftw3f_dir).replace("\","/")
	$env:fftw3f_dir_f = ConvertForward($env:fftw3f_dir)
	$env:JTSDK_PATH += ";"+$env:fftw3f_dir
}

# --- LibUSB ------------------------------------------------------------------

function SetLibUSBEnviron ($configTable, [ref]$lusb_dir_ff) {
	$env:libusbv = $configTable.Get_Item("libusbv")	
	$env:libusb_dir = $env:JTSDK_TOOLS + "\libusb\" + $env:libusbv
	$lusb_dir_ff.Value = ($env:libusb_dir).replace("\","/")
	$env:libusb_dir_f = ConvertForward($env:libusb_dir)
	$env:JTSDK_PATH += ";"+$env:libusb_dir
	$env:libusb_dll = $configTable.Get_Item("libusbdll")	
}

# --- Nullsoft Installer System - NSIS ----------------------------------------

function SetNSISEnviron ($configTable) {
	$env:nsisv = $configTable.Get_Item("nsisv")	
	$env:nsis_dir = $env:JTSDK_TOOLS + "\nsis\" + $env:nsisv
	$env:nsis_dir_f = ConvertForward($env:nsis_dir)
	$env:JTSDK_PATH += ";" + $env:nsis_dir
}

# --- Package Config ----------------------------------------------------------

function SetPkgConfigEnviron ($configTable) {
	$env:pkgconfigv = $configTable.Get_Item("pkgconfigv")
	$env:pkgconfig_dir = $env:JTSDK_TOOLS + "\pkgconfig\" + $env:pkgconfigv
	$env:pkgconfig_dir_f = ConvertForward($env:pkgconfig_dir)
	$env:JTSDK_PATH += ";" + $env:pkgconfig_dir
}

# --- Ruby --------------------------------------------------------------------

function SetRubyEnviron($configTable, [ref]$ruby_dir_ff) {
	$env:rubyv = $configTable.Get_Item("rubyv")	
	$env:ruby_dir = $env:JTSDK_TOOLS + "\ruby\" + $env:rubyv
	$ruby_dir_ff.Value = ($env:ruby_dir).replace("\","/")
	$env:ruby_dir_f = ConvertForward($env:ruby_dir)
	$env:JTSDK_PATH += ";" + $env:ruby_dir
}

# --- Subversion --------------------------------------------------------------

function SetSubversionEnviron ($configTable, [ref]$svn_dir_ff) {

	$env:svnv = $configTable.Get_Item("svnv")
	$env:svn_dir = $env:JTSDK_TOOLS + "\subversion\" + $env:svnv
	$svn_dir_ff.Value = ($env:svn_dir).replace("\","/")
	$env:svn_dir_f = ConvertForward($env:svn_dir)
	$env:JTSDK_PATH += ";" + $env:svn_dir
}

# --- CMake -------------------------------------------------------------------

function SetCMakeEnviron ($configTable) {

	Write-Host -NoNewLine "* CMake source: "
	$env:cmakev = $configTable.Get_Item("cmakev")	
	if ($env:cmakev -eq "qtcmake") {		# Use the CMAKE Supplied with Qt
		$env:cmake_dir = $env:JTSDK_TOOLS + "\Qt\Tools\CMake_64\bin"
		Write-Host "Qt deployment"
	} else {								# CMAKE-PACKAGED: Found in C:\JTSDK64-Tools\tools\cmake\x.xx.x 
		$env:cmake_dir = $env:JTSDK_TOOLS + "\cmake\" + $env:cmakev + "\bin"
		Write-Host "$env:cmake_dir"
	}
	$env:cmake_dir_f = ConvertForward($env:cmake_dir)
	$env:JTSDK_PATH += ";" + $env:cmake_dir
}

# --- Scripts Directory ------------------------------------------------------

function SetScriptDir {
	$env:scripts_dir = $env:JTSDK_TOOLS + "\scripts\"
	$env:scripts_dir_f = ConvertForward($env:scripts_dir)
	$env:JTSDK_PATH += ";" + $env:scripts_dir
}

# --- Qt ----------------------------------------------------------------------

function CheckQtDeployment {

	Write-Host "* Checking Qt Deployment"

	$listQtDeploy = Get-ChildItem -Path $env:JTSDK_CONFIG -EA SilentlyContinue
	$subPathQtStore = "NULL";
	ForEach ($subPathQt in $listQtDeploy)
	{    
		if ($subPathQt.Name -like 'qt*') {
			Write-Host "  --> Found Qt configuration marker `[$subPathQt`] in $env:JTSDK_CONFIG"
			$subPathQtStore = $subPathQt
			$env:QTV = $subPathQt.Name.substring(2)
			break
		}
	}

	# Defaults to and sets for Qt 5.15.2 (base Qt version) if no default file found
	if ($subPathQtStore -eq "NULL") {
		Write-Host "  --> No Qt configuration marker: Setting default `[Qt 5.15.2`]"
		$tmpOut = $env:JTSDK_CONFIG + "\qt5.15.2"
		Out-File -FilePath $tmpOut
		$env:QTV = "5.15.2"    
	}

	# Thanks to Mike Black W9MDB for the concept for the script below.

	$listQtDeploy = Get-ChildItem -Path $env:JTSDK_TOOLS\qt -EA SilentlyContinue                 

	$env:VER_MINGW_GCC=" " 			# NOTE: $env:QTV contains the QT Version!	
	$countMinGW = 0					#       $subPathQt contains name of Qt version from marker

	ForEach ($subPathQt in $listQtDeploy)
	{
		$listSubUnderQtDir = Get-ChildItem -Path $env:JTSDK_TOOLS\qt\$subPathQt -EA SilentlyContinue
		if ($subPathQt -Match "[1-9]") {
			ForEach ($itemListSubUnderQtDir in $listSubUnderQtDir) {
				if ($subPathQt.Name -eq $env:QTV) {
					if (($itemListSubUnderQtDir -like '*64')) {
						$env:VER_MINGW_GCC = $itemListSubUnderQtDir
						if ($itemListSubUnderQtDir -like 'mingw*') {
							$countMinGW = $countMinGW + 1
							break
						}
					}   
				}
			}
		}
	}

	if ($countMinGW -eq 1) 
	{
		Write-Host "  --> Qt Version Deployed: `[$env:QTV`] MinGW Directory: `[$env:VER_MINGW_GCC`]" # - contains MinGW Release
	} else {
		GenerateError("NO Qt DEPLOYMENT or MULTIPLE Qt MARKERS SET IN $env:JTSDK_CONFIG. PLEASE CORRECT")
	}
}

# --- Set Qt Environment variables --------------------------------------------
# --> MinGW environs need be set for detected version in $env:VER_MINGW_GCC

function SetQtEnvVariables ([ref]$QTBASE_ff, [ref]$QTD_ff, [ref]$GCCD_ff, [ref]$QTP_ff) {

	# Validate Support
	$locQTV =ConvertNumber($env:QTV) 
	#Write-Host $locQTV
	#Read-Host -Prompt "Press any key to continue"
	if ( $locQTV -ge 600 ) 
	{
		if ( $locQTV -lt 630 ) 
		{
			GenerateError("UNSUPPORTED Qt6 VERSION. Use Qt Version 6.3.0 or Greater.")
		}
	}

	$env:QTBASE=$env:JTSDK_TOOLS + "\Qt\" + $env:QTV
	$env:QTBASE_F = ConvertForward($env:QTBASE)
	$QTBASE_ff.Value = ($env:QTBASE).replace("\","/")

	$env:QTD=$env:QTBASE + "\" + $env:VER_MINGW_GCC+"\bin"
	$env:QTD_F = ConvertForward($env:QTD)
	$QTD_ff.Value = ($env:QTD).replace("\","/")
	
	$env:QTP=$env:QTBASE + "\" + $env:VER_MINGW_GCC + "\plugins\platforms"
	$env:QTP_F = ConvertForward($env:QTP)
	$QTP_ff.Value = ($env:QTP).replace("\","/")
	
	$my_string = $env:QTV.Replace(".", "")
	
	# lets say we are using Qt 5.15.13 . Converted to an integer this becomes 51513.
	# the most common version is Qt 5.15.2. Converted to an nteger this becomes 5152.
	# To compare the two (properly) we need multiply 5152 by 10 then !
	#
	# Lets assume we are using Qt 6.3.3. AS an intenger tthis becomes 644. Its a later
	# version than Qt 5.15.13 - inter 51513. So to compare and to show that 633 islater 
	# than 5.15.13 we need multiply 633 by 100. Multiplying by 100 is the most common
	
	$mult = 100;
	if ( $my_string.length -eq 3 ) { $mult = 100 }		# This handles the minimum i.e. 6.3.3
	if ( $my_string.length -eq 4 ) { $mult = 10 }		# This handles 5152 i.e. 5.15.2
	if ( $my_string.length -eq 5 ) { $mult = 1 }		# The maximum version size i.e 51513 for 6.15.13
	
	$int_ver_min_gcc = [int]$env:QTV.Replace(".", "")
	
	$env:GCC_MINGW = "mingw810_64"					# Qt 5.15.2 as a primer/start point
	if ( ($int_ver_min_gcc * $mult) -lt 51520 ) { GenerateError("This kit does not support Qt versions below Qt 5.15.2" )}
	if ( ($int_ver_min_gcc * $mult) -ge 62200 ) { $env:GCC_MINGW = "mingw1120_64" }
	if ( ($int_ver_min_gcc * $mult) -ge 67000 ) { $env:GCC_MINGW = "mingw1310_64" }
	
	# $env:GCC_MINGW=$env:VER_MINGW_GCC					# possibly redundant ??? 
	$env:GCCD=$env:JTSDK_TOOLS + "\Qt\Tools\"+$env:GCC_MINGW+"\bin"
	$GCCD_ff.Value = ($env:GCCD).replace("\","/")
	$env:GCCD_F = ConvertForward($env:GCCD)
	
	# Note: This is the NEW First occurence of JTSDK_PATH
	$env:JTSDK_PATH=";" + $env:GCCD + ";" + $env:QTD + ";" + $env:QTP + ";" + $env:QTP + "\lib" 
	
	Write-Host "* Setting environment variables for Qt"
	Write-Host "  --> QTBASE ----> $env:QTBASE"
	Write-Host "  --> QTBASE_F --> $env:QTBASE_F"
	Write-Host "  --> QTD -------> $env:QTD"
	Write-Host "  --> QTD_F -----> $env:QTD_F"
	Write-Host "  --> QTP -------> $env:QTP"
	Write-Host "  --> QTP_F -----> $env:QTP_F"
	Write-Host "  --> GCCD ------> $env:GCCD"
	Write-Host "  --> GCCD_F ----> $env:GCCD_F"
}

# --- CHECK BOOST DEPLOY IS FOR CORRECT MINGW VERSION -------------------------
# --> Get from examing nomenclature in C:\JTSDK64-Tools\tools\boost\<ver>\lib
#     i.e. xxxx-mgw8-XXX for MinGW 8.1    xxxx-mgw7-XXX for MinGW 7.3	
#          As of Qt 6.2.2 MinGW 11.2.0 is deployed so format xxxx-mgw11-XXX
#          As of Qt 6.7.0 MinGW 13.2.0 is deployed so format xxxx-mgw13-XXX

function CheckBoostCorrectQtmingwDirVersion($boostDir) {
	$retval = "Not Found"
		
	$listBoostDeploy = Get-ChildItem -Path "$boostDir\lib" -EA SilentlyContinue

	ForEach ($subPathBoost in $listBoostDeploy)
	{    
		if ($subPathBoost.Name -like '*-mgw13-*') {
			# More than Likely GCC13.1 >= Qt 6.7.0 with MinGW 13.1 or later
			# Needs a better method
			$retval="mingw_64"			# As found in x:\JTSDK64-Tools\tools\Qt\6.7.x
			break
		}
		if ($subPathBoost.Name -like '*-mgw11-*') {
			# More than Likely GCC11 and >= Qt 6.2.2 with MinGW 11.2.0 or later
			# Needs a better method		# As found in x:\JTSDK64-Tools\tools\Qt\6.2.2 or later
			$retval="mingw_64"
			break
		}
		if ($subPathBoost.Name -like '*-mgw8-*') {
			$retval="mingw81_64"
			break
		}
		if ($subPathBoost.Name -like '*-mgw7-*') {
			$retval="mingw73_64"
			break
		}
	}
 
	return $retVal
}

# --- SETUP AND CHECK BOOST DEPLOYMENT ----------------------------------------

function SetCheckBoost {

	$env:boostv = $configTable.Get_Item("boostv")
	$env:BOOST_STATUS  = "Non Functional"
	$env:boost_dir = $env:JTSDK_TOOLS + "\boost\" + $env:boostv
	$env:boost_dir_f = ConvertForward($env:boost_dir)
	
	Write-Host "* Checking Boost Deployment"
	
	if ((Test-Path "$env:JTSDK_TOOLS\boost\$env:boostv")) { 

		$env:JTSDK_PATH += ";" + $env:boost_dir + "\lib"
		Write-Host -NoNewLine "  --> Version `[$env:boostv`] should be compiled and deployed under the "
		$env:BOOST_V_MINGW = CheckBoostCorrectQtmingwDirVersion($env:boost_dir)
		Write-Host "`[Qt $env:QTV/$env:BOOST_V_MINGW`] and MSYS2/MinGW environments."
		Write-Host -NoNewLine "  --> Status: "
		if ( $env:BOOST_V_MINGW -ne "Not Found" ) {
			$env:BOOST_STATUS="Functional"
			Write-Host "Functional"
		} else {
			Write-Host "*** NON FUNCTIONAL FOR JTSDK USE *** $env:BOOST_V_MINGW $env:VER_MINGW_GCC"
		}
	} else {
		
		Write-Host "  --> *** BOOST NOT DEPLOYED ***"
		Write-Host "  --> Provide library for Qt $env:QTV to $env:JTSDK_TOOLS\boost\$env:boostv"
	}
}

# --- UNIX TOOLS --------------------------------------------------------------
# --> Unix marker files deprecated where practical to settings in Versions.ini
# --> Unix Tools preferably now to be DISABLED 11/1/2022 Steve VK3VM

function SetUnixTools {
	Write-Host -NoNewLine "* Unix Tools configuration in `'Versions.ini`': " 
	$tmpUnixToolsValue = $configTable.Get_Item("unixtools")
	
	if (($tmpUnixToolsValue -eq "enabled") -or ($tmpUnixToolsValue -eq "yes")) {	
		$unixDir1 = $env:JTSDK_TOOLS + "\msys64"
		$unixDir2 = $env:JTSDK_TOOLS + "\msys64\usr\bin"
		$env:JTSDK_PATH += ";" + $unixDir1 + ";" + $unixDir2 + ";"  
		$env:UNIXTOOLS = "enabled"
		Write-Host "ENABLED ==> MSYS2 Tools ADDED to System Path"
	} else {
		Write-Host "DISABLED ==> MSYS2 Tools NOT ADDED to System Path (recommended)"
	}
}

# --- Hamlib Dirs -------------------------------------------------------------
	
function SetHamlibDirs {
	$env:hamlib_base=$env:JTSDK_TOOLS + "\hamlib"
	$env:hamlib_base_f = ConvertForward($env:hamlib_base)
	return ($env:hamlib_base).replace("\","/")
}

# --- SET HAMLIB REPO SOURCE --------------------------------------------------

function SetHamlibRepo {
	Write-Host -NoNewLine "* Hamlib Repository Source: "

	# This logic works - assuming only one marker...
	$env:HLREPO = "NONE"
	if (Test-Path "$env:JTSDK_CONFIG\hlmaster") { $env:HLREPO = "MASTER" }
	# The next repo has been deprecated. It is here as an example - but it may not work.
	if (Test-Path "$env:JTSDK_CONFIG\hlw9mdb") { $env:HLREPO = "W9MDB" }
	Write-Host "$env:HLREPO"
	if ($env:HLREPO -eq "NONE") {
		Write-Host "  --> Please set a repository source marker in $env:JTSDK_CONFIG"
	}
}

# --- PortAudio Dirs ----------------------------------------------------------
	
function SetPortAudioDirs ([ref]$pa_dir_ff) {
	$env:portaudio_dir = $env:JTSDK_TOOLS + "\portaudio"
	$pa_dir_ff.Value = ($env:portaudio_dir).replace("\","/")
	$env:portaudio_dir_f = ConvertForward($env:portaudio_dir)
}

# --- Generate Qt Tool Chain Files --------------------------------------------

function GenerateToolChain ($qtbaseff, $qtdff, $gccdff, $rubyff, $fftw3fff, $palibff, $lusbff, $hamlibff, $svnff) {

	$QTVR = $env:QTV -replace "\.",''

	$of = $env:JTSDK_TOOLS + "\tc-files\QT"+$QTVR+".cmake"
	
	Write-Host "* Generating JT-software Qt Tool Chain Files for Qt $env:QTV"

	$LTOOLS_PATH = $env:JTSDK_TOOLS + "\tc-files"

	# --- Create tc-files if it does not exist --------------------------------

	if (-not (Test-Path $LTOOLS_PATH)) { 
		New-Item -Path $env:JTSDK_TOOLS -Name "tc-files" -ItemType "directory" | Out-Null
		Write-Host "  --> `'tc-files`' does not exist. Creating $LTOOLS_PATH"
	}

	# Assumed: Line "SET (CMAKE_FIND_ROOT_PATH `$`{JTSDK_TOOLS}) points to JTSDK_TOOLS"

	New-Item -Force $of > $null
	Add-Content $of "# This file is auto-generated by : $PSCommandPath version $jtsdk64Version" 
	Add-Content $of "# Tool Chain File for Qt $env:QTV"
	Add-Content $of " "
	Add-Content $of "# System Type and Based Paths"
	Add-Content $of "SET (CMAKE_SYSTEM_NAME Windows)"
	Add-Content $of "SET (QTDIR $qtdff)"
	Add-Content $of "SET (GCCD $gccdff)"
	Add-Content $of " "
	Add-Content $of "# AsciiDoctor"
	Add-Content $of "SET (ADOCD $rubyff)"
	Add-Content $of " "
	Add-Content $of "# FFTW"
	Add-Content $of "SET (FFTWD $fftw3fff)"
	Add-Content $of "SET (FFTW3_LIBRARY $fftw3fff/libfftw3-3.dll)"
	Add-Content $of "SET (FFTW3F_LIBRARY $fftw3fff/libfftw3f-3.dll)"
	Add-Content $of " "
	Add-Content $of "# LibUSB"
	Add-Content $of "SET (LUSB $lusbff )"
	Add-Content $of " "
	Add-Content $of "# Hamlib"
	Add-Content $of "SET (HLIB $hamlibff/qt/$env:QTV)"
	Add-Content $of " "
	Add-Content $of "# Subversion"
	Add-Content $of "SET (SVND $svnff)"
	Add-Content $of " "
	Add-Content $of "# PortAudio"
	Add-Content $of "SET (PALIB $palibff)"
	Add-Content $of "SET (PALIB_LIBRARY $palibff/lib/libportaudio.dll)"
	Add-Content $of " "
	Add-Content $of "# Cmake Consolidated Variables"
	Add-Content $of "SET (CMAKE_PREFIX_PATH `$`{GCCD} `$`{QTDIR} `$`{LUSB} `$`{HLIB} `$`{HLIB}/bin `$`{HLIB}/lib `$`{ADOCD} `$`{FFTWD} `$`{FFTW3_LIBRARY} `$`{FFTW3F_LIBRARY} `$`{SVND} `$`{PALIB} `$`{PALIB_LIBRARY})"
	Add-Content $of "SET (CMAKE_FIND_ROOT_PATH `$`{JTSDK_TOOLS})"
	Add-Content $of "SET (CMAKE_FIND_ROOT_PATH_PROGRAM NEVER)"
	Add-Content $of "SET (CMAKE_FIND_ROOT_PATH_LIBRARY BOTH)"
	Add-Content $of "SET (CMAKE_FIND_ROOT_PATH_INCLUDE BOTH)"
	Add-Content $of " "
	Add-Content $of "# END Cmake Tool Chain File"
}

# --- JT Source Selection Check -----------------------------------------------

function CheckJTSourceSelection {
	$env:JT_SRC="Missing"
	$listSrcDeploy = Get-ChildItem -Path $env:JTSDK_CONFIG -EA SilentlyContinue
	ForEach ($subPathSrc in $listSrcDeploy)
	{    
		if ($subPathSrc.Name -like 'src*') {
			Write-Host "* Found JT- source configuration marker `[$subPathSrc`] in $env:JTSDK_CONFIG"
			$env:JT_SRC = $subPathSrc.Name.substring(4)
			break
		}
	}

	if ( $env:JT_SRC -eq "Missing") {
		Write-Host "  --> JT- source selection marker is missing."
		GenerateError("Please put source selection marker in X:\JTSDK64-Tools\config")
	}
}

# ##############################################################################
#  PowerShell Interactive Build Environment
# ##############################################################################
# --> Size kept minimal to avoid running out of CMD environment space
# --> Invoking PowerShell through a CMD shell prevents many security warnings !

function InvokeInteractiveEnvironment {
	invoke-expression 'cmd /c start $PSS -NoExit -Command {                           `                `
		$host.UI.RawUI.WindowTitle = "JTSDK64 Tools"
		$Host.UI.RawUI.BackgroundColor = "Black"
		New-Alias msys2 "$env:JTSDK_TOOLS\msys64\msys2.exe"	
		New-Alias mingw32 "$env:JTSDK_TOOLS\msys64\mingw32.exe"	
		New-Alias mingw64 "$env:JTSDK_TOOLS\msys64\mingw64.exe"	
		Clear-Host
		Write-Host "-------------------------------------------------"
		Write-Host "            JTSDK x64 Tools $env:JTSDK64_VERSION"
		Write-Host "-------------------------------------------------"
		Write-Host ""
		Write-Host "Config: $env:JTSDK_VC"
		Write-Host ""
		Write-Host -NoNewLine "MSYS2 Path: "
		if ( $env:UNIXTOOLS -eq "enabled") {
			Write-Host "$env:JTSDK_MSYS2"
		} else {
			Write-Host "$env:UNIXTOOLS"
		}	
		Write-Host ""
		Write-Host "Package       Version/Status"
		Write-Host "-------------------------------------------------"
		Write-Host "Source .....: $env:JT_SRC" 
		if ((Test-Path "$env:JTSDK_TOOLS\qt\$env:qtv")) { 
			Write-Host "Qt .........: $env:QTV/$env:VER_MINGW_GCC, Tools/$env:GCC_MINGW "
		} else {
			Write-Host "Qt .........: $env:QTV Missing"
		}
		Write-Host -NoNewLine "Hamlib .....: "
		if ((Test-Path "$env:hamlib_base\qt\$env:QTV")) { 
			if (Test-Path "$env:hamlib_base\qt\$env:QTV\lib\libhamlib.dll.a") {
				Write-Host "Dynamic"
			} else {
				Write-Host "Static"
			}
		} else {
			Write-Host "Missing"
		}
		if ((Test-Path "$env:fftw3f_dir")) { 
			Write-Host "FFTW .......: $env:fftwv"
		} else {
			Write-Host "FFTW .......: $env:fftwv Missing"
		}
		if ((Test-Path "$env:libusb_dir")) { 
			Write-Host "LibUSB .....: $env:libusbv"
		} else {
			Write-Host "LibUSB .....: $env:libusbv Missing"
		}
		if ((Test-Path "$env:nsis_dir")) { 
			Write-Host "NSIS .......: $env:nsisv"
		} else {
			Write-Host "NSIS .......: $env:nsisv Missing"
		}
		if ((Test-Path "$env:pkgconfig_dir")) { 
			Write-Host "PkgConfig ..: $env:pkgconfigv"
		} else {
			Write-Host "PkgConfig ..: $env:pkgconfigv Missing"
		}
		if ((Test-Path "$env:ruby_dir")) { 
			Write-Host "Ruby .......: $env:rubyv"
		} else {
			Write-Host "Ruby .......: $env:rubyv Missing"
		}
		if ((Test-Path "$env:svn_dir")) { 
			Write-Host "Subversion .: $env:svnv"
		} else {
			Write-Host "Subversion .: $env:svnv Missing"
		}
		Write-Host -NoNewLine "CMake ......: $env:cmakev "
		if ($env:cmakev -eq "qtcmake") {
			Write-Host ""
		} else {
			if ((Test-Path "$env:cmake_dir")) { 
				Write-Host ""
			} else {
				Write-Host "Missing"
			}
		}
		if ((Test-Path "$env:boost_dir")) { 
			Write-Host "Boost ......: $env:boostv $env:BOOST_STATUS for $env:GCC_MINGW"
		} else {
			Write-Host "Boost ......: $env:boostv Missing"
		}

		Write-Host "-------------------------------------------------"
		Write-Host ""
		Write-Host " Build Boost .......: Deploy-Boost"
		Write-Host " MSYS2 Environment .: mingw64"
		Write-Host " Build JTware ......: jtbuild `[option`]"
		Write-Host ""
	}'
}

# #############################################################################
# MAIN LOGIC
# #############################################################################

# --- Application Information -------------------------------------------------


$jtsdk64Version = [IO.File]::ReadAllText($PSScriptRoot+"\ver.jtsdk")
$env:JTSDK64_VERSION = $jtsdk64Version
$host.ui.RawUI.WindowTitle = "JTSDK64 Tools " + $jtsdk64Version

# -----------------------------------------------------------------------------
#  START MESSAGE
# -----------------------------------------------------------------------------

Clear-Host
Write-Host "---------------------------------"
Write-Host "  JTSDK64 Core Tools $jtsdk64Version"
Write-Host "---------------------------------"
Write-Host ""
Write-Host "*  Starting jtsdk64.ps1 in $PSScriptRoot"
Write-Host ""
Set-Location -Path $PSScriptRoot

# --- GLOBAL ENVIRONMENT VARIABLES and PATHS ----------------------------------

Write-Host "* Setting essential PowerShell/MSYS2 cross-environment variables"
$env:UNIXTOOLS = "Disabled"
$env:HLREPO = "NONE"
$env:JTSDK_HOME = $PSScriptRoot 
$env:JTSDK_HOME_F = ConvertForward($env:JTSDK_HOME) 
$env:JTSDK_CONFIG = $env:JTSDK_HOME + "\config"
$env:JTSDK_CONFIG_F = ConvertForward($env:JTSDK_CONFIG)
$env:JTSDK_SRC = $env:JTSDK_HOME + "\src"
$env:JTSDK_SRC_F = ConvertForward($env:JTSDK_SRC) 
$env:JTSDK_TMP = $env:JTSDK_HOME + "\tmp"
$env:JTSDK_TMP_F = ConvertForward($env:JTSDK_TMP)
$env:JTSDK_TOOLS = $env:JTSDK_HOME + "\tools"
$env:JTSDK_TOOLS_F = ConvertForward($env:JTSDK_TOOLS)
$env:JTSDK_SCRIPTS = $env:JTSDK_TOOLS + "\scripts"
$env:JTSDK_SCRIPTS_F = ConvertForward($env:JTSDK_SCRIPTS) 
$env:JTSDK_MSYS2 = $env:JTSDK_TOOLS + "\msys64"
$env:JTSDK_MSYS2_F = ConvertForward($env:JTSDK_MSYS2) 

CreateFolders							# --- Create Folders ------------------

CheckJTSourceSelection					# --- JT Source Selection Check -------

# --- CORE TOOLS --------------------------------------------------------------
#
# Versions of packages set in $env:JTSDK_CONFIG\Versions.ini 

Write-Host -NoNewLine "* Setting Core Tool Variables from "

if ((Test-Path $env:JTSDK_TOOLS)) { $env:CORETOOLS="Installed" } 

# --- Read from Versions.ini -------------------------------------------------
# --> Ref: https://serverfault.com/questions/186030/how-to-use-a-config-file-ini-conf-with-a-powershell-script

$env:JTSDK_VC = "$env:JTSDK_CONFIG\Versions.ini"
Get-Content $env:JTSDK_VC | foreach-object -begin {$configTable=@{}} -process { $k = [regex]::split($_,'='); if(($k[0].CompareTo("") -ne 0) -and ($k[0].StartsWith("[") -ne $True)) { $configTable.Add($k[0], $k[1]) } }
Write-Host "$env:JTSDK_VC"

# Get PowerShell interpreter to use: options be pwsh (latest deploy) and powershell (Core - 5.1)
$PSS = $configTable.Get_Item("pss")

CheckQtDeployment 						# --- Qt ------------------------------

$QTBASE_ff = " "						# --- Set Qt Environment variables ----
$QTD_ff = " "							
$GCCD_ff = " "
$QTP_ff = " "

SetQtEnvVariables -QTBASE_ff ([ref]$QTBASE_ff) -QTD_ff ([ref]$QTD_ff) -GCCD_ff ([ref]$GCCD_ff) -QTP_ff ([ref]$QTP_ff)

SetSQLiteEnviron ($configTable)			# --- SQlite --------------------------

$fftw3f_dir_ff = " "					# --- FFTW ----------------------------
SetFFTWEnviron -configTable $configTable -fftw3f_dir_ff ([ref]$fftw3f_dir_ff)	

$lusb_dir_ff = " "                      # --- LibUSB -------------------------
#SetLibUSBEnviron ($configTable)		
SetLibUSBEnviron -configTable $configTable -lusb_dir_ff ([ref]$lusb_dir_ff)	

SetNSISEnviron ($configTable)			# --- Nullsoft Installer System - NSIS 

SetPkgConfigEnviron ($configTable)		# --- Package Config ------------------

$ruby_dir_ff = " "						# --- Ruby ----------------------------
SetRubyEnviron -configTable $configTable -ruby_dir_ff ([ref]$ruby_dir_ff)		

$svn_dir_ff = " "						# --- Subversion ----------------------
SetSubversionEnviron -configTable $configTable -svn_dir_ff ([ref]$svn_dir_ff)	

SetCMakeEnviron ($configTable)			# --- CMake ---------------------------

SetScriptDir							# --- Scripts Directory ---------------


SetCheckBoost							# --- Boost ---------------------------

SetUnixTools							# --- UNIX TOOLS ----------------------

SetHamlibRepo							# --- SET HAMLIB REPO SOURCE ----------

$pa_dir_ff = " "                        # --- PortAudio -----------------------
SetPortAudioDirs -pa_dir_ff ([ref]$pa_dir_ff)						

# --- SET FINAL ENVIRONMENT PATHS and CONSOLE TITLE ---------------------------

$env:PATH += $env:JTSDK_PATH
$env:PATH += ";"+$pwd.drive.name+":\JTSDK64-Tools\tools\hamlib\qt\"+$env:QTV+"\bin"	# -- Always Find HAMLIB in search path
$env:PATH += ";"+$pwd.drive.name+":\JTSDK64-Tools\tools\hamlib\qt\"+$env:QTV+"\lib"	# -- Always Find HAMLIB Library Dir in search path

# The next line is a FUDGE for an issue with JTDX packaging. Not Happy with this - but is necessary !
#$env:PATH += ";C:\Windows\SysWOW64\downlevel;C:\Windows\System32\downlevel"
$env:PATH += ";"+$env:windir+"\SysWOW64\downlevel;"+$env:windir+"\System32\downlevel"

$hamlib_base_ff = SetHamlibDirs		     # --- Hamlib Dirs --------------------

# --- Generate the Tool Chain -------------------------------------------------

GenerateToolChain -qtbaseff $QTBASE_ff -qtdff $QTD_ff -gccdff $GCCD_ff -rubyff $ruby_dir_ff -fftw3fff $fftw3f_dir_ff -palibff $pa_dir_ff -lusbff $lusb_dir_ff -hamlibff  $hamlib_base_ff -svnff $svn_dir_ff

# -----------------------------------------------------------------------------
#  FINAL MESSAGE
# -----------------------------------------------------------------------------

Write-Host ""
Write-Host "* Environment configured for `'jtbuild`' JT-software and `'msys2`' Hamlib development"
Write-Host ""

Read-Host -Prompt "*** Press [ENTER] to Launch JTSDK-Tools Environment *** "

InvokeInteractiveEnvironment			# --- Invoke the Interactive Environment

exit(0)