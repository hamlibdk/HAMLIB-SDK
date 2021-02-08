#-----------------------------------------------------------------------------#
# Name .........: Install-OmniRig.ps1
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
	Write-Host " OmniRig Rig Control Setup Help"
	Write-Host "-------------------------------------------------------"
	Write-Host ""
	Write-Host " Help"
	Write-Host ""
	Write-Host "   Install-Omnirig.ps1 help     Shows this help screen"
	Write-Host ""
	Write-Host " Install Omnirig"
	Write-Host ""
	Write-Host "   Install-Omnirig.ps1 install  Install Git"
	Write-Host ""
	Write-Host " Uninstall OmniRig"
	Write-Host ""
	Write-Host "   Install-Omnirig.ps1 uninstall Uninstall Git"
	Write-Host ""
	Write-Host " Verifying Omnirig Deployment"
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
	Write-Host " OmniRig Rig Control Installation Summary"
	Write-Host "-----------------------------------------------------"
	Write-Host ""
	Write-Host "* Installation Summary."
	Write-Host ""
	Write-Host "  --> Install Directory ...: $env:ProgramFiles(x86)\Afreet\Omnirig"
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
	Write-Host " OmniRig Rig Control Uninstall"
	Write-Host "-----------------------------------------------------"
	Write-Host ""
	Write-Host "* Running Uninstall for Git-SCM"
	
	$gitInstDir = "$env:PROGRAMFILES (x86)\Afreet\Omnirig"
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
	Write-Host "  --> Call to Omnirig Installer Succeeded."
	Write-Host ""
		
	$env:OMNIRIG_STATUS="Not Installed"
	exit(0)
}

# INSTALL ERROR ---------------------------------------------------------------

function InstallError {
	Write-Host ""
	Write-Host "-----------------------------------------------------"
	Write-Host " OmniRig Rig Control - Error In Installation"
	Write-Host "-----------------------------------------------------"
	Write-Host ""
	$env:OMNIRIG_STATUS="Not Installed"
	exit(-1)
}

# INSTALL Git ----------------------------------------------------------------
function InstallOmnirig {
	# Write-Host ""
	Write-Host "-----------------------------------------------------"
	Write-Host " OmniRig Rig Control Windows"
	Write-Host "-----------------------------------------------------"

    Invoke-Expression -Command $PSScriptRoot\Download-Omnirig.ps1

    $cmd = "$PSScriptRoot\OmniRigSetup.exe"
	$exitCode = Invoke-Command -ScriptBlock { cmd /c $cmd *> $null; return $LASTEXITCODE }
    if ($exitCode -ne 0) { 
        Write-Host "*** Error ***"
        InstallError 
    } else {
        Write-Host "  --> Omnirig Installation Completed."
    }
	$pathTest = "$env:PROGRAMFILES (x86)\Afreet\Omnirig\omnirig.exe"
	if ((Test-Path $pathTest)) {
		$env:GIT_CODE_STATUS="Installed"
		Write-Host "  --> Omnirig Installer indicated successful deployment"
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
    if ($args[ $i ] -eq "install"){ InstallOmnirig }
    if ($args[ $i ] -eq "uninstall"){ UnInstallOmnirig}
    if ($args[ $i ] -eq "help"){ InstallHelp }
}

Write-Host ""
Write-Host "No command `switch or invalid switch entered."
Write-Host ""
Write-Host "Valid Switches`:"
Write-Host ""
Write-Host "  install ....: Install Omnirig"
Write-Host "  uninstall ..: Un-install Omnirig"
Write-Host "  help .......: Get Installation Help"
Write-Host ""

exit(-1)
