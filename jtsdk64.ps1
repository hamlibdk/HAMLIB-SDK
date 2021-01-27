#-----------------------------------------------------------------------------::
# Name .........: jtsdk64.ps1
# Project ......: Part of the JTSDK64 Tools Project
# Version ......: 3.2.0 beta
# Description ..: Main Environment Script
# Project URL ..: https://github.com/KI7MT/jtsdk64-tools.git
# Usage ........: Call this file directly from the command line
# 
# Author .......: Hamlib SDK Contributors <hamlibdk@hotmail.com>
#
# Concept ......: Greg, Beam, KI7MT, <ki7mt@yahoo.com>
#
# Copyright ....: (C) 2013-2021 Greg Beam, KI7MT
#                 (C) 2020-2021 subsequent JTSDK Contributors
# License ......: GPL-3
#
# Adjustments...: Steve VK3VM 8-Dec-2020 to 2-Jan-2021
#				: Need for qt-gen-tc.cmd and some markers eliminated
#-----------------------------------------------------------------------------::

# Set PowerShell Prompt (Possibly redundant).
# Ref: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/get-location?view=powershell-7.1

function SetPrompt { 
	'(Qt ' + $env:QTV + ') ' + (Get-Location) + '> '
}

#  Basic ENV variabled primed

$env:UNIXTOOLS = "Disabled"
$env:HLREPO = "NONE"

# ------------------------------------------------------------------------------
# Application Information
# ------------------------------------------------------------------------------

$jtsdk64Version = [IO.File]::ReadAllText($PSScriptRoot+"\ver.jtsdk")
$env:JTSDK64_VERSION = $jtsdk64Version

# Current directory is home dir of script 
$currentDir = $MyInvocation.MyCommand.Path | Split-Path -Parent # Alternate: $env:JTSDK_HOME = $PSScriptRoot

# Set Initial Header informaiton
$winname = "JTSDK64 Tools " + $jtsdk64Version
$host.ui.RawUI.WindowTitle = $winname

Clear-Host
Write-Host "---------------------------------"
Write-Host "  JTSDK64 Core Tools $jtsdk64Version"
Write-Host "---------------------------------"
Write-Host ""
Write-Host "*  Starting jtsdk64.ps1 in $currentDir"
Write-Host ""
Set-Location -Path $currentDir

# ------------------------------------------------------------------------------
# GLOBAL ENVIRONMENT VARIABLES and PATHS
# ------------------------------------------------------------------------------

Write-Host "* Setting Environment Variables"
$env:JTSDK_HOME = $currentDir 
$env:JTSDK_CONFIG = $env:JTSDK_HOME + "\config"
$env:JTSDK_DATA= $env:JTSDK_HOME + "\data"
$env:JTSDK_SRC = $env:JTSDK_HOME + "\src"
$env:JTSDK_TMP = $env:JTSDK_HOME + "\tmp"
$env:JTSDK_TOOLS = $env:JTSDK_HOME + "\tools"
$env:JTSDK_SCRIPTS = $env:JTSDK_TOOLS + "\scripts" 

# Create Folders
# *** Review necessity of this considering JTSDK-APPS package ***

Write-Host "* Creating Directories (If Required)"
if (!(Test-Path $env:JTSDK_CONFIG)) { New-Item -Path $env:JTSDK_HOME -Name  "config" -ItemType "directory" | Out-Null }
if (!(Test-Path $env:JTSDK_DATA)) { New-Item -Path $env:JTSDK_HOME -Name "data" -ItemType "directory"  | Out-Null  }
if (!(Test-Path $env:JTSDK_SRC)) { New-Item -Path $env:JTSDK_HOME -Name "src" -ItemType "directory"  | Out-Null }
if (!(Test-Path $env:JTSDK_TMP)) { New-Item -Path $env:JTSDK_HOME -Name "tmp" -ItemType "directory"  | Out-Null }
if (!(Test-Path $env:JTSDK_SCRIPTS)) { New-Item -Path $env:JTSDK_TOOLS -Name "\scripts" -ItemType "directory"  | Out-Null }

# ------------------------------------------------------------------------------
# CORE TOOLS
# ------------------------------------------------------------------------------
#
# Versions of packages now set in $env:JTSDK_CONFIG\Versions.ini 

Write-Host "* Setting Core Tool Variables"

$pathTest = $env:JTSDK_HOME + "\tools"
if ((Test-Path $pathTest)) { $env:CORETOOLS="Installed" } 

# Ref: https://serverfault.com/questions/186030/how-to-use-a-config-file-ini-conf-with-a-powershell-script

$env:jtsdk64VersionConfig = "$env:JTSDK_CONFIG\Versions.ini"
Get-Content $env:jtsdk64VersionConfig | foreach-object -begin {$configTable=@{}} -process { $k = [regex]::split($_,'='); if(($k[0].CompareTo("") -ne 0) -and ($k[0].StartsWith("[") -ne $True)) { $configTable.Add($k[0], $k[1]) } }
Write-Host "  --> Package Versions: $env:jtsdk64VersionConfig"

# SQlite
$env:sqlitev = $configTable.Get_Item("sqlitev")
$env:sqlite_dir = $env:JTSDK_HOME + "\tools\sqlite\" + $env:sqlitev
$env:sqlite_dir_f = $env:sqlite_dir.replace("\","/")
$env:JTSDK_PATH = $env:sqlite_dir   # Nothing to accumulate yet so start the ball rolling !

# FFTW
$env:fftwv = $configTable.Get_Item("fftwv")
$env:fftw3f_dir = $env:JTSDK_HOME + "\tools\fftw\" + $env:fftwv
$env:fftw3f_dir_f = $env:fftw3f_dir.replace("\","/")
$env:JTSDK_PATH=$env:JTSDK_PATH+";"+$env:fftw3f_dir

# LibUSB
$env:libusbv = $configTable.Get_Item("libusbv")	
$env:libusb_dir = $env:JTSDK_HOME + "\tools\libusb\" + $env:libusbv
$env:libusb_dir_f = $env:libusb_dir.replace("\","/")
$env:JTSDK_PATH=$env:JTSDK_PATH+";"+$env:libusb_dir

# NSIS
$env:nsisv = $configTable.Get_Item("nsisv")	
$env:nsis_dir = $env:JTSDK_HOME + "\tools\nsis\" + $env:nsisv
$env:nsis_dir_f = $env:nsis_dir.replace("\","/")
$env:JTSDK_PATH=$env:JTSDK_PATH + ";" + $env:nsis_dir

# packageConfig
$env:pkgconfigv = $configTable.Get_Item("pkgconfigv")
$env:pkgconfig_dir = $env:JTSDK_HOME + "\tools\pkgconfig\" + $env:pkgconfigv
$env:pkgconfig_dir_f = $env:pkgconfig_dir.replace("\","/")
$env:JTSDK_PATH=$env:JTSDK_PATH + ";" + $env:pkgconfig_dir

# Ruby
$env:rubyv = $configTable.Get_Item("rubyv")	
$env:ruby_dir = $env:JTSDK_HOME + "\tools\ruby\" + $env:rubyv
$env:ruby_dir_f = $env:ruby_dir.replace("\","/")
$env:JTSDK_PATH=$env:JTSDK_PATH + ";" + $env:ruby_dir

# Subversion
$env:svnv = $configTable.Get_Item("svnv")
$env:svn_dir = $env:JTSDK_HOME + "\tools\subversion\" + $env:svnv
$env:svn_dir_f = $env:svn_dir.replace("\","/")
$env:JTSDK_PATH=$env:JTSDK_PATH + ";" + $env:svn_dir

#CMake
$env:cmakev = $configTable.Get_Item("cmakev")	
if ($env:cmakev -eq "qtcmake") {
	# Use the CMAKE Supplied with Qt
	$env:cmake_dir = $env:JTSDK_HOME + "\tools\Qt\Tools\CMake_64\bin"
	Write-Host "  --> CMake sourced from Qt deployment"
} else {
	# CMAKE-PACKAGED: Found in C:\JTSDK64-Tools\tools\cmake\x.xx.x
	# Use the CMAKE from https://cmake.org/download/ 
	$env:cmake_dir = $env:JTSDK_HOME + "\tools\cmake\" + $env:cmakev + "\bin"
	Write-Host "  --> CMake sourced from $cmake_Dir"
}
$env:cmake_dir_f = $env:cmake_dir.replace("\","/")
$env:JTSDK_PATH=$env:JTSDK_PATH + ";" + $env:cmake_dir

# Boost
$env:boostv = $configTable.Get_Item("boostv")
$pathTest = $env:JTSDK_HOME + "\tools\boost\" + $env:boostv
if ((Test-Path $pathTest)) { 
	$env:boost_dir = $env:JTSDK_HOME + "\tools\boost\" + $env:boostv
	$env:boost_dir_f = $env:boost_dir.replace("\","/")
	$env:JTSDK_PATH=$env:JTSDK_PATH + ";" + $env:boost_dir + "\lib"
	Write-Host "  --> Boost library $boostv present"
} else {
	Write-Host "  --> Boost library NOT DEPLOYED"
}

# Scripts Directory
$env:scripts_dir = $env:JTSDK_HOME + "\tools\scripts\"
$env:scripts_dir_f = $env:scripts_dir.replace("\","/")
$env:JTSDK_PATH=$env:JTSDK_PATH + ";" + $env:scripts_dir

# Qt
Write-Host "* Checking QT Version"

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

# Defaults to and sets for Qt 5.12.10 (base Qt version) if no default file found
if ($subPathQtStore -eq "NULL") {
    Write-Host "  --> No Qt configuration marker: Setting default `[Qt 5.12.10`]"
    $tmpOut = $env:JTSDK_CONFIG + "\qt5.12.10"
    Out-File -FilePath $tmpOut
    $env:QTV = "5.12.10"    
}

# Thanks to Mile Black W9MDB for the concept
# Code here could be cleaner - with better variable nomenclature !

$listQtDeploy = Get-ChildItem -Path $env:JTSDK_TOOLS\qt -EA SilentlyContinue                 

$tempMinGWVersion=" " 				# Remember: $env:QTV contains the QT Version!	
$countMinGW = 0						#           $subPathQt contains name of Qt version from marker

ForEach ($subPathQt in $listQtDeploy)
{
	$listSubUnderQtDir = Get-ChildItem -Path $env:JTSDK_TOOLS\qt\$subPathQt -EA SilentlyContinue
	if ($subPathQt -Match "[1-9]") {
		ForEach ($itemListSubUnderQtDir in $listSubUnderQtDir) {
            if ($subPathQt.Name -eq $env:QTV) {
                if (($itemListSubUnderQtDir -like '*64')) {
                    $tempMinGWVersion = $itemListSubUnderQtDir
                    if ($itemListSubUnderQtDir -like 'mingw*') {
                        $countMinGW = $countMinGW + 1
                        break
                    }
			    }   
            }
		}
	}
}

# Write-Host "  --> Qt version marker requested version deployed" # Count: $countMinGW"  1 If Qt has been found

if ($countMinGW -eq 1) 
{
	Write-Host "  --> MinGW Version: $tempMinGWVersion" # - contains MinGW Release
} else {
    Write-Host "  --> Qt Version Marker NOT SET in $env:JTSDK_CONFIG"
    Write-Host ""
    Write-Host "**** **** **** QT DEPLOYED INCORRECTLY **** **** ****"
	Write-Host ""
	pause
    exit(-1)
}

# Set Qt Environment variables
# Note the MinGW environs need be set for detected version in $tempMinGWVersion

$env:QTD=$env:JTSDK_HOME + "\tools\Qt\"+$env:QTV+"\"+$tempMinGWVersion+"\bin"
$env:QTP=$env:JTSDK_HOME + "\tools\Qt\"+$env:QTV+"\"+$tempMinGWVersion+"\plugins\platforms"

# Dirty method to add additional 0 required for Tools MinGW
# May cause issues if the MinGW people change structures or use sub-versions !

$tempMinGWVersionAddZero = $tempMinGWVersion -replace "_", "0_"

$env:GCCD=$env:JTSDK_HOME + "\tools\Qt\Tools\"+$tempMinGWVersionAddZero+"\bin"

Write-Host "* Setting Qt Environment Variables"
Write-Host "  --> QTD $env:QTD"
Write-Host "  --> QTP $env:QTP"
Write-Host "  --> GCCD $env:GCCD"

$env:QTD_F = $env:QTD.replace("\","/")
$env:GCCD_F = $env:GCCD.replace("\","/")
$env:JTSDK_PATH=$env:JTSDK_PATH + ";" + $env:GCCD + ";" + $env:QTD + ";" + $env:QTP

Write-Host "  --> QTD_F $env:QTD_F"
Write-Host "  --> GCCD_F $env:GCCD_F"

# END CORE TOOLS -------------------------------------------------------------

# ------------------------------------------------------------------------------
# SET HAMLIB REPO SOURCE - Steve VK3VM 11/5/2020 - 2/1/2021
# ------------------------------------------------------------------------------

Write-Host "* Checking Hamlib Repository Source"

$exe = $env:JTSDK_CONFIG+"\hlmaster"
if (Test-Path $exe) { 
	$env:HLREPO = "MASTER"
} else {
    $exe = $env:JTSDK_CONFIG+"\hlw9mdb"
    if (Test-Path $exe) { 
	    $env:HLREPO = "W9MDB"
    } else {
        $exe = $env:JTSDK_CONFIG+"\hlg4wjs"
        if (Test-Path $exe) { 
	        $env:HLREPO = "G4WJS"
        } else {
            $env:HLREPO = "NONE"
        }
    }
}

Write-Host "  --> Repository: $env:HLREPO"

# UNIX TOOLS
# Unix marker files deprecated where practical to settings in Versions.ini
# It is CRITICAL that Unix Tools be enabled otherwise JTBUILD.CMD will not work
# JTBUILD uses hybrid MSYS2 Unix commands so this must be in the path !

if ($configTable.Get_Item("unixtools") -eq "enabled") {	
    $unixDir1 = $env:JTSDK_HOME + "\tools\msys64"
    $unixDir2 = $env:JTSDK_HOME + "\tools\msys64\usr\bin"
    $env:JTSDK_PATH = $unixDir1 + ";" + $unixDir2 + ";" + $env:JTSDK_PATH 
    $env:UNIXTOOLS = "Enabled"
	Write-Host "* Unix Tools `(needed for jtbuild`): enabled"
}

# ------------------------------------------------------------------------------
#  SET FINAL ENVIRONMENT PATHS and CONSOLE TITLE
# ------------------------------------------------------------------------------

Write-Host "* Setting Final Paths and headers"

$env:PATH=$env:PATH + ";" + $env:JTSDK_PATH

# ------------------------------------------------------------------------------
#  Generate Qt Tool Chain Files
# ------------------------------------------------------------------------------
Write-Host "* Generating JT-software Qt Tool Chain Files"
Write-Host "  --> Generating Tool Chain for Qt $env:QTV"

$LTOOLS_PATH = $env:JTSDK_TOOLS + "\tc-files"

# Create tc-files if it does not exist
if (-not (Test-Path $LTOOLS_PATH)) { 
    New-Item -Path $env:JTSDK_TOOLS -Name "tc-files" -ItemType "directory" | Out-Null
	Write-Host "  --> `'tc-files`' does not exist. Creating $LTOOLS_PATH"
}

# Hamlib3 Dirs
$env:hamlib_base = $env:JTSDK_HOME + "\tools\hamlib"
$env:hamlib_base_f = $env:hamlib_base.replace("\","/")

$pathDPDel = $env:QTV
$pathDPDelR = $pathDPDel -replace "\.",''

# Generate Tool Chain File for Qt using Supported MinGW GCC version

$of = $env:JTSDK_TOOLS + "\tc-files\QT"+$pathDPDelR+".cmake"

# Question: What should env var TOOLSROOT point to?????

New-Item -Force $of > $null
Add-Content $of "# This file is auto-generated by : $PSCommandPath version $jtsdk64Version" 
Add-Content $of "# Tool Chain File for Qt $pathDPDel"
Add-Content $of " "
Add-Content $of "# System Type and Based Paths"
Add-Content $of "SET (CMAKE_SYSTEM_NAME Windows)"
Add-Content $of "SET (QTDIR $env:QTD_F)"
Add-Content $of "SET (GCCD $env:GCCD_F)"
Add-Content $of " "
Add-Content $of "# AsciiDoctor"
Add-Content $of "SET (ADOCD $env:ruby_dir_f)"
Add-Content $of " "
Add-Content $of "# FFTW"
Add-Content $of "SET (FFTWD $env:fftw3f_dir_f)"
Add-Content $of "SET (FFTW3_LIBRARY $env:fftw3f_dir_f/libfftw3-3.dll)"
Add-Content $of "SET (FFTW3F_LIBRARY $env:fftw3f_dir_f/libfftw3f-3.dll)"
Add-Content $of " "
Add-Content $of "# Hamlib"
Add-Content $of "SET (HLIB $env:hamlib_base_f/qt/$pathDPDel)"
Add-Content $of " "
Add-Content $of "# Subversion"
Add-Content $of "SET (SVND $env:svn_dir_f)"
Add-Content $of " "
Add-Content $of "# Cmake Consolidated Variables"
Add-Content $of "SET (CMAKE_PREFIX_PATH `$`{GCCD} `$`{QTDIR} `$`{HLIB} `$`{HLIB}/bin `$`{ADOCD} `$`{FFTWD} `$`{FFTW3_LIBRARY} `$`{FFTW3F_LIBRARY} `$`{SVND})"
Add-Content $of "SET (CMAKE_FIND_ROOT_PATH `$`{TOOLSROOT})"
Add-Content $of "SET (CMAKE_FIND_ROOT_PATH_PROGRAM NEVER)"
Add-Content $of "SET (CMAKE_FIND_ROOT_PATH_LIBRARY BOTH)"
Add-Content $of "SET (CMAKE_FIND_ROOT_PATH_INCLUDE BOTH)"
Add-Content $of " "
Add-Content $of "# END Cmake Tool Chain File"

#JT Source Selection Check
Write-Host "* Check if source section marker file exists"

$env:JT_SRC="None"
$listSrcDeploy = Get-ChildItem -Path $env:JTSDK_CONFIG -EA SilentlyContinue
$subPathSrcStore = "NULL";
ForEach ($subPathSrc in $listSrcDeploy)
{    
	if ($subPathSrc.Name -like 'src*') {
        Write-Host "  --> Found Source configuration marker `[$subPathSrc`] in $env:JTSDK_CONFIG"
        $subPathSrcStore = $subPathSrc
		$env:JT_SRC = $subPathSrc.Name.substring(4)
        break
    }
}

Write-Host "* Tool Chain generation for `'jtbuild`' complete"

Write-Host ""
pause
# ------------------------------------------------------------------------------
#  Start PowerShell Interactive Build Environment
# ------------------------------------------------------------------------------
invoke-expression 'cmd /c start powershell -NoExit -Command {                           `                `
    $host.UI.RawUI.WindowTitle = "JTSDK64 Tools Powershell Window"
	New-Alias msys2 "$env:JTSDK_TOOLS\msys64\msys2_shell.cmd"	
	Write-Host "---------------------------------------------"
	Write-Host "          JTSDK64 Tools $env:JTSDK64_VERSION"
	Write-Host "---------------------------------------------"
	Write-Host ""
	Write-Host "Config: $env:jtsdk64VersionConfig"
	Write-Host ""
	Write-Host "Package       Version/Status"
	Write-Host "............................................."
	Write-Host "Unix Tools    $env:UNIXTOOLS"
	Write-Host "Source Marker $env:JT_SRC"
	$pathTest = $env:JTSDK_TOOLS + "\qt\" + $env:qtv
	if ((Test-Path $pathTest)) { 
		Write-Host "Qt            $env:QTV"
	} else {
		Write-Host "Qt            $env:QTV  Missing"
	}
	$pathTest = $env:JTSDK_TOOLS + "\fftw\" + $env:fftwv
	if ((Test-Path $pathTest)) { 
		Write-Host "FFTW          $env:fftwv"
	} else {
		Write-Host "FFTW          $env:fftwv  Missing"
	}
	$pathTest = $env:JTSDK_TOOLS + "\libusb\" + $env:libusbv
	if ((Test-Path $pathTest)) { 
		Write-Host "LibUSB        $env:libusbv"
	} else {
		Write-Host "LibUSB        $env:libusbv  Missing"
	}
	$pathTest = $env:JTSDK_TOOLS + "\nsis\" + $env:nsisv
	if ((Test-Path $pathTest)) { 
		Write-Host "NSIS          $env:nsisv"
	} else {
		Write-Host "NSIS          $env:nsisv  Missing"
	}
	$pathTest = $env:JTSDK_TOOLS + "\pkgconfig\" + $env:pkgconfigv
	if ((Test-Path $pathTest)) { 
		Write-Host "PackageConfig $env:pkgconfigv"
	} else {
		Write-Host "PackageConfig $env:pkgconfigv  Missing"
	}
	$pathTest = $env:JTSDK_TOOLS + "\ruby\" + $env:rubyv
	if ((Test-Path $pathTest)) { 
		Write-Host "Ruby          $env:rubyv"
	} else {
		Write-Host "Ruby          $env:rubyv  Missing"
	}
	$pathTest = $env:JTSDK_TOOLS + "\subversion\" + $env:svnv
	if ((Test-Path $pathTest)) { 
		Write-Host "Subversion    $env:svnv"
	} else {
		Write-Host "Subversion    $env:svnv  Missing"
	}
	if ($env:cmakev -eq "qtcmake") {
		Write-Host "CMake         $env:cmakev"
	} else {
		$pathTest = $env:JTSDK_TOOLS + "\cmake\" + $env:cmakev
		if ((Test-Path $pathTest)) { 
			Write-Host "CMake         $env:cmakev"
		} else {
			Write-Host "CMake         $env:cmakev  Not Deployed"
		}
	}
	$pathTest = $env:JTSDK_TOOLS + "\sqlite\" + $env:sqlitev
	if ((Test-Path $pathTest)) { 
		Write-Host "SQLite        $env:sqlitev"
	} else {
		Write-Host "SQLite        $env:sqlitev  Missing"
	}
	$pathTest = $env:JTSDK_TOOLS + "\boost\$env:boostv"
	if ((Test-Path $pathTest)) { 
		Write-Host "Boost         $env:boostv  Enabled"
	} else {
		Write-Host "Boost         $env:boostv  Not Deployed"
	}

	Write-Host "............................................."
	Write-Host ""
    Write-Host "Commands:"
	Write-Host ""
	Write-Host "  Deploy Boost ....... Deploy-Boost"
	Write-Host "  MSYS2 Environment .. msys2"
	Write-Host "  Build JT-ware ...... jtbuild `[option`]"
    Write-Host ""
}'