#-----------------------------------------------------------------------------#
# Name .........: Install-Qt.ps1
# Project ......: Part of the JTSDK64 Tools Project
# Version ......: 3.2.0
# Description ..: Installs Qt for Windows tailored for JT- Applications
#
# Usage ........: Call this from jtsdk64-tools-setup => Install-Qt.ps1 [option]
#
# Concept ......: Greg, Beam, KI7MT, <ki7mt@yahoo.com>
# Author .......: HAMLIB SDK COntributors <hamlibdk@hotmail.com>
# Copyright ....: Copyright (C) 2013 - 2021 Greg Beam, KI7MT
#               : Copyright (C) 2020 - 2021 HAMLIB SDK Contributors
# License ......: GPLv3
#
# Conversion and logic refactoring Steve VK3SIR 25-12-2020 - 18-1-2021
# Updates for Qt 6.0.3 17 Apr 2021 and Qt 5.12.11 27-05-2021
#
#-----------------------------------------------------------------------------#

Set-Location -Path $PSScriptRoot

# INSTALL ERROR ---------------------------------------------------------------

function InstallError($msg) {
	#Write-Host ""
	Write-Host "-----------------------------------------------------"
	Write-Host " JTSDK64 Qt Error In Installation"
	Write-Host "-----------------------------------------------------"
	Write-Host ""
	Write-Host $msg
	Write-Host ""
	Write-Host "If further failures post comment on JTSDK^@Groups.io"
	Write-Host ""
	$env:QT_STATUS="Not Installed"
	exit(-1)
}

# INSTALL Qt ------------------------------------------------------------------

function InstallQt($script) {
	
	Write-Host "-----------------------------------------------------"
	Write-Host " Qt Installation"
	Write-Host "-----------------------------------------------------"

	Invoke-Expression -Command $PSScriptRoot\Download-QtInstaller.ps1

	#Deal with 	Online Installer unable to be downloaded
	$exe = "$PSScriptRoot\qt-unified-windows-x86-online.exe"
	if (Test-Path $exe) {
		Write-Host "  --> Validated Installation `[$exe`]"
	} else {
		$msg="*** *** Cannot find Qt Installer *** ***"
		InstallError($msg)
	}
	
	Write-Host "  --> Check if Qt already installed"
	# Check to see that Qt is not already installed
	$exe = "$env:JTSDK_TOOLS"+"\Qt\MaintenanceTool.exe"
	if ((Test-Path $exe) -ne 0) { PreviousQtInstall }
	
	Write-Host ""
	Write-Host "-----------------------------------------------------"
	Write-Host " Installing Qt Using Generated QS Scripts"
	Write-Host "-----------------------------------------------------"
	Write-Host ""
	Write-Host " NOTE: Some installer buttons are disabled. To Cancel"
	Write-Host " or Stop the installation, kill the Qt Installer via"
	Write-Host " the Windows Task Manager."
	Write-Host ""
	Write-Host " USER ACTION: Once the Installer starts you will be "
	Write-Host " asked to enter Qt account details or to Create a Qt"
	Write-Host " account. After that you will be asked whether you want"
    Write-Host " to feed back quality information to Qt."
	Write-Host ""
	Write-Host "* Starting Qt Installation. "
	Write-Host ""
	Write-Host "  --> Deploying via script `[$script`]"
	
	# This version specifies the closest pool mirror as source
	$cmd = "qt-unified-windows-x86-online.exe --script .\qt`-$script`-install.qs"
	# This version specifies the funet.fi mirror as source
	# $cmd = "qt-unified-windows-x86-online.exe --script .\qt`-$script`-install.qs `-`-mirror http`:`/`/www.nic.funet.fi`/pub`/mirrors`/download.qt-project.org"
	$exitCode = Invoke-Command -ScriptBlock { cmd /c $cmd *> $null; return $LASTEXITCODE }
	# A proper exit returns 1 at the moment ... crazy !
	IF ($LASTEXITCODE -eq 1) {
		Write-Host "  --> Install Check Passed"
	} else {
		$msg = "*** Install failed. Try gain.***"
		InstallError($msg)
		exit(-1)
	}
	InstallSummary
}

function UpdateQt {
	Write-Host ""
	Write-Host "-----------------------------------------------------"
	Write-Host " JTSDK64 Qt Maintainence Tool Update Components"
	Write-Host "-----------------------------------------------------"
	Write-Host ""
	Write-Host "* Starting Qt Maintainence Tool to Update Components."
	Write-Host ""
	$exe = "$JTSDK_TOOLS\Qt\MaintenanceTool.exe"
	if (Test-Path $exe) {
		Write-Host "  --> Validated Installation `[$exe`]"
	} else {
		$msg="*** *** Cannot find Qt Installer *** ***"
		InstallError($msg)
	}
	cmd = "$JTSDK_TOOLS\Qt\MaintenanceTool.exe --updater"
	$exitCode = Invoke-Command -ScriptBlock { cmd /c $cmd *> $null; return $LASTEXITCODE }
	
	exit($LASTEXITCODE)
}

# MANAGE_PACKAGES ----------------------------------------------------------------

function ManageQt {
	Write-Host ""
	Write-Host "-----------------------------------------------------"
	Write-Host " JTSDK64 Qt Maintainence Tool Manage Components"
	Write-Host "-----------------------------------------------------"
	Write-Host ""
	Write-Host "* Starting Qt Maintainence Tool to Manage Components."
	Write-Host ""
	$exe = "$JTSDK_TOOLS\Qt\MaintenanceTool.exe"
	if (Test-Path $exe) {
		Write-Host "  --> Validated Installation `[$exe`]"
	} else {
		$msg="*** *** Cannot find Qt Installer *** ***"
		InstallError($msg)
	}
	cmd = "$JTSDK_TOOLS\Qt\MaintenanceTool.exe --manage-packages"
	$exitCode = Invoke-Command -ScriptBlock { cmd /c $cmd *> $null; return $LASTEXITCODE }
	
	exit($LASTEXITCODE)
}

# PREVIOUS INSTALL -----------------------------------------------------------#

function PreviousQtInstall {
	Clear-Host
	Write-Host "-----------------------------------------------------"
	Write-Host " JTSDK64 Qt Setup Previous Install Found"
	Write-Host "-----------------------------------------------------"
	Write-Host ""
	Write-Host " The install script found MaintenanceTool.exe in the"
	Write-Host " target install directory. This prevents the use of"
	Write-Host " generated QS scripts to perform an installation."
	Write-Host ""
	Write-Host " Run `"MaintenanceTool.exe`" in the Qt deployment"
	Write-Host " directory to add, remove and`/or update components."
	Write-Host ""

	exit(0)
}
# INSTALL_HELP ---------------------------------------------------------------#

function InstallHelp {
	Clear-Host
	Write-Host ""	
	Write-Host "-----------------------------------------------------"
	Write-Host " JTSDK64 Qt Installation Help"
	Write-Host "-----------------------------------------------------"
	Write-Host ""
	Write-Host " This script can install Qt using one of two deploys:"
	Write-Host ""
	Write-Host "   1. Minimial (qt-min-install.qs)"
	Write-Host ""
	Write-Host "      Installs the following components:"
	Write-Host ""
	Write-Host "        qt.tools.qtcreator"
	Write-Host "        qt.tools.maintenance"
	Write-Host "        qt.tools.cmake.win64"
	Write-Host "        qt.qt5.51211.win64_mingw73"
	Write-Host "        qt.tools.win64_mingw730"
	Write-Host "        qt.tools.vcredist_msvc2017_x64"
	Write-Host "        qt.tools.vcredist_msvc2019_x64"
	Write-Host ""
	Write-Host "   2. Full (qt-full-install.qs)"
	Write-Host ""
	Write-Host "      Installs Minimal, plus additional versions:"
	Write-Host ""
	Write-Host "        qt.qt5.5152.win64_mingw73"
	Write-Host "        qt.qt6.612.win64_mingw81"
	Write-Host "        qt.tools.win64_mingw810"
	Write-Host ""
	Write-Host " Usage:"
	Write-Host ""
	Write-Host "   InstallQt.ps1 help .... Display this help message"
	Write-Host "   InstallQt.ps1 min ..... Install minimal components"
	Write-Host "   InstallQt.ps1 full .... Install all components"
	Write-Host "   InstallQt.ps1 update .. Update components"
	Write-Host "   InstallQt.ps1 manage .. Manage installed components"
	Write-Host ""
	Write-Host " Uninstall:"
	Write-Host ""
	Write-Host "   To uninstall Qt, launch the Maintenance Tool and"
	Write-Host "   select uninstall when asked."
	Write-Host ""
	Write-Host "   Location : $JTSDK_TOOLS\Qt\MaintenanceTool.exe"
	Write-Host ""	
	
	exit(0)
}

# INSTALL SUMMARY -------------------------------------------------------------

function InstallSummary {
	
	Write-Host ""
	Write-Host "-----------------------------------------------------"
	Write-Host " JTSDK64 Qt Install Summary"
	Write-Host "-----------------------------------------------------"
	Write-Host ""
	Write-Host " JTSDK64 Tools Qt Install Complete. The following"
	Write-Host " components were installed:"
	Write-Host ""
	if ($script -eq "min") {
		Write-Host " Install Type .... Minimal"
		Write-Host " Install Script .. $env:JTSDK_SETUP\qt\qt-$script`-install.qs"
		Write-Host " Location ........ $env:JTSDK_TOOLS\Qt"
		Write-Host ""
		Write-Host " Qt Components:"
		Write-Host ""
		Write-Host "    qt.tools.qtcreator"
		Write-Host "    qt.tools.maintenance"
		Write-Host "    qt.tools.cmake.win64"
		Write-Host "    qt.qt5.51211.win64_mingw73"
		Write-Host "    qt.tools.win64_mingw730"
		Write-Host "    qt.tools.vcredist_msvc2017_x64"
		Write-Host "    qt.tools.vcredist_msvc2019_x64"
	}
	if ($script -eq "full") {
		Write-Host " Install `Type .... Full"
		Write-Host " Install Script .. $JTSDK_SETUP\qt\qt-$script`-install.qs"
		Write-Host " Location ........ $JTSDK_TOOLS\Qt"
		Write-Host ""
		Write-Host " Qt Components:"
		Write-Host ""
		Write-Host "    qt.tools.qtcreator"
		Write-Host "    qt.tools.maintenance"
		Write-Host "    qt.tools.cmake.win64"
		Write-Host "    qt.qt5.51211.win64_mingw73"
		Write-Host "    qt.qt5.5152.win64_mingw81"
		Write-Host "    qt.qt6.612.win64_mingw81"
		Write-Host "    qt.tools.win64_mingw730"
		Write-Host "    qt.tools.win64_mingw810"
		Write-Host "    qt.tools.vcredist_msvc2017_x64"
		Write-Host "    qt.tools.vcredist_msvc2019_x64"
	}
	Write-Host ""
	Write-Host " To ensure the install worked properly, exit"
	Write-Host " the setup environment. Re-launch jtsdk64-setup "
	Write-Host " checking the status of each component"
	Write-Host ""
	
	exit(0)
}

# -----------------------------------------------------------------------------
# Main Logic ------------------------------------------------------------------
# -----------------------------------------------------------------------------

Set-Location -Path "$PSScriptRoot"

# Process input commands

for ( $i = 0; $i -lt $args.count; $i++ ) {
    if ($args[ $i ] -eq "min"){ InstallQt("min") }
	if ($args[ $i ] -eq "full"){ InstallQt("full") }
    if ($args[ $i ] -eq "update"){ UpdateQt }
	if ($args[ $i ] -eq "manage"){ ManageQt }
    if ($args[ $i ] -eq "help"){ InstallHelp }
	if ($args[ $i ] -eq "-h"){ InstallHelp }
}

Write-Host ""
Write-Host "No command `switch or invalid switch entered."
Write-Host ""
Write-Host "Valid Switches`:"
Write-Host ""
Write-Host "  min    - Scripted installation Qt MinGW 5.12.11 only"
Write-Host "  full   - Scripted installation Qt 5.12.11, 5.15.2, 6.1.2"
Write-Host "  update - Update Qt Deployment"
Write-Host "  manage - Manage Qt Deployment"
Write-Host "  help   - Get Installation Help"
Write-Host ""

exit(-1)