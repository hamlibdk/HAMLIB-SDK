#-----------------------------------------------------------------------------#
# Name .........: Download-VSCode.ps1
# Project ......: Part of the JTSDK64 Tools Project
# Version ......: 3.2.0 Beta
# Description ..: Downloads the latest VS Code Installer
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

# dir$app = "curl"
$appName="VSCodeUserSetup-x64.exe"
$appURL="https://aka.ms/win32-x64-user-stable"
$param = "-o $appName -J -L $appURL"

Write-Host " "
Write-Host "* Downloading VS Code Installer"
Write-Host " "
Write-Host "  --> Downloading the latest VS Code Installer"
# Write-Host " Using Curl."


# DOS Command: curl -o %app_name% -J -L %app_url
# Using CURL Installation: Start-Process -FilePath $app -ArgumentList $param

Invoke-RestMethod -Uri $appURL -Method Get -OutFile $appName

Write-Host "  --> VS Code Download Complete"
Write-Host " "

exit(0)