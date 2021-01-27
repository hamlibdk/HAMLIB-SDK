#-----------------------------------------------------------------------------#
# Name .........: Install-Git.ps1
# Project ......: Part of the JTSDK64 Tools Project
# Version ......: 3.2.0 Beta
# Description ..: Installs Git SCM System for Windows
#
# Usage ........: Call this from jtsdk64-tools-setup => git-install $*
#
# Concept ......: Greg, Beam, KI7MT, <ki7mt@yahoo.com>
# Author .......: HAMLIB SDK COntributors <hamlibdk@hotmail.com>
# Copyright ....: Copyright (C) 2013-2021 Greg Beam, KI7MT
#               : Copyright (C) 2020-2021 HAMLIB SDK Contributors
# License ......: GPLv3
#
# Release Candidate published 18-01-2021 by Steve, VK3VM/VK3SIR
#
#-----------------------------------------------------------------------------#

Set-Location -Path $PSScriptRoot

# INSTALL_HELP ---------------------------------------------------------------#

function InstallHelp {
	Clear-Host
	Write-Host ""
	Write-Host "-------------------------------------------------------"
	Write-Host " JTSDK64 Git Source Code Management Setup Help"
	Write-Host "-------------------------------------------------------"
	Write-Host ""
	Write-Host " Help"
	Write-Host ""
	Write-Host "   Install-Git.ps1 help         Shows this help screen"
	Write-Host ""
	Write-Host " Install Git"
	Write-Host ""
	Write-Host "   Install-Git.ps1 install      Install Git"
	Write-Host ""
	Write-Host " Uninstall Git"
	Write-Host ""
	Write-Host "   Install-Git.ps1 uninstall    Uninstall Git"
	Write-Host ""
	Write-Host " Verifying Git Deployment"
	Write-Host ""
	Write-Host "   To ensure the install worked properly, exit this"
	Write-Host "   environment and re-launch jtsdk64-tools-setup."
	Write-Host ""
	Write-Host "   Test Git install with `: git `-`-version"
	Write-Host ""
	exit(0)
}

# INSTALL SUMMARY -------------------------------------------------------------
function InstallSummary {
	Write-Host ""
	Write-Host "-----------------------------------------------------"
	Write-Host " Git Source Code Management Installation Summary"
	Write-Host "-----------------------------------------------------"
	Write-Host ""
	Write-Host "* Installation Summary."
	Write-Host ""
	Write-Host "  --> Install Directory ...: $env:PROGRAMFILES\Git"
	Write-Host "  --> Test Git install ....: git `-`-version"
	Write-Host ""
	Write-Host " To ensure the install worked properly, exit this"
	Write-Host " environment and re`-launch jtsdk64-tools."	
	Write-Host ""
	exit(0)
}

# UNINSTALL -------------------------------------------------------------------

function UninstallGit {
	Write-Host ""
	Write-Host "-----------------------------------------------------"
	Write-Host " Git Source Code Management Uninstall"
	Write-Host "-----------------------------------------------------"
	Write-Host ""
	Write-Host "* Running Uninstall for Git-SCM"
	
	$gitInstDir = "$env:PROGRAMFILES\Git"
	$filePrefix = "unins*.exe"

	$proc = @(Get-ChildItem $gitInstDir -Recurse -Include $filePrefix | where {$_.length -gt 0})

	if ($proc.count -gt 0) {
		foreach ($item in $proc) {
			$exitCode = Invoke-Command -ScriptBlock { cmd /c $proc *> $null; return $LASTEXITCODE }
		}
	} else {
		Write-Host ""
		Write-Host "*** Uninstall failed: Cannot find Installer binary ***"
		Write-Host ""
		exit(1)
	}

	Write-Host ""
	Write-Host "  --> Call to Git Installer Succeeded."
	Write-Host ""
		
	$env:GIT_CODE_STATUS="Not Installed"
	exit(0)
}

# INSTALL ERROR ---------------------------------------------------------------

function InstallError {
	Write-Host ""
	Write-Host "-----------------------------------------------------"
	Write-Host " Git Source Code Management - Error In Installation"
	Write-Host "-----------------------------------------------------"
	Write-Host ""
	$env:GIT_CODE_STATUS="Not Installed"
	exit(-1)
}

# INSTALL Git ----------------------------------------------------------------
function InstallGit {
	# Write-Host ""
	Write-Host "-----------------------------------------------------"
	Write-Host "Installing Git Source Code Management Windows x64"
	Write-Host "-----------------------------------------------------"

    #Invoke-Expression -Command $PSScriptRoot\Download-Git.ps1
    Invoke-Expression -Command $PSScriptRoot\Download-GitCurrent.ps1

	#$cmd = "$PSScriptRoot\Git-2.29.2.3-64-bit.exe /SILENT /CLOSEAPPLICATIONS /RESTARTAPPLICATIONS /LOADINF=.\git.inf"
    $cmd = "$PSScriptRoot\Git-Current-x64.exe /SILENT /CLOSEAPPLICATIONS /RESTARTAPPLICATIONS /LOADINF=.\git.inf"
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
		Write-Host "  --> Git Installer indicated successful deployment"
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
    if ($args[ $i ] -eq "install"){ InstallGit }
    if ($args[ $i ] -eq "uninstall"){ UnInstallGit}
    if ($args[ $i ] -eq "help"){ InstallHelp }
}

Write-Host ""
Write-Host "No command `switch or invalid switch entered."
Write-Host ""
Write-Host "Valid Switches`:"
Write-Host ""
Write-Host "  install ....: Install Git"
Write-Host "  uninstall ..: Un-install Git"
Write-Host "  help .......: Get Installation Help"
Write-Host ""

exit(-1)
