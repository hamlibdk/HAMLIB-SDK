#-----------------------------------------------------------------------------#
# Name .........: Deploy-Boost.ps1
# Project ......: Part of the JTSDK64 Tools Project
# Version ......: 3.2.2
# Description ..: Downloads the latest Git Installer
# Usage ........: Call this file directly from the command line
#
# Concept ......: Greg, Beam, KI7MT, <ki7mt@yahoo.com>
# Author .......: Hamlib SDK Contributors <hamlibdk@hotmail.com>
# Copyright ....: Copyright (C) 2021 - 2022 Hamlib SDK Contributors
# License ......: GPL-3
#
#-----------------------------------------------------------------------------#

function ErrorDetected($fnctn) {
	Write-Host ""
	Write-Host "*** *** ERROR DETECTED IN $fnctn *** ***"
	Write-Host ""
	Write-Host "* Check Internet Connection"
	Write-Host "* Report errors to JTSDK Forum (https:`/`/groups.io`/g`/JTSDK)"
	exit(-1)
}

$scriptRoot = $PSScriptRoot				# Save execution location
Set-Location -Path $env:JTSDK_HOME		#Chnage to the JTSDK HOME Directory

Clear-Host
Write-Host "-----------------------------------------------"
Write-Host "       JTSDK64 Boost Deployment $env:JTSDK64_VERSION"
Write-Host "-----------------------------------------------"
Write-Host ""

# Process variables from Versions.ini

$env:jtsdk64VersionConfig = "$env:JTSDK_CONFIG\Versions.ini"
Get-Content $env:jtsdk64VersionConfig | foreach-object -begin {$configTable=@{}} -process { $k = [regex]::split($_,'='); if(($k[0].CompareTo("") -ne 0) -and ($k[0].StartsWith("[") -ne $True)) { $configTable.Add($k[0], $k[1]) } }
# Write-Host "  --> Version requested found in: $env:jtsdk64VersionConfig"
# Write-Host ""

# Retrieve Boost Version

$boostv = $configTable.Get_Item("boostv")

$pathTest = $env:JTSDK_HOME + "\tools\boost\" + $env:boostv
if (!(Test-Path $pathTest)) {
	Write-Host "* Requested Boost v$env:boostv not found. Deploying."
	Write-Host ""
	Invoke-Expression -Command $scriptRoot\Download-Boost.ps1
	if ($LASTEXITCODE -ne 0) { ErrorDetected("Download") }
	Invoke-Expression -Command $scriptRoot\Compile-Boost.ps1
	if ($LASTEXITCODE -ne 0) { ErrorDetected("Build") };	
} else {
	Write-Host "* Requested Boost v$env:boostv already deployed."
}	

Write-Host ""

exit(0)