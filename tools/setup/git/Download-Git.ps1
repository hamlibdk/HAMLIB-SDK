#-----------------------------------------------------------------------------#
# Name .........: Download-Git.ps1
# Project ......: Part of the JTSDK64 Tools Project
# Version ......: 3.2.0 Beta
# Description ..: Downloads the latest Git Installer
# Usage ........: Call this file directly from the command line
#
# Concept ......: Greg, Beam, KI7MT, <ki7mt@yahoo.com>
# Author .......: Hamlib SDK Contributors <hamlibdk@hotmail.com>
# Copyright ....: Copyright (C) 2013-2019 Greg Beam, KI7MT
#               : (C) 2020 Hamlib SDK Contributors
# License ......: GPL-3
#
#-----------------------------------------------------------------------------#

Set-Location -Path $PSScriptRoot

# Process variables

# dir$app = "git"
$appName="Git-2.29.2.3-64-bit.exe"
$appURL="https://github.com/git-for-windows/git/releases/download/v2.29.2.windows.3/Git-2.29.2.3-64-bit.exe"
#$param = "-o $appName -J -L $appURL"

Write-Host " "
Write-Host "* Downloading Git Installer"
Write-Host " "
Write-Host "  --> Downloading Git 2.29.2.3 Installer"
# Write-Host " Using Curl."


# DOS Command: curl -o %app_name% -J -L %app_url
# Using CURL Installation: Start-Process -FilePath $app -ArgumentList $param

Invoke-RestMethod -Uri $appURL -Method Get -OutFile $appName

Write-Host "  --> Git Download Complete"

exit(0)