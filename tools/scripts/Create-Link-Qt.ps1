#-----------------------------------------------------------------------------
# Name .........: Create-Link-Qt.ps1
# Project ......: Part of the JTSDK64 Tools Project
# Version ......: 4.0.0a
# Description ..: Many ops now deploy Qt to X:\Qt
#                 This script creates a link inside X\JTSDK64-Tools\Tools
#                 to your Qt deployment.
# Original URL .: https://github.com/KI7MT/jtsdk64-tools.git
# Project URL ..: https://sourceforge.net/projects/hamlib-sdk
# Usage ........: Call this file directly from the command line
# 
# Author .......: Hamlib SDK Contributors <hamlibdk@outlook.com>
#
# Concept ......: Greg Beam, KI7MT, <ki7mt@yahoo.com>
#
# Copyright ....: (C) 2013-2021 Greg Beam, KI7MT
#                 (C) 2020-2025 JTSDK Contributors
# License ......: GPL-3
#
# Adjustments...: Creation - Very Basic - 2024-11-02 Coordinated by Steve VK3VM 
#               : Try/Catch experimentation with New-Item 2024-12-01-->08 coordinated by Steve I VK3VM
#-----------------------------------------------------------------------------

Write-Host "------------------------------------------------------"
Write-Host " JTSDK64 Tools Create Link to Qt Deployment"
Write-Host "------------------------------------------------------"
Write-Host ""
try {
	if (-Not (Test-Path("$env:SystemDrive:\JTSDK64-Tools\tools\Qt"))) {
		$junk = New-Item -Path "$env:SystemDrive:\JTSDK64-Tools\tools\Qt" -ItemType Junction -Value "$env:SystemDrive:\Qt"
		Write-Host "* Junction created:"$env:SystemDrive"\Qt --> "$env:SystemDrive"\JTSDK64-Tools\tools\Qt"
	} else {
		Write-Host "* The Junction may already exist!" -ForegroundColor yellow
	}
}
catch {
	Write-Host "* Unable to create Junction in $env:SystemDrive:\JTSDK64-Tools\tools\Qt"
	Write-Host ""
	Write-Host "--> The Junction may already exist. Also check to see that Qt is deployed into C:\Qt"
}
finally {
	Write-Host ""
	# Write-Host "Command Completed"
}