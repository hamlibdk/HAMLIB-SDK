#-----------------------------------------------------------------------------#
# Name .........: Download-GitCurrent.ps1
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
Write-Host "* Downloading Git Installer"

# Get current Git-SCM Version
Write-Host ""
$appName="latest-version.txt"
$appURL="https://gitforwindows.org/latest-version.txt"
Invoke-RestMethod -Uri $appURL -Method Get -OutFile $appName
$appName="latest-tag.txt"
$appURL="https://gitforwindows.org/latest-tag.txt"
Invoke-RestMethod -Uri $appURL -Method Get -OutFile $appName

$verContent = [IO.File]::ReadAllText("$PSScriptRoot\latest-version.txt")
Write-Host "  --> Determining latest Git-SCM version: $verContent "

$tagContent = [IO.File]::ReadAllText("$PSScriptRoot\latest-tag.txt")

# Actually get current Git-SCM Version
$appName="Git-" + $verContent + "-64-bit.exe"

# Intemediate to calculate the path
# Sample: https://gitforwindows.org/latest-version.txt  ---> 2.30.1
#         https://gitforwindows.org/latest-tag.txt --------> v2.30.1.windows.1
# Sample: https://github.com/git-for-windows/git/releases/download/v2.30.0.windows.2/Git-2.30.0.2-64-bit.exe
# Sample: https://github.com/git-for-windows/git/releases/download/v2.30.1.windows.1/Git-2.30.1-64-bit.exe

$appURL="https://github.com/git-for-windows/git/releases/download/" + $tagContent + "/" + $appName

Write-Host "  --> Path: $appURL"

Write-Host "  --> Downloading Git $verContent Installer"

$appCurrent="Git-Current-x64.exe"
Write-Host "  --> Saving as $appCurrent"
Invoke-RestMethod -Uri $appURL -Method Get -OutFile $appCurrent

Write-Host "  --> Git Download Complete."

exit(0)