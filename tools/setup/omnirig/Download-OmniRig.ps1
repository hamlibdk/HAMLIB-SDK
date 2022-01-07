#-----------------------------------------------------------------------------#
# Name .........: Download-Omnirig.ps1
# Project ......: Part of the JTSDK64 Tools Project
# Version ......: 3.2.2
# Description ..: Downloads the latest Git Installer
# Usage ........: Call this file directly from the command line
#
# Concept ......: Greg, Beam, KI7MT, <ki7mt@yahoo.com>
# Author .......: Hamlib SDK Contributors <hamlibdk@hotmail.com>
# Copyright ....: Copyright (C) 2013-2021 Greg Beam, KI7MT
#               : (C) 2020 - 2022 Hamlib SDK Contributors
# License ......: GPL-3
#
#-----------------------------------------------------------------------------#

Set-Location -Path $PSScriptRoot

Write-Host ""
Write-Host "* Obtaining OmniRig Installer"
Write-Host ""

# Get current OmniRig from DXAtlas

$appName="OmniRig.zip"
$appURL="http://dxatlas.com/OmniRig/Files/OmniRig.zip"
Write-Host -NoNewLine "  --> Downloading from $appURL... "
Write-Host ""
Invoke-RestMethod -Uri $appURL -Method Get -OutFile "$PSScriptRoot\$appName"
Write-Host "  --> Omnirig Archive Download Complete"

#Decompress
if (Test-Path("$PSScriptRoot\$appName")) {
	if (Test-Path("$PSScriptRoot\OmniRigSetup.exe")) { Remove-Item "$PSScriptRoot\OmniRigSetup.exe" } 
	Write-Host "  --> Old decompressed archive removed"
}

Write-Host "  --> Decompressing OmniRig Installer"

$appName="OmniRig.zip"
Expand-Archive -Path "$PSScriptRoot\$appName" -DestinationPath $PSScriptRoot

Write-Host "  --> Decompression Complete."
Write-Host ""

exit(0)