#-----------------------------------------------------------------------------#
# Name .........: Install-PowerShell.ps1
# Project ......: Part of the JTSDK64 Tools Project
# Version ......: 3.4.0b
# Description ..: Installs and deploys The Latest version of PowerShell
#
# Usage ........: Call this from jtsdk64-postinstall.ps1 
#
# Concept ......: Greg, Beam, KI7MT, <ki7mt@yahoo.com>
# Author .......: HAMLIB SDK Contributors <hamlibdk@hotmail.com>
# Copyright ....: Copyright (C) 2024 HAMLIB SDK Contributors
# License ......: GPLv3
#
# Version 1 15-01-2024 Coordinated by Steve, VK3VM/VK3SIR
#
#-----------------------------------------------------------------------------#

Set-Location -Path $PSScriptRoot

# INSTALL_HELP ---------------------------------------------------------------#

function InstallHelp {
	Clear-Host
	Write-Host ""
	Write-Host "-------------------------------------------------------"
	Write-Host " Latest PowerShell Setup Help"
	Write-Host "-------------------------------------------------------"
	Write-Host ""
	Write-Host " Help"
	Write-Host ""
	Write-Host "   Install-PowerShell.ps1 help ..... Shows this help screen"
	Write-Host ""
	Write-Host " Install PowerShell"
	Write-Host ""
	Write-Host "   Install-PowerShell.ps1 install .. Install PowerShell"
	Write-Host ""
	Write-Host " Uninstall PowerShell"
	Write-Host ""
	Write-Host "   Install-PowerShell.ps1 uninstall . Uninstall PowerShell"
	Write-Host ""
	Write-Host " Verifying PowerShell Deployment"
	Write-Host ""
	Write-Host "   To ensure the install worked properly, exit this"
	Write-Host "   environment and re-launch jtsdk64-setup."
	Write-Host ""
	exit(0)
}

# INSTALL SUMMARY -------------------------------------------------------------
function InstallSummary {
	Write-Host ""
	Write-Host "-----------------------------------------------------"
	Write-Host " Latest PowerShell Installation Summary"
	Write-Host "-----------------------------------------------------"
	Write-Host ""
	Write-Host "* Installation Summary."
	#Write-Host ""
	Get-Host | Select-Object
	Write-Host -ForegroundColor yellow "* The Latest version of PowerShell is now deployed "
	Write-Host ""
	Write-Host "  --> To ensure that this deployment  worked properly, exit this"
	Write-Host "      environment and re-launch jtsdk64-tools."	
	Write-Host ""
	exit(0)
}

# UNINSTALL -------------------------------------------------------------------

function UnInstallPowerShell {
	Write-Host ""
	Write-Host "-----------------------------------------------------"
	Write-Host " Latest PowerShell Uninstall"
	Write-Host "-----------------------------------------------------"
	Write-Host ""
	Write-Host "* This needs to be uninstalled from the Control Panel "
	Write-Host ""
		
	# $env:PowerShell_STATUS="Not Installed"
	exit(0)
}

# INSTALL ERROR ---------------------------------------------------------------

function InstallError {
	Write-Host ""
	Write-Host "-----------------------------------------------------"
	Write-Host " Latest PowerShell - Error In Installation"
	Write-Host "-----------------------------------------------------"
	$env:PowerShell_STATUS="Not Installed"
	exit(-1)
}

# INSTALL PowerShell --------------------------------------------------------------
function InstallPowerShell {
	Write-Host ""
	Write-Host "-----------------------------------------------------"
	Write-Host " Latest PowerShell Installation"
	Write-Host "-----------------------------------------------------"
	Write-Host ""
	Write-Host -ForegroundColor Yellow "Note: Do not close any running instances of PowerShell"
	Write-Host -ForegroundColor Yellow "      even if the installer requests it"
	Write-Host ""
	$original = $Host.PrivateData.VerboseForegroundColor
	$Host.PrivateData.VerboseForegroundColor = "Gray"
	
	# Original: iex "& { $(irm https://aka.ms/install-powershell.ps1) } -UseMSI -Quiet"
	# Version below will be interactive as it would be useful for PowerShell to be updated from Windows Update (if selection made) !
	$exitCode = iex "& { $(irm https://aka.ms/install-powershell.ps1) } -UseMSI"
    #if ($exitCode -ne 0) { 
    #    Write-Host ""
	#	Write-Host -ForegroundColor red "*** *** *** Error *** *** ***"
     #   InstallError 
    #} else {
		$Host.PrivateData.VerboseForegroundColor = $original
		Write-Host ""
        Write-Host "  --> The latest PowerShell version should now be deployed."
    #}

	InstallSummary

	exit(0)
}

# -----------------------------------------------------------------------------
# Main Logic ------------------------------------------------------------------
# -----------------------------------------------------------------------------

# Process input commands

for ( $i = 0; $i -lt $args.count; $i++ ) {
    if ($args[ $i ] -eq "install"){ InstallPowerShell }
    # if ($args[ $i ] -eq "uninstall"){ UnInstallPowerShell}
    if ($args[ $i ] -eq "help"){ InstallHelp }
}

Write-Host ""
Write-Host "No command `switch or invalid switch entered."
Write-Host ""
Write-Host "Valid Switches`:"
Write-Host ""
Write-Host "  install ....: Install PowerShell"
# Write-Host "  uninstall ..: Un-install PowerShell"
Write-Host "  help .......: Get Installation Help"
Write-Host ""

exit(-1)
