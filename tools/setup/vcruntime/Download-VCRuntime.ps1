#-----------------------------------------------------------------------------#
# Name .........: Download-VCRuntime.ps1
# Project ......: Part of the JTSDK64 Tools Project
# Version ......: 3.2.0 Beta
# Description ..: Downloads the latest VC/C++ Installer
# Usage ........: Call this file directly from the command line
#
# Concept ......: Greg, Beam, KI7MT, <ki7mt@yahoo.com>
# Author .......: Hamlib SDK Contributors <hamlibdk@outlook.com>
# Copyright ....: Copyright (C) 2013-2019 Greg Beam, KI7MT
#               : (C) 2020 Hamlib SDK Contributors
# License ......: GPL-3
#
# Release Candidate 25-02-2021 by Steve VK3SIR/VK3VM
#
#-----------------------------------------------------------------------------#

# Ref: https://support.microsoft.com/en-us/topic/the-latest-supported-visual-c-downloads-2647da03-1eea-4433-9aff-95f26a218cc0

Set-Location -Path $PSScriptRoot

Write-Host " "
Write-Host "* Downloading VC/C++ Installer"
Write-Host " "

# Process variables for x86

$appURL= "https://aka.ms/vs/16/release/vc_redist.x86.exe"

$appName="vc_redist.x86.exe"
$param = "-o $appName -J -L $appURL"

Write-Host -NoNewline "  --> Downloading the latest VC/C++ x86 Installer: "

Invoke-RestMethod -Uri $appURL -Method Get -OutFile $appName

Write-Host "Complete"

# Process variables for x64

$appURL= "https://aka.ms/vs/16/release/vc_redist.x64.exe"

$appName="vc_redist.x64.exe"
$param = "-o $appName -J -L $appURL"

Write-Host -NoNewline "  --> Downloading the latest VC/C++ x64 Installer: "

Invoke-RestMethod -Uri $appURL -Method Get -OutFile $appName

Write-Host "Complete"

Write-Host " "

exit(0)