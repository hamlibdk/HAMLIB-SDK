#-----------------------------------------------------------------------------#
# Name .........: Install-VSCode.ps1
# Project ......: Part of the JTSDK64 Tools Project
# Version ......: 3.2.2
# Description ..: Installs VS Code for Windows
#
# Usage ........: Call this from jtsdk64-tools-setup => Install-VSCode [action]
#
# Concept ......: Greg, Beam, KI7MT, <ki7mt@yahoo.com>
# Author .......: HAMLIB SDK Contributors <hamlibdk@hotmail.com>
# Copyright ....: Copyright (C) 2013 - 2021 Greg Beam, KI7MT
#               : Copyright (C) 2020 - 2022 HAMLIB SDK Contributors
# License ......: GPLv3
#
# Release Candidate 17-01-2021 - 25-2-2021 by Steve VK3SIR/VK3VM
#
#-----------------------------------------------------------------------------#

Set-Location -Path $PSScriptRoot

# INSTALL_HELP ---------------------------------------------------------------#

function InstallHelp {
	Clear-Host
	Write-Host ""
	Write-Host "-------------------------------------------------------"
	Write-Host " JTSDK64 Visual Studio Code Setup Help"
	Write-Host "-------------------------------------------------------"
	Write-Host ""
	Write-Host " Help"
	Write-Host ""
	Write-Host "   Install-VSCode.ps1 help ....... Shows help screen"
	Write-Host ""
	Write-Host " Install Visual Studio Code"
	Write-Host ""
	Write-Host "   Install-VSCode.ps1 install .... Install VS Code"
	Write-Host ""
	Write-Host " Uninstall Visual Studio Code"
	Write-Host ""
	Write-Host "   Install-VSCode.ps1 uninstall .. Uninstall VS Code"
	Write-Host ""
	Write-Host " Verifying VS Code Deployment"
	Write-Host ""
	Write-Host "   To ensure the install worked properly, exit this"
	Write-Host "   environment and re-launch jtsdk64-tools."
	Write-Host ""
	Write-Host " Test VS Code install with `: code `-`-version"
	Write-Host ""
	exit(0)
}

# INSTALL SUMMARY -------------------------------------------------------------
function InstallSummary {
	Write-Host ""
	Write-Host "-----------------------------------------------------"
	Write-Host " Visual Studio Code Installation Summary"
	Write-Host "-----------------------------------------------------"
	Write-Host ""
	Write-Host "* Installation Summary."
	Write-Host ""
	Write-Host "  --> Install Directory`: $env:USERPROFILE\AppData\Local\Programs\Microsoft VS Code"
	Write-Host "  --> Test VS Code install`: code `-`-version"
    Write-Host ""
	Write-Host " To ensure the install worked properly, exit the setup"
	Write-Host " environment and re`-launch jtsdk64-tools."
	Write-Host ""

	exit(0)
}

# UNINSTALL -------------------------------------------------------------------

function UninstallVSCode {
	Write-Host ""
	Write-Host "-----------------------------------------------------"
	Write-Host " Visual Studio Code Uninstall"
	Write-Host "-----------------------------------------------------"
	Write-Host ""
	Write-Host "* Running Uninstall for VS Code"
		
	$vscInstDir = "$env:LOCALAPPDATA\Programs\Microsoft VS Code\"
	$filePrefix = "unins*.exe"

	if (Test-Path $vscInstDir) {
		$proc = @(Get-ChildItem $vscInstDir -Recurse -Include $filePrefix | where {$_.length -gt 0})
	}
	if ($proc.count -gt 0) {
		foreach ($item in $proc) {
			$exitCode = Invoke-Command -ScriptBlock { cmd /c $proc *> $null; return $LASTEXITCODE }
		}
	} else {
		Write-Host ""
		Write-Host "*** Uninstall failed: Cannot find VS Code Installer binary ***"
		Write-Host ""
		exit(1)
	}
	
	Write-Host ""
	Write-Host "  --> Call to VS Code Installer Succeeded."
	Write-Host ""
	
	$env:VS_CODE_STATUS="Not Installed"
	exit(0)
}

# INSTALL ERROR ---------------------------------------------------------------

function InstallError {
	Write-Host ""
	Write-Host "-----------------------------------------------------"
	Write-Host " Visual Studio Code - Error In Installation"
	Write-Host "-----------------------------------------------------"
	Write-Host ""
	$env:VS_CODE_STATUS="Not Installed"
	exit(-1)
}

# INSTALL VS Code -------------------------------------------------------------
function InstallVSCode {
	# Write-Host ""
	Write-Host "-----------------------------------------------------"
	Write-Host "Installing Visual Studio Code"
	Write-Host "-----------------------------------------------------"

    Invoke-Expression -Command $PSScriptRoot\Download-VSCode.ps1

	$cmd = "$PSScriptRoot\VSCodeUserSetup-x64.exe /SP- /NOCANCEL /SILENT /CLOSEAPPLICATIONS /RESTARTAPPLICATIONS /LOADINF=.\vscode.inf"
	$exitCode = Invoke-Command -ScriptBlock { cmd /c $cmd *> $null; return $LASTEXITCODE }
    if ($exitCode -ne 0) { 
        Write-Host "*** Error ***"
        InstallError 
    } else {
        Write-Host "  --> Visual Studio Code Installation Complete"
    }
	$pathTest = "$env:LOCALAPPDATA\Programs\Microsoft VS Code\Code.exe"
	if ((Test-Path $pathTest)) {
		$env:VS_CODE_STATUS="Installed"
		Write-Host "  --> VS Code Installer indicated successful deployment"
		InstallSummary
	} else {
		Write-Host "*** Install failed. Post Comment on JTSDK`@Groups.io ***"
		Write-Host ""
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
	if ($args[ $i ] -eq "-h"){ InstallHelp }
}

Write-Host ""
Write-Host "No command `switch or invalid switch entered."
Write-Host ""
Write-Host "Valid Switches`:"
Write-Host ""
Write-Host "  install ....: Install Latest VS Code"
Write-Host "  uninstall ..: Un-install VS Code"
Write-Host "  help .......: Get Installation Help"
Write-Host ""

exit(-1)
