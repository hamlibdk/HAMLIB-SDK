#-----------------------------------------------------------------------------#
# Name .........: Download-QtInstaller.ps1
# Project ......: Part of the JTSDK64 Tools Project
# Version ......: 3.2.0 Beta
# Description ..: Downloads the latest Qt Installer
# Usage ........: Call this file directly from the command line
#
# Concept ......: Greg, Beam, KI7MT, <ki7mt@yahoo.com>
# Author .......: Hamlib SDK Contributors <hamlibdk@hotmail.com>
# Copyright ....: Copyright (C) 2013-2021 Greg Beam, KI7MT
#               : (C) 2020-2021 Hamlib SDK Contributors
# License ......: GPL-3
#
#-----------------------------------------------------------------------------#

Set-Location -Path $PSScriptRoot

# Process variables

# dir$app = "curl"
$appName="qt-unified-windows-x86-online.exe"
$appURL="https://download.qt.io/official_releases/online_installers/qt-unified-windows-x86-online.exe"
$mirror="--mirror http://www.nic.funet.fi/pub/mirrors/download.qt-project.org"
#$param = "-o $appName -J -L $appURL $mirror"

Write-Host " "
Write-Host "* Downloading Qt Installer"
Write-Host " "
Write-Host "  --> Downloading the latest Qt Installer"
# Write-Host " Using Curl."

# DOS Command: curl -o %app_name% -J -L %app_url
# Using CURL Installation: Start-Process -FilePath $app -ArgumentList $param

Invoke-RestMethod -Uri $appURL -Method Get -OutFile $appName

Write-Host "  --> Qt Installer Download Complete"
Write-Host " "

exit(0)