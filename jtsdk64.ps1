#-----------------------------------------------------------------------------::
# Name .........: jtsdk64.ps1
# Project ......: Part of the JTSDK64 Tools Project
# Version ......: 3.2.1 u1
# Description ..: Main Development Environment Script
#                 Sets environment variables for development and MSYS2
# Project URL ..: https://github.com/KI7MT/jtsdk64-tools.git
# Usage ........: Call this file directly from the command line
# 
# Author .......: Hamlib SDK Contributors <hamlibdk@outlook.com>
#
# Concept ......: Greg, Beam, KI7MT, <ki7mt@yahoo.com>
#
# Copyright ....: (C) 2013-2021 Greg Beam, KI7MT
#                 (C) 2020-2021 subsequent JTSDK Contributors
# License ......: GPL-3
#
# Adjustments...: Steve VK3VM 8-12-2020 to 5-06-2021
#				: Need for qt-gen-tc.cmd and some markers eliminated
#               : Refactoring and modularisation 26-02-2021
#               : Support for Tools Package supplied PortAudio 5-06-2021
#               : Support for DLL Builds 2/3-01-2022
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
# --> Review necessity of this considering JTSDK-APPS package ***

function CreateFolders {

	Write-Host "* Creating essential directories if they do not exist"
	if (!(Test-Path $env:JTSDK_CONFIG)) { 
		New-Item -Path $env:JTSDK_HOME -Name  "config" -ItemType "directory" | Out-Null
		Write-Host "  --> Created $env:JTSDK_CONFIG"	
	}
	# Deprecated
	#if (!(Test-Path $env:JTSDK_DATA)) { 
	#	New-Item -Path $env:JTSDK_HOME -Name "data" -ItemType "directory"  | Out-Null  
	#		Write-Host "  --> Created $env:JTSDK_DATA"
	#}
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

# --- SQlite ------------------------------------------------------------------

function SetSQLiteEnviron ($configTable) {
	$env:sqlitev = $configTable.Get_Item("sqlitev")
	$env:sqlite_dir = $env:JTSDK_TOOLS + "\sqlite\" + $env:sqlitev
	$env:sqlite_dir_f = ConvertForward($env:sqlite_dir)
	$env:JTSDK_PATH = $env:sqlite_dir   # Nothing to accumulate yet so start the ball rolling !
}

# --- FFTW --------------------------------------------------------------------

function SetFFTWEnviron($configTable, [ref]$fftw3f_dir_ff) {
	$env:fftwv = $configTable.Get_Item("fftwv")
	$env:fftw3f_dir = $env:JTSDK_TOOLS + "\fftw\" + $env:fftwv
	$fftw3f_dir_ff.Value = ($env:fftw3f_dir).replace("\","/")
	$env:fftw3f_dir_f = ConvertForward($env:fftw3f_dir)
	$env:JTSDK_PATH=$env:JTSDK_PATH+";"+$env:fftw3f_dir
}

# --- LibUSB ------------------------------------------------------------------

function SetLibUSBEnviron ($configTable) {
	$env:libusbv = $configTable.Get_Item("libusbv")	
	$env:libusb_dir = $env:JTSDK_TOOLS + "\libusb\" + $env:libusbv
	$env:libusb_dir_f = ConvertForward($env:libusb_dir)
	$env:JTSDK_PATH=$env:JTSDK_PATH+";"+$env:libusb_dir
}

# --- Nullsoft Installer System - NSIS ----------------------------------------

function SetNSISEnviron ($configTable) {
	$env:nsisv = $configTable.Get_Item("nsisv")	
	$env:nsis_dir = $env:JTSDK_TOOLS + "\nsis\" + $env:nsisv
	$env:nsis_dir_f = ConvertForward($env:nsis_dir)
	$env:JTSDK_PATH=$env:JTSDK_PATH + ";" + $env:nsis_dir
}

# --- Package Config ----------------------------------------------------------

function SetPkgConfigEnviron ($configTable) {
	$env:pkgconfigv = $configTable.Get_Item("pkgconfigv")
	$env:pkgconfig_dir = $env:JTSDK_TOOLS + "\pkgconfig\" + $env:pkgconfigv
	$env:pkgconfig_dir_f = ConvertForward($env:pkgconfig_dir)
	$env:JTSDK_PATH=$env:JTSDK_PATH + ";" + $env:pkgconfig_dir
}

# --- Ruby --------------------------------------------------------------------

function SetRubyEnviron($configTable, [ref]$ruby_dir_ff) {
	$env:rubyv = $configTable.Get_Item("rubyv")	
	$env:ruby_dir = $env:JTSDK_TOOLS + "\ruby\" + $env:rubyv
	$ruby_dir_ff.Value = ($env:ruby_dir).replace("\","/")
	$env:ruby_dir_f = ConvertForward($env:ruby_dir)
	$env:JTSDK_PATH=$env:JTSDK_PATH + ";" + $env:ruby_dir
}

# --- Subversion --------------------------------------------------------------

function SetSubversionEnviron ($configTable, [ref]$svn_dir_ff) {

	$env:svnv = $configTable.Get_Item("svnv")
	$env:svn_dir = $env:JTSDK_TOOLS + "\subversion\" + $env:svnv
	$svn_dir_ff.Value = ($env:svn_dir).replace("\","/")
	$env:svn_dir_f = ConvertForward($env:svn_dir)
	$env:JTSDK_PATH=$env:JTSDK_PATH + ";" + $env:svn_dir
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
	$env:JTSDK_PATH=$env:JTSDK_PATH + ";" + $env:cmake_dir
}

# --- Scripts Directory ------------------------------------------------------

function SetScriptDir {
	$env:scripts_dir = $env:JTSDK_TOOLS + "\scripts\"
	$env:scripts_dir_f = ConvertForward($env:scripts_dir)
	$env:JTSDK_PATH=$env:JTSDK_PATH + ";" + $env:scripts_dir
}

# --- Qt ----------------------------------------------------------------------

function CheckQtDeployment {

	Write-Host "* Checking QT Deployment"

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

	# Defaults to and sets for Qt 5.12.11 (base Qt version) if no default file found
	if ($subPathQtStore -eq "NULL") {
		Write-Host "  --> No Qt configuration marker: Setting default `[Qt 5.12.11`]"
		$tmpOut = $env:JTSDK_CONFIG + "\qt5.12.11"
		Out-File -FilePath $tmpOut
		$env:QTV = "5.12.11"    
	}

	# Thanks to Mile Black W9MDB for the concept
	# Code here could be cleaner - with better variable nomenclature !

	$listQtDeploy = Get-ChildItem -Path $env:JTSDK_TOOLS\qt -EA SilentlyContinue                 

	$env:VER_MINGW=" " 				# Remember: $env:QTV contains the QT Version!	
	$countMinGW = 0					#           $subPathQt contains name of Qt version from marker

	ForEach ($subPathQt in $listQtDeploy)
	{
		$listSubUnderQtDir = Get-ChildItem -Path $env:JTSDK_TOOLS\qt\$subPathQt -EA SilentlyContinue
		if ($subPathQt -Match "[1-9]") {
			ForEach ($itemListSubUnderQtDir in $listSubUnderQtDir) {
				if ($subPathQt.Name -eq $env:QTV) {
					if (($itemListSubUnderQtDir -like '*64')) {
						$env:VER_MINGW = $itemListSubUnderQtDir
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
		Write-Host "  --> Qt Version Deployed: `[$env:QTV`] MinGW Version: `[$env:VER_MINGW`]" # - contains MinGW Release
	} else {
		GenerateError("NO Qt DEPLOYMENT or MULTIPLE Qt MARKERS SET IN $env:JTSDK_CONFIG. PLEASE CORRECT")
	}
}

# --- Set Qt Environment variables --------------------------------------------
# --> MinGW environs need be set for detected version in $env:VER_MINGW

function SetQtEnvVariables ([ref]$QTD_ff, [ref]$GCCD_ff, [ref]$QTP_ff) {

	$env:QTD=$env:JTSDK_TOOLS + "\Qt\"+$env:QTV+"\"+$env:VER_MINGW+"\bin"
	$env:QTD_F = ConvertForward($env:QTD)
	$QTD_ff.Value = ($env:QTD).replace("\","/")

	# Dirty method to add additional 0 required for Tools MinGW
	# May cause issues if the MinGW people change structures or use sub-versions !

	$verMinGWAddZero= $env:VER_MINGW -replace "_", "0_"
	$env:GCCD=$env:JTSDK_TOOLS + "\Qt\Tools\"+$verMinGWAddZero+"\bin"
	$GCCD_ff.Value = ($env:GCCD).replace("\","/")
	$env:GCCD_F = ConvertForward($env:GCCD)

	$env:QTP=$env:JTSDK_TOOLS + "\Qt\"+$env:QTV+"\"+$env:VER_MINGW+"\plugins\platforms"
	$env:QTP_F = ConvertForward($env:QTP)
	$QTP_ff.Value = ($env:QTP).replace("\","/")

	$env:JTSDK_PATH=$env:JTSDK_PATH + ";" + $env:GCCD + ";" + $env:QTD + ";" + $env:QTP

	Write-Host "* Qt Environment Variables"
	Write-Host "  --> QTD ----> $env:QTD"
	Write-Host "  --> QTD_F --> $env:QTD_F"
	Write-Host "  --> QTP ----> $env:QTP"
	Write-Host "  --> QTP_F --> $env:QTP_F"
	Write-Host "  --> GCCD ---> $env:GCCD"
	Write-Host "  --> GCCD_F -> $env:GCCD_F"
}

# --- CHECK BOOST DEPLOY IS FOR CORRECT MINGW VERSION -------------------------
# --> Get from examing nomenclature in C:\JTSDK64-Tools\tools\boost\<ver>\lib
#     i.e. xxxx-mgw8-XXX for MinGW 8.1    xxxx-mgw7-XXX for MinGW 7.3	

function CheckBoostCorrectMinGWVersion($boostDir) {
	$retval = "Not Found"
		
	$listBoostDeploy = Get-ChildItem -Path "$boostDir\lib" -EA SilentlyContinue

	ForEach ($subPathBoost in $listBoostDeploy)
	{    
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

	if ((Test-Path "$env:JTSDK_TOOLS\boost\$env:boostv")) { 
		$env:boost_dir = $env:JTSDK_TOOLS + "\boost\" + $env:boostv
		$env:boost_dir_f = ConvertForward($env:boost_dir)
		$env:JTSDK_PATH=$env:JTSDK_PATH + ";" + $env:boost_dir + "\lib"
		Write-Host -NoNewLine "* Boost version $env:boostv is deployed under "
		$env:BOOST_V_MINGW = CheckBoostCorrectMinGWVersion($env:boost_dir)
		Write-Host $env:BOOST_V_MINGW
		Write-Host -NoNewLine "  --> Current Qt Support: `[$env:VER_MINGW`] Status: "
		if ($env:BOOST_V_MINGW -like $env:VER_MINGW) {
			$env:BOOST_STATUS="Functional"
			Write-Host "Functional"
		} else {
			Write-Host "*** NON FUNCTIONAL FOR JTSDK USE ***"
		}
	} else {
		Write-Host "*** BOOST NOT DEPLOYED: Provide library for $env:VER_MINGW to $env:JTSDK_TOOLS\boost\$env:boostv ***"
	}
}

# --- UNIX TOOLS --------------------------------------------------------------
# --> Unix marker files deprecated where practical to settings in Versions.ini
# --> Unix Tools be enabled otherwise JTBUILD may not work

function SetUnixTools {
	Write-Host -NoNewLine "* Unix Tools configuration in `'Versions.ini`': " 
	$tmpUnixToolsValue = $configTable.Get_Item("unixtools")
	if (($tmpUnixToolsValue -eq "enabled") -or ($tmpUnixToolsValue -eq "yes")) {	
		$unixDir1 = $env:JTSDK_TOOLS + "\msys64"
		$unixDir2 = $env:JTSDK_TOOLS + "\msys64\usr\bin"
		$env:JTSDK_PATH = $unixDir1 + ";" + $unixDir2 + ";" + $env:JTSDK_PATH 
		$env:UNIXTOOLS = "Enabled"
		Write-Host "enabled"
	} else {
		Write-Host "not set."
		Write-Host "  --> *** Kit operation may be impacted: Set a marker in `'Versions.ini`' ***"
	}
}

# --- Hamlib3 Dirs ------------------------------------------------------------

function SetHamlib3Dirs {
	$env:hamlib_base = $env:JTSDK_TOOLS + "\hamlib"
	$env:hamlib_base_f = ConvertForward($env:hamlib_base)
	return ($env:hamlib_base).replace("\","/")
}

# --- SET HAMLIB REPO SOURCE --------------------------------------------------

function SetHamlibRepo {
	Write-Host -NoNewLine "* Hamlib Repository Source: "

	# This logic works - assuming only one marker...
	$env:HLREPO = "NONE"
	if (Test-Path "$env:JTSDK_CONFIG\hlmaster") { $env:HLREPO = "MASTER" }
	if (Test-Path "$env:JTSDK_CONFIG\hlw9mdb") { $env:HLREPO = "W9MDB" }
	if (Test-Path "$env:JTSDK_CONFIG\hlg4wjs") { $env:HLREPO = "G4WJS" }
	Write-Host "$env:HLREPO"
	if ($env:HLREPO -eq "NONE") {
		Write-Host "  --> Please set a repository source marker in $env:JTSDK_CONFIG"
	}
}

# --- Generate Qt Tool Chain Files --------------------------------------------

function GenerateToolChain ($qtdff, $gccdff, $rubyff, $fftw3fff, $hamlibff, $svnff) {

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
	Add-Content $of "# Hamlib"
	Add-Content $of "SET (HLIB $hamlibff/qt/$env:QTV)"
	Add-Content $of " "
	Add-Content $of "# Subversion"
	Add-Content $of "SET (SVND $svnff)"
	Add-Content $of " "
	Add-Content $of "# PortAudio"
	Add-Content $of "SET (PALIB C:/JTSDK64-Tools/tools/portaudio)"
	Add-Content $of "SET (PALIB_LIBRARY C:/JTSDK64-Tools/tools/portaudio/lib/libportaudio.dll)"
	Add-Content $of " "
	Add-Content $of "# Cmake Consolidated Variables"
	Add-Content $of "SET (CMAKE_PREFIX_PATH `$`{GCCD} `$`{QTDIR} `$`{HLIB} `$`{HLIB}/bin `$`{HLIB}/lib/gcc `$`{ADOCD} `$`{FFTWD} `$`{FFTW3_LIBRARY} `$`{FFTW3F_LIBRARY} `$`{SVND} `$`{PALIB} `$`{PALIB_LIBRARY})"
	Add-Content $of "SET (CMAKE_FIND_ROOT_PATH `$`{JTSDK_TOOLS})"
	Add-Content $of "SET (CMAKE_FIND_ROOT_PATH_PROGRAM NEVER)"
	Add-Content $of "SET (CMAKE_FIND_ROOT_PATH_LIBRARY BOTH)"
	Add-Content $of "SET (CMAKE_FIND_ROOT_PATH_INCLUDE BOTH)"
	Add-Content $of " "
	Add-Content $of "# END Cmake Tool Chain File"
}

# --- JT Source Selection Check -----------------------------------------------

function CheckJTSourceSelection {
	$env:JT_SRC="None"
	$listSrcDeploy = Get-ChildItem -Path $env:JTSDK_CONFIG -EA SilentlyContinue
	ForEach ($subPathSrc in $listSrcDeploy)
	{    
		if ($subPathSrc.Name -like 'src*') {
			Write-Host "* Found JT- source configuration marker `[$subPathSrc`] in $env:JTSDK_CONFIG"
			$env:JT_SRC = $subPathSrc.Name.substring(4)
			break
		}
	}
	if ( $env:JT_SRC -eq "None") {
		Write-Host " * No JT- source selection marker found in $env:JTSDK_CONFIG"
	}
}

# ##############################################################################
#  PowerShell Interactive Build Environment
# ##############################################################################
# --> Size kept minimal to avoid running out of CMD environment space
# --> Invoking PowerShell through a CMD shell prevents many security warnings !

function InvokeInteractiveEnvironment {
	invoke-expression 'cmd /c start powershell -NoExit -Command {                           `                `
		$host.UI.RawUI.WindowTitle = "JTSDK64 Tools Powershell"
		New-Alias msys2 "$env:JTSDK_TOOLS\msys64\msys2.exe"	
		Write-Host "---------------------------------------------"
		Write-Host "           JTSDK64 Tools $env:JTSDK64_VERSION"
		Write-Host "---------------------------------------------"
		Write-Host ""
		Write-Host "Config: $env:jtsdk64VersionConfig"
		Write-Host ""
		Write-Host "Package       Version/Status"
		Write-Host "---------------------------------------------"
		Write-Host "Unix Tools .: $env:UNIXTOOLS"
		Write-Host "Source .....: $env:JT_SRC" 
		if ((Test-Path "$env:JTSDK_MSYS2\usr\bin")) { 
			Write-Host "MSYS2 ......: Deployed"
		} else {
			Write-Host "MSYS2 ......: Missing"
		}
		if ((Test-Path "$env:JTSDK_TOOLS\qt\$env:qtv")) { 
			Write-Host "Qt .........: $env:QTV `[$env:VER_MINGW`]"
		} else {
			Write-Host "Qt .........: $env:QTV Missing"
		}
		Write-Host -NoNewLine "Hamlib .....: "
		if ((Test-Path "$env:JTSDK_TOOLS\hamlib\qt\$env:QTV")) { 
			if ((Test-Path "$env:JTSDK_TOOLS\hamlib\qt\$env:QTV\lib\gcc\libhamlib.dll.a")) {
				Write-Host "Dynamic"
			} else {
				Write-Host "Static"
			}
		} else {
			Write-Host "Missing"
		}
		if ((Test-Path "$env:JTSDK_TOOLS\fftw\$env:fftwv")) { 
			Write-Host "FFTW .......: $env:fftwv"
		} else {
			Write-Host "FFTW .......: $env:fftwv Missing"
		}
		if ((Test-Path "$env:JTSDK_TOOLS\libusb\$env:libusbv")) { 
			Write-Host "LibUSB .....: $env:libusbv"
		} else {
			Write-Host "LibUSB .....: $env:libusbv Missing"
		}
		if ((Test-Path "$env:JTSDK_TOOLS\nsis\$env:nsisv")) { 
			Write-Host "NSIS .......: $env:nsisv"
		} else {
			Write-Host "NSIS .......: $env:nsisv Missing"
		}
		if ((Test-Path "$env:JTSDK_TOOLS\pkgconfig\$env:pkgconfigv")) { 
			Write-Host "PkgConfig ..: $env:pkgconfigv"
		} else {
			Write-Host "PkgConfig ..: $env:pkgconfigv Missing"
		}
		if ((Test-Path "$env:JTSDK_TOOLS\ruby\$env:rubyv")) { 
			Write-Host "Ruby .......: $env:rubyv"
		} else {
			Write-Host "Ruby .......: $env:rubyv Missing"
		}
		if ((Test-Path "$env:JTSDK_TOOLS\subversion\$env:svnv")) { 
			Write-Host "Subversion .: $env:svnv"
		} else {
			Write-Host "Subversion .: $env:svnv Missing"
		}
		Write-Host -NoNewLine "CMake ......: $env:cmakev "
		if ($env:cmakev -eq "qtcmake") {
			Write-Host ""
		} else {
			if ((Test-Path "$env:JTSDK_TOOLS\cmake\$env:cmakev")) { 
				Write-Host ""
			} else {
				Write-Host "Missing"
			}
		}
		if ((Test-Path "$env:JTSDK_TOOLS\boost\$env:boostv")) { 
			Write-Host "Boost ......: $env:boostv $env:BOOST_STATUS `[$env:BOOST_V_MINGW`]"
		} else {
			Write-Host "Boost ......: $env:boostv Missing"
		}

		Write-Host "---------------------------------------------"
		Write-Host ""
		Write-Host "Commands:"
		Write-Host ""
		Write-Host "  Deploy Boost .. Deploy-Boost"
		Write-Host "  MSYS2 ......... msys2"
		Write-Host "  Build JT-ware . jtbuild `[option`]"
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
#$env:JTSDK_DATA= $env:JTSDK_HOME + "\data"
#$env:JTSDK_DATA_F = ConvertForward($env:JTSDK_DATA)
$env:JTSDK_SRC = $env:JTSDK_HOME + "\src"
$env:JTSDK_SRC_F = ConvertForward($env:JTSDK_SRC) 
$env:JTSDK_TMP = $env:JTSDK_HOME + "\tmp"
$env:JTSDK_TMP_F = ConvertForward($env:JTSDK_TMP)
$env:JTSDK_TOOLS = $env:JTSDK_HOME + "\tools"
$env:JTSDK_TOOLS_F = ConvertForward($env:JTSDK_TOOLS)
$env:JTSDK_SCRIPTS = $env:JTSDK_TOOLS + "\scripts"
$env:JTSDK_SCRIPTS_F = ConvertForward($env:JTSDK_SCRIPTS) 
$env:JTSDK_MSYS2 = $env:JTSDK_TOOLS + "\msys64"
$env:JTSDK_MSYS2_F = ConvertForward($env:JTSDK_SCRIPTS) 

CreateFolders							# --- Create Folders ------------------

# --- CORE TOOLS --------------------------------------------------------------
#
# Versions of packages now set in $env:JTSDK_CONFIG\Versions.ini 

Write-Host -NoNewLine "* Setting Core Tool Variables from "

if ((Test-Path $env:JTSDK_TOOLS)) { $env:CORETOOLS="Installed" } 

# --- Read from Versions.ini -------------------------------------------------
# --> Ref: https://serverfault.com/questions/186030/how-to-use-a-config-file-ini-conf-with-a-powershell-script

$env:jtsdk64VersionConfig = "$env:JTSDK_CONFIG\Versions.ini"
Get-Content $env:jtsdk64VersionConfig | foreach-object -begin {$configTable=@{}} -process { $k = [regex]::split($_,'='); if(($k[0].CompareTo("") -ne 0) -and ($k[0].StartsWith("[") -ne $True)) { $configTable.Add($k[0], $k[1]) } }
Write-Host "$env:jtsdk64VersionConfig"

SetSQLiteEnviron ($configTable)			# --- SQlite --------------------------

$fftw3f_dir_ff = " "					# --- FFTW ----------------------------
SetFFTWEnviron -configTable $configTable -fftw3f_dir_ff ([ref]$fftw3f_dir_ff)	

SetLibUSBEnviron ($configTable)			# --- LibUSB --------------------------

SetNSISEnviron ($configTable)			# --- Nullsoft Installer System - NSIS 

SetPkgConfigEnviron ($configTable)		# --- Package Config ------------------

$ruby_dir_ff = " "						# --- Ruby ----------------------------
SetRubyEnviron -configTable $configTable -ruby_dir_ff ([ref]$ruby_dir_ff)		

$svn_dir_ff = " "						# --- Subversion ----------------------
SetSubversionEnviron -configTable $configTable -svn_dir_ff ([ref]$svn_dir_ff)	

SetCMakeEnviron ($configTable)			# --- CMake ---------------------------

SetScriptDir							# --- Scripts Directory ---------------

CheckQtDeployment 						# --- Qt ------------------------------

SetCheckBoost							# --- Boost ---------------------------

$QTD_ff = " "							# --- Set Qt Environment variables ----
$GCCD_ff = " "
$QTP_ff = " "
SetQtEnvVariables -QTD_ff ([ref]$QTD_ff) -GCCD_ff ([ref]$GCCD_ff) -QTP_ff ([ref]$QTP_ff)

SetUnixTools							# --- UNIX TOOLS ----------------------

SetHamlibRepo							# --- SET HAMLIB REPO SOURCE ----------

# --- SET FINAL ENVIRONMENT PATHS and CONSOLE TITLE ---------------------------

$env:PATH=$env:PATH + ";" + $env:JTSDK_PATH

$hamlib_base_ff = SetHamlib3Dirs		# --- Hamlib3 Dirs --------------------

# --- Generate the Tool Chain -------------------------------------------------

GenerateToolChain -qtdff $QTD_ff -gccdff $GCCD_ff -rubyff $ruby_dir_ff -fftw3fff $fftw3f_dir_ff -hamlibff $hamlib_base_ff -svnff $svn_dir_ff

CheckJTSourceSelection					# --- JT Source Selection Check -------

# -----------------------------------------------------------------------------
#  FINAL MESSAGE
# -----------------------------------------------------------------------------

Write-Host ""
Write-Host "* Environment configured for `'jtbuild`' JT-software and `'msys2`' Hamlib development"
Write-Host ""
pause

InvokeInteractiveEnvironment			# --- Invoke the Interactive Environment

exit(0)