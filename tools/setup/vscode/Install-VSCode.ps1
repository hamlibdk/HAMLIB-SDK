#-----------------------------------------------------------------------------#
# Name .........: Install-VSCode.ps1
# Project ......: Part of the JTSDK64 Tools Project
# Version ......: 3.2.0 Beta
# Description ..: Installs VS Code for Windows
#
# Usage ........: Call this from jtsdk64-tools-setup => vscode-install $*
#
# Concept ......: Greg, Beam, KI7MT, <ki7mt@yahoo.com>
# Author .......: HAMLIB SDK COntributors <hamlibdk@hotmail.com>
# Copyright ....: Copyright (C) 2013-2019 Greg Beam, KI7MT
#               : Copyright (C) 2020 - HAMLIB SDK Contributors
# License ......: GPLv3
#
#-----------------------------------------------------------------------------#

Set-Location -Path $PSScriptRoot

# INSTALL_HELP ---------------------------------------------------------------#

function InstallHelp {
	Clear-Host
	Write-Host " "
	Write-Host "-------------------------------------------------------"
	Write-Host " JTSDK64 VS Code Setup Help"
	Write-Host "-------------------------------------------------------"
	Write-Host " "
	Write-Host " Use the following commands to install and configure"
	Write-Host " Microsoft VS Code."
	Write-Host " "
	Write-Host " Install-VSCode.ps1 help          Shows this help screen"
	Write-Host " Install-VSCode.ps1 install       Install VS Code"
	Write-Host " "
	Write-Host " Uninstall"
	Write-Host " "
	Write-Host "   Install-VSCode.ps1 uninstall   Uninstall VS Code"
	Write-Host " "
	Write-Host " To ensure the install worked properly,"
	Write-Host " exit the setup environment and re-launch"
	Write-Host " jtsdk64-tools-setup."
	Write-Host " "
	Write-Host " Test VS Code install with `: code `-`-version"
	Write-Host " "
	exit(0)
}

# INSTALL SUMMARY -------------------------------------------------------------
function InstallSummary {
	Write-Host " "
	Write-Host "-----------------------------------------------------"
	Write-Host " JTSDK64 VS Code Installation Summary"
	Write-Host "-----------------------------------------------------"
	Write-Host " "
	Write-Host " JTSDK64 Tools Installation Complete."
	Write-Host " "
	Write-Host " Installation Summary."
	Write-Host " "
	Write-Host " --> Install Directory   `: $PSScriptRoot"
	Write-Host " --> Test VS Code install`: code `-`-version"
    Write-Host " "
	Write-Host " To ensure the install worked properly, exit the setup"
	Write-Host " environment and re`-launch jtsdk64-tools-setup."

	exit(0)
}

# UNINSTALL -------------------------------------------------------------------

function UninstallVSCode {
	Write-Host " "
	Write-Host "-----------------------------------------------------"
	Write-Host " JTSDK64 VS Code Uninstall"
	Write-Host "-----------------------------------------------------"
	Write-Host " "
	Write-Host "Running Uninstall for VS Code"
	$pathTest = "$env:LOCALAPPDATA\Programs\Microsoft VS Code\unins000.exe"
	if ((Test-Path $pathTest)) {
		call "$LOCALAPPDATA\Programs\Microsoft VS Code\unins000.exe"
	} else {
		Write-Host " "
		Write-Host "Uninstall failed, cannot find Code`.exe binary."
		exit(1)
	}
	$env:VS_CODE_STATUS="Not Installed"
	exit(0)
}

# INSTALL ERROR ---------------------------------------------------------------

function InstallError {
	Write-Host " "
	Write-Host "-----------------------------------------------------"
	Write-Host " JTSDK64 VS Code Error In Installation"
	Write-Host "-----------------------------------------------------"
	Write-Host " "
	$env:VS_CODE_STATUS="Not Installed"
	exit(-1)
}

# INSTALL VS Code -------------------------------------------------------------
function InstallVSCode {
	Write-Host " "
	Write-Host "-----------------------------------------------------"
	Write-Host "Installing VS Code"
	Write-Host "-----------------------------------------------------"

    Invoke-Expression -Command $PSScriptRoot\Download-VSCode.ps1

	$cmd = "$PSScriptRoot\VSCodeUserSetup-x64.exe /SP- /NOCANCEL /SILENT /CLOSEAPPLICATIONS /RESTARTAPPLICATIONS /LOADINF=.\vscode.inf"
	$exitCode = Invoke-Command -ScriptBlock { cmd /c $cmd *> $null; return $LASTEXITCODE }
    if ($exitCode -ne 0) { 
        Write-Host "*** Error ***"
        InstallError 
    } else {
        Write-Host "  --> Installation Complete"
    }
	$pathTest = "$env:LOCALAPPDATA\Programs\Microsoft VS Code\Code.exe"
	if ((Test-Path $pathTest)) {
		$env:VS_CODE_STATUS="Installed"
		Write-Host "  --> Install Check Passed"
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
    if ($args[ $i ] -eq "install"){ InstallVSCode }
    if ($args[ $i ] -eq "uninstall"){ UnInstallVSCode}
    if ($args[ $i ] -eq "help"){ InstallHelp }
}

Write-Host " "
Write-Host "No command `switch or invalid switch entered."
Write-Host " "
Write-Host "Valid Switches`:"
Write-Host " "
Write-Host "  install  - Install Latest VS Code"
Write-Host "  uninstall - Un-install VS Code"
Write-Host "  help - Get Installation Help"

exit(-1)
