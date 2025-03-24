#-----------------------------------------------------------------------------#
# Name .........: Download-QtInstaller.ps1
# Project ......: Part of the JTSDK64 Tools Project
# Version ......: 4.0.1
# Description ..: Downloads the latest Qt Installer
# Usage ........: Call this file directly from the command line
#
# Concept ......: Greg, Beam, KI7MT, <ki7mt@yahoo.com>
# Author .......: Hamlib SDK Contributors <hamlibdk@hotmail.com>
# Copyright ....: Copyright (C) 2013-2019 Greg Beam, KI7MT
#               : (C) 2020 - 2022 Hamlib SDK Contributors
# License ......: GPL-3
#
#-----------------------------------------------------------------------------#

Set-Location -Path $PSScriptRoot

# Process variables

Get-Content $env:JTSDK_VC | foreach-object -begin {$configTable=@{}} -process { $k = [regex]::split($_,'='); if(($k[0].CompareTo("") -ne 0) -and ($k[0].StartsWith("[") -ne $True)) { $configTable.Add($k[0], $k[1]) } }
$QT_INSTPROG = $configTable.Get_Item("qtinstprog")
$QT_SOURCE = $configTable.Get_Item("qtsource")

# $appURL="https://download.qt.io/official_releases/online_installers/qt-unified-windows-x64-online.exe"

$appURL="$QT_SOURCE/$QT_INSTPROG"

#$param = "-o $appName -J -L $appURL"

#Write-Host " "
Write-Host "* Downloading Qt Installer"
Write-Host " "
# Write-Host "  --> Downloading the latest Qt Installer"
Write-Host "  --> URL: $appURL"

Invoke-RestMethod -Uri $appURL -Method Get -OutFile $QT_INSTPROG

Write-Host "  --> Qt Installer Download Complete"
Write-Host " "

exit(0)