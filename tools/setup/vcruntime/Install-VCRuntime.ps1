#-----------------------------------------------------------------------------#
# Name .........: Install-VCRuntime.ps1
# Project ......: Part of the JTSDK64 Tools Project
# Version ......: 3.2.0 Beta
# Description ..: Installs VC/C++ Runtimes for Windows
#
# Usage ........: Call this from jtsdk64-tools ==> postinstall => Install-VCRuntime [action]
#
# Concept ......: Greg, Beam, KI7MT, <ki7mt@yahoo.com>
# Author .......: HAMLIB SDK Contributors <hamlibdk@outlook.com>
# Copyright ....: Copyright (C) 2013 - 2021 Greg Beam, KI7MT
#               : Copyright (C) 2020 - 2021 HAMLIB SDK Contributors
# License ......: GPLv3
#
# Release Candidate 25-02-2021 by Steve VK3SIR/VK3VM
#
#-----------------------------------------------------------------------------#

# Ref: https://social.msdn.microsoft.com/Forums/sqlserver/en-US/c3efcec4-d4a1-4eee-ac2c-43ce9c892913/how-to-install-vc-redistributable-package-silently?forum=vssetup

Set-Location -Path $PSScriptRoot

# INSTALL_HELP ---------------------------------------------------------------#

function InstallHelp {
	Clear-Host
	Write-Host ""
	Write-Host "-------------------------------------------------------"
	Write-Host " JTSDK64 Visual C/C++ Runtime Setup Help"
	Write-Host "-------------------------------------------------------"
	Write-Host ""
	Write-Host " Help"
	Write-Host ""
	Write-Host "   Install-VCRuntime.ps1 help       Shows this help screen"
	Write-Host ""
	Write-Host " Install Visual C/C++ Runtime"
	Write-Host ""
	Write-Host "   Install-VCRuntime.ps1 install    Install Latest VC++ Runtime Package"
	Write-Host ""
	Write-Host " Uninstall Visual C/C++ Runtime"
	Write-Host ""
	Write-Host "   Install-VCRuntime.ps1 uninstall  Uninstall VC++ Runtime"
	Write-Host ""
	Write-Host " Verifying Visual C/C++ Runtime Deployment"
	Write-Host ""
	Write-Host "   To ensure the install worked properly, exit this"
	Write-Host "   environment and re-launch jtsdk64-tools."
	Write-Host ""
	exit(0)
}

# INSTALL SUMMARY -------------------------------------------------------------
function InstallSummary {
	Write-Host ""
	Write-Host "-----------------------------------------------------"
	Write-Host " Visual C/C++ Runtime Installation Summary"
	Write-Host "-----------------------------------------------------"
	Write-Host ""
	Write-Host "* Visual C/C++ Runtimes Deployed."
    Write-Host ""
	Write-Host " Note: Tools such as the Qt Installer may not run"
	Write-Host " without this."
	Write-Host ""
	Write-Host " Test for deployment by re-running jtsdk64-tools.ps1"
	Write-Host ""

	exit(0)
}

# INSTALL ERROR ---------------------------------------------------------------

function InstallError ($oper) {
	Write-Host ""
	Write-Host "-----------------------------------------------------"
	Write-Host " Visual C/C++ Runtime - Error In $oper"
	Write-Host "-----------------------------------------------------"
	Write-Host ""
	$env:VS_CODE_STATUS="Not Installed"
	exit(-1)
}

# UNINSTALL -------------------------------------------------------------------

function UninstallVCRuntime {
	# Write-Host ""
	Write-Host "-----------------------------------------------------"
	Write-Host "Uninstalling Visual C/C++ x86 and x64 Runtimes"
	Write-Host "-----------------------------------------------------"

    Invoke-Expression -Command $PSScriptRoot\Download-VCRuntime.ps1

	$cmd = "$PSScriptRoot\vc_redist.x86.exe /uninstall /silent"
	$exitCode = Invoke-Command -ScriptBlock { cmd /c $cmd *> $null; return $LASTEXITCODE }
    if ($exitCode -ne 0) { 
        InstallError("x86 Uninstall") 
    } else {
        Write-Host "  --> Visual C/C++ x86 Runtime Uninstalled"
    }
	
	$cmd = "$PSScriptRoot\vc_redist.x64.exe /uninstall /silent"
	$exitCode = Invoke-Command -ScriptBlock { cmd /c $cmd *> $null; return $LASTEXITCODE }
    if ($exitCode -ne 0) { 
        InstallError("x86 Uninstall") 
    } else {
        Write-Host "  --> Visual C/C++ x64 Runtime Uninstalled"
    }
	#Write-Host ""
	exit(0)
}

# INSTALL VC/C++ -------------------------------------------------------------

function InstallVCRuntime {
	# Write-Host ""
	Write-Host "-----------------------------------------------------"
	Write-Host "Installing Visual C/C++ x86 and x64 Runtimes"
	Write-Host "-----------------------------------------------------"

    Invoke-Expression -Command $PSScriptRoot\Download-VCRuntime.ps1

	$cmd = "$PSScriptRoot\vc_redist.x86.exe /silent"
	$exitCode = Invoke-Command -ScriptBlock { cmd /c $cmd *> $null; return $LASTEXITCODE }
    if ($exitCode -ne 0) { 
        InstallError("x86 Install") 
    } else {
        Write-Host "  --> Visual C/C++ x86 Runtime Installation Complete"
    }
	$cmd = "$PSScriptRoot\vc_redist.x64.exe /silent"
	$exitCode = Invoke-Command -ScriptBlock { cmd /c $cmd *> $null; return $LASTEXITCODE }
    if ($exitCode -ne 0) { 
        InstallError("x86 Install") 
    } else {
        Write-Host "  --> Visual C/C++ x64 Runtime Installation Complete"
    }
	#Write-Host ""
	exit(0)
}

# -----------------------------------------------------------------------------
# Main Logic ------------------------------------------------------------------
# -----------------------------------------------------------------------------

# Process input commands

for ( $i = 0; $i -lt $args.count; $i++ ) {
    if ($args[ $i ] -eq "install"){ InstallVCRuntime }
    if ($args[ $i ] -eq "uninstall"){ UnInstallVCRuntime}
    if ($args[ $i ] -eq "help"){ InstallHelp }
	if ($args[ $i ] -eq "-h"){ InstallHelp }
}

Write-Host ""
Write-Host "No command `switch or invalid switch entered."
Write-Host ""
Write-Host "Valid Switches`:"
Write-Host ""
Write-Host "  install ....: Install Latest VC/C++ Runtime"
Write-Host "  uninstall ..: Un-install VC/C++ Runtime"
Write-Host "  help .......: Get Installation Help"
Write-Host ""

exit(-1)
