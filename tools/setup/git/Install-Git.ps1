#-----------------------------------------------------------------------------#
# Name .........: Install-Git.ps1
# Project ......: Part of the JTSDK64 Tools Project
# Version ......: 3.2.0 Beta
# Description ..: Installs VS Code for Windows
#
# Usage ........: Call this from jtsdk64-tools-setup => git-install $*
#
# Concept ......: Greg, Beam, KI7MT, <ki7mt@yahoo.com>
# Author .......: HAMLIB SDK COntributors <hamlibdk@hotmail.com>
# Copyright ....: Copyright (C) 2013-2019 Greg Beam, KI7MT
#               : Copyright (C) 2020 HAMLIB SDK Contributors
# License ......: GPLv3
#
#-----------------------------------------------------------------------------#

Set-Location -Path $PSScriptRoot

# INSTALL_HELP ---------------------------------------------------------------#

function InstallHelp {
	Clear-Host
	Write-Host " "
	Write-Host "-------------------------------------------------------"
	Write-Host " JTSDK64 Git Setup Help"
	Write-Host "-------------------------------------------------------"
	Write-Host " "
	Write-Host " Use the following commands to install and configure  Git."
	Write-Host " "
	Write-Host " Install-Git.ps1 help             Shows this help screen"
	Write-Host " Install-Git.ps1 install          Install VS Code"
	Write-Host " "
	Write-Host " Uninstall"
	Write-Host " "
	Write-Host "   Install-Git.ps1 uninstall      Uninstall Git"
	Write-Host " "
	Write-Host " To ensure the install worked properly,"
	Write-Host " exit the setup environment and re-launch"
	Write-Host " jtsdk64-tools-setup."
	Write-Host " "
	Write-Host " Test Git install with `: git `-`-version"
	exit(0)
}

# INSTALL SUMMARY -------------------------------------------------------------
function InstallSummary {
	Write-Host " "
	Write-Host "-----------------------------------------------------"
	Write-Host " JTSDK64 Git Installation Summary"
	Write-Host "-----------------------------------------------------"
	Write-Host " "
	Write-Host " JTSDK64 Tools Installation Complete."
	Write-Host " "
	Write-Host " Installation Summary."
	Write-Host " "
	Write-Host " --> Install Directory   `: $PSScriptRoot"
	Write-Host " --> Test Git install`    : git `-`-version"
    Write-Host " "
	Write-Host " To ensure the install worked properly, exit the setup"
	Write-Host " environment and re`-launch jtsdk64-tools-setup."
	exit(0)
}

# UNINSTALL -------------------------------------------------------------------

function UninstallGit {
	Write-Host " "
	Write-Host "-----------------------------------------------------"
	Write-Host " JTSDK64 Git Uninstall"
	Write-Host "-----------------------------------------------------"
	Write-Host " "
	Write-Host "Running Uninstall for VS Code"
	$pathTest = "$env:PROGRAMFILES\Git\unins000.exe"
	if ((Test-Path $pathTest)) {
		call "$env:PROGRAMFILES\Git\unins000.exe"
	} else {
		Write-Host " "
		Write-Host "Uninstall failed, cannot find uninstall binary."
		exit(1)
	}
	$env:GIT_CODE_STATUS="Not Installed"
	exit(0)
}

# INSTALL ERROR ---------------------------------------------------------------

function InstallError {
	Write-Host " "
	Write-Host "-----------------------------------------------------"
	Write-Host " JTSDK64 Git - Error In Installation"
	Write-Host "-----------------------------------------------------"
	Write-Host " "
	$env:GIT_CODE_STATUS="Not Installed"
	exit(-1)
}

# INSTALL Git ----------------------------------------------------------------
function InstallGit {
	Write-Host " "
	Write-Host "-----------------------------------------------------"
	Write-Host "Installing Command Line Git"
	Write-Host "-----------------------------------------------------"

    Invoke-Expression -Command $PSScriptRoot\Download-Git.ps1

	$cmd = "$PSScriptRoot\Git-2.29.2.3-64-bit.exe /SILENT /CLOSEAPPLICATIONS /RESTARTAPPLICATIONS /LOADINF=.\git.inf"
	$exitCode = Invoke-Command -ScriptBlock { cmd /c $cmd *> $null; return $LASTEXITCODE }
    if ($exitCode -ne 0) { 
        Write-Host "*** Error ***"
        InstallError 
    } else {
        Write-Host "  --> Git Installation Completed."
    }
	$pathTest = "$env:PROGRAMFILES\Git\bin\git.exe"
	if ((Test-Path $pathTest)) {
		$env:GIT_CODE_STATUS="Installed"
		Write-Host "  --> Git Install Check Passed"
		InstallSummary
	} ELSE {
		Write-Host "Install failed. Post Comment on JTSDK@Groups.io"
		exit(1)
	}

	exit(0)
}

# -----------------------------------------------------------------------------
# Main Logic ------------------------------------------------------------------
# -----------------------------------------------------------------------------

# Process input commands

for ( $i = 0; $i -lt $args.count; $i++ ) {
    if ($args[ $i ] -eq "install"){ InstallGit }
    if ($args[ $i ] -eq "uninstall"){ UnInstallGit}
    if ($args[ $i ] -eq "help"){ InstallHelp }
}

Write-Host " "
Write-Host "No command `switch or invalid switch entered."
Write-Host " "
Write-Host "Valid Switches`:"
Write-Host " "
Write-Host "  install  - Install Git"
Write-Host "  uninstall - Un-install Git"
Write-Host "  help - Get Installation Help"

exit(-1)
