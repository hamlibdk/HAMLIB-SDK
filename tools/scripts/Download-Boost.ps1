#-----------------------------------------------------------------------------#
# Name .........: Download-Boost.ps1
# Project ......: Part of the JTSDK64 Tools Project
# Version ......: 3.2.0 Beta
# Description ..: Downloads selected Boost deployment specified in Versions.ini
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
Write-Host "* Download Boost"
Write-Host " "

# Get hash table of configuration variables from Versions.ini

$env:jtsdk64VersionConfig = "$env:JTSDK_CONFIG\Versions.ini"
Get-Content $env:jtsdk64VersionConfig | foreach-object -begin {$configTable=@{}} -process { $k = [regex]::split($_,'='); if(($k[0].CompareTo("") -ne 0) -and ($k[0].StartsWith("[") -ne $True)) { $configTable.Add($k[0], $k[1]) } }

# Retrieve Boost Version

$boostv = $configTable.Get_Item("boostv")

# Place into file format for Boost distribution
# Note: Multi stage here - can be simplified.

$dlFile = "boost_$boostv.zip"
$dlFile = $dlFile.replace(".","_")
$dlFile = $dlfile.replace("_zip",".zip")	# Formatted as the filename found on the Web
$dLoc = $dlFile.Replace(".zip","")			# Remove the .zip extenstion [ For decompression ]

# Boost Distribution URL

$dlPath = "https://dl.bintray.com/boostorg/release/$boostv/source/$dlFile"

Write-Host "  --> Requested Source: $dlPath"

# Download

if (!(Test-Path("$env:JTSDK_SRC\$dlFile"))) {
	Write-Host "  --> Downloading $env:JTSDK_SRC\$dlFile" 
	Write-Host "      `[Note: this will be *** slow ***`]"
	try { Invoke-WebRequest $dlPath -OutFile "$env:JTSDK_SRC\$dlFile" } catch { exit(1) }
	Write-Host "  --> Download Complete"
} else {
	Write-Host "  --> Souce already downloaded"
	Write-Host "  --> File: $env:JTSDK_SRC\$dlFile"
	Write-Host "  --> To refresh: Delete $env:JTSDK_SRC\$dlFile and re-run `'Download-Boost.ps1`'"
}

Write-Host ""

# Decompression

if (!(Test-Path("$env:JTSDK_SRC\$dLoc"))){
	Write-Host "  --> Decompressing to: $env:JTSDK_SRC"
	Write-Host "      `[Note: This will be *** very slow ***`]"
	try { Expand-Archive "$env:JTSDK_SRC\$dlFile" -DestinationPath $env:JTSDK_SRC -Force } catch { exit(2) }
		Write-Host "  --> Decompression complete." 
} else {	
	Write-Host "  --> Source already decompressed"
	Write-Host "  --> To refresh: Delete source directory in $env:JTSDK_SRC and re-run `'Download-Boost.ps1`'"
}

Write-Host "  --> Source in $env:JTSDK_SRC\$dLoc"	
Write-Host " "

exit(0)