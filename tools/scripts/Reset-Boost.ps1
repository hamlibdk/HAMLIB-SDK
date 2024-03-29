#-----------------------------------------------------------------------------#
# Name .........: Reset-Boost.ps1
# Project ......: Part of the JTSDK64 Tools Project
# Version ......: 3.2.3.3
# Description ..: Downloads the latest Git Installer
# Usage ........: Call this file directly from the command line
#
# Concept ......: Greg, Beam, KI7MT, <ki7mt@yahoo.com>
# Author .......: Hamlib SDK Contributors <hamlibdk@hotmail.com>
# Copyright ....: Copyright (C) 2021 - 2024 Hamlib SDK Contributors
# License ......: GPL-3
#
# Version 3.2.3.3 Corrects using GITHUB static release site and different package nomenclature for source - Steve I 2024-01-08
#                 Slight script cleanups  - Steve I 2024-01-08
#
# Development Note: As of Version 3.2.4 using GIT source for Boost - Steve I 2024-01-08
#
#-----------------------------------------------------------------------------#

function ErrorDetected($fnctn) {
	Write-Host ""
	Write-Host -ForegroundColor Red "*** *** ERROR DETECTED IN $fnctn *** ***"
	Write-Host ""
	Write-Host "* Check Internet Connection"
	Write-Host "* Report errors to JTSDK Forum (https:`/`/groups.io`/g`/JTSDK)"
	exit(-1)
}

$scriptRoot = $PSScriptRoot				# Save execution location
Set-Location -Path $env:JTSDK_HOME		# Change to the JTSDK HOME Directory

Clear-Host
Write-Host "-----------------------------------------------"
Write-Host "    JTSDK64 Reset Boost Deployment $env:JTSDK64_VERSION"
Write-Host "-----------------------------------------------"
Write-Host ""

# Process variables from Versions.ini

$env:jtsdk64VersionConfig = "$env:JTSDK_CONFIG\Versions.ini"
Get-Content $env:jtsdk64VersionConfig | foreach-object -begin {$configTable=@{}} -process { $k = [regex]::split($_,'='); if(($k[0].CompareTo("") -ne 0) -and ($k[0].StartsWith("[") -ne $True)) { $configTable.Add($k[0], $k[1]) } }
Write-Host "  --> Version requested found in: $env:jtsdk64VersionConfig"
# Write-Host ""

# Retrieve Boost Version

$boostv = $configTable.Get_Item("boostv")
# $boostv_u = $boostv.replace(".","_") # Not needed when downloading package from GITHUB

# Process the Boost Download Directory - Nominally C:\JTSDK64-Tools\src

#exensive fixes from here on for GITHUB

# $pathTest = $env:JTSDK_HOME + "\src\boost_" + $boostv_u
$pathTest = $env:JTSDK_HOME + "\src\boost-" + $boostv
Write-Host "  --> Path: $pathTest"

Remove-Item $env:JTSDK_HOME\src\* -include *.zip
Write-Host "  --> Downloaded .zip packages removed (if exist)."
Write-Host ""

if (!(Test-Path $pathTest)) {	
	Write-Host "* Requested Boost v$env:boostv download directory not found."	
} else {
	Write-Host -NoNewline "* Deleting download directory/ies: $pathTest (please wait) ... "	
	Remove-Item $pathTest -force -recurse
	Write-Host "Done."
}	

# All this is now redudnant as build process take place in Nominally C:\JTSDK64-Tools\src
# Process the Boost Build Directory - Nominally C:\JTSDK64-Tools\tmp

#$pathTest = $env:JTSDK_HOME + "\tmp\boost" + $env:boostv_u
#if (!(Test-Path $pathTest)) {
#	Write-Host "* Requested Boost v$env:boostv build directory not found."	
#} else {
#	Write-Host -NoNewline "* Deleting build directory/ies: $pathTest  (please wait) ... "	
#	Remove-Item $pathTest -force -recurse
#	Write-Host "Done."
#}	

# Process the Boost Deployment Directory

$pathTest = $env:JTSDK_HOME + "\tools\boost\" + $env:boostv
if (!(Test-Path $pathTest)) {
	Write-Host "* Requested Boost v$env:boostv deployment directory not found."	
} else {
	Write-Host -NoNewline "* Deleting deployment directories: $pathTest (please wait) ... "	
	Remove-Item $pathTest -force -recurse
	Write-Host  -ForegroundColor Yellow "Done."
}	

Write-Host ""
Write-Host -ForgroundColor Yellow "* Boost v$env:boostv Construction and Deployment environment reset."
Write-Host ""
Write-Host -ForgroundColor Red "*** *** PLEASE CLOSE AND THEN REPOPEN ALL POWERSHELL AND MSYS2 ENVIRONMENTS *** ***"

Write-Host ""

exit(0)