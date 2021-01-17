#-----------------------------------------------------------------------------#
# Name .........: Download-GitCurrent.ps1
# Project ......: Part of the JTSDK64 Tools Project
# Version ......: 3.2.0 Beta
# Description ..: Downloads the latest Git Installer
# Usage ........: Call this file directly from the command line
#
# Concept ......: Greg, Beam, KI7MT, <ki7mt@yahoo.com>
# Author .......: Hamlib SDK Contributors <hamlibdk@hotmail.com>
# Copyright ....: Copyright (C) 2013-2021 Greg Beam, KI7MT
#               : (C) 2020 - 2021 Hamlib SDK Contributors
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

$content = [IO.File]::ReadAllText("$PSScriptRoot\latest-version.txt")
Write-Host "  --> Determining latest Git-SCM version: $content "

# Array seperating version details 
$verArr = @($content.split('.'))

# Actually get current Git-SCM Version
$appName="Git-" + $content + "-64-bit.exe"

# Intemediate to calculate the path
# Sample: https://github.com/git-for-windows/git/releases/download/v2.30.0.windows.2/Git-2.30.0.2-64-bit.exe

$calcPath="v" + $verArr[0] + "." + $verArr[1] + "." + $verArr[2] + ".windows." + $verArr[3]
$appURL="https://github.com/git-for-windows/git/releases/download/" + $calcPath + "/" + $appName

Write-Host "  --> Path: $appURL"

Write-Host "  --> Downloading Git $content Installer"

$appCurrent="Git-Current-x64.exe"
Write-Host "  --> Saving as $appCurrent"
Invoke-RestMethod -Uri $appURL -Method Get -OutFile $appCurrent

Write-Host "  --> Git Download Complete."

exit(0)