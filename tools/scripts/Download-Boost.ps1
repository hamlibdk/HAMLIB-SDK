#-----------------------------------------------------------------------------#
# Name .........: Download-Boost.ps1
# Project ......: Part of the JTSDK64 Tools Project
# Version ......: 3.2.0 Beta
# Description ..: Downloads the latest Git Installer
# Usage ........: Call this file directly from the command line
#
# Concept ......: Greg, Beam, KI7MT, <ki7mt@yahoo.com>
# Author .......: Hamlib SDK Contributors <hamlibdk@hotmail.com>
# Copyright ....: Copyright (C) 2021 Hamlib SDK Contributors
# License ......: GPL-3
#
#-----------------------------------------------------------------------------#

Set-Location -Path $env:JTSDK_HOME

# These are here temporary for Development purposes only
#
# Set-Location -Path $PSScriptRoot
#
#$env:JTSDK_HOME = "C:\JTSDK64-Tools"
#$env:JTSDK_CONFIG = $env:JTSDK_HOME + "\config"
#$env:JTSDK_DATA= $env:JTSDK_HOME + "\data"
#$env:JTSDK_SRC = $env:JTSDK_HOME + "\src"
#$env:JTSDK_TMP = $env:JTSDK_HOME + "\tmp"
#$env:JTSDK_TOOLS = $env:JTSDK_HOME + "\tools"
#$env:JTSDK_SCRIPTS = $env:JTSDK_TOOLS + "\scripts"

# Describe Action

Clear-Host
Write-Host " "
Write-Host "* Setting Up Boost"
Write-Host " "

# Process variables from Versions.ini

$env:jtsdk64VersionConfig = "$env:JTSDK_CONFIG\Versions.ini"
Get-Content $env:jtsdk64VersionConfig | foreach-object -begin {$configTable=@{}} -process { $k = [regex]::split($_,'='); if(($k[0].CompareTo("") -ne 0) -and ($k[0].StartsWith("[") -ne $True)) { $configTable.Add($k[0], $k[1]) } }
Write-Host "  --> Version requested found in: $env:jtsdk64VersionConfig"

# Retrieve Boost Version

$boostv = $configTable.Get_Item("boostv")

$dlFile = "boost_$boostv.zip"

# Place into file format for Boost distribution

$dlFile = $dlFile.replace(".","_")
$dlFile = $dlfile.replace("_zip",".zip")

# Boost Distribution URL

$dlPath = "https://dl.bintray.com/boostorg/release/$boostv/source/$dlFile"

Write-Host "  --> Full Path: $dlFile"

# Download

Write-Host "  --> Downloading ... Please wait ..."
Invoke-WebRequest $dlPath -OutFile "$env:JTSDK_SRC\$dlFile"
Write-Host "  --> Download Complete"

# Decompression

Write-Host "  --> Decompressing to: $env:JTSDK_SRC Note: This will be slow."
Expand-Archive "$env:JTSDK_SRC\$dlFile" -DestinationPath $env:JTSDK_SRC -Force
$dLoc = $dlFile.Replace(".zip","")
Write-Host "  --> Decompression complete." 
Write-Host "  --> Source in $env:JTSDK_SRC\$dLoc"
Write-Host " "

exit(0)