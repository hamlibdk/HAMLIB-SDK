#-----------------------------------------------------------------------------#
# Name ..........: Deploy-Boost.ps1
# Project .......: Part of the JTSDK64 Tools Project
# Version .......: 3.4.0 
# Description ...: Downloads the latest Git Installer
# Usage .........: Call this file directly from the command line
#
# JTSDK Concept .: Greg, Beam, KI7MT, <ki7mt@yahoo.com>
# Author ........: Hamlib SDK Contributors <hamlibdk@hotmail.com>
# Copyright .....: Copyright (C) 2021 - 2022 Hamlib SDK Contributors
# License .......: GPL-3
#
#-----------------------------------------------------------------------------#

# ErrorDetected - Function to display Error Message and terminate App

function ErrorDetected() {
	 param(
        [Parameter(Mandatory=$true)][string]$fnctn,
        [Parameter(Mandatory=$false)][string]$msg1,
        [Parameter(Mandatory=$false)][string]$msg2
    )
	Write-Host "* ### ERROR DETECTED IN $fnctn ### " -ForegroundColor red;
	Write-Host ""
	if ($msg1) {
		Write-Host $msg1
		if ($msg2) {
			Write-Host $msg2;
		}
	} else {		
		Write-Host "  ==> Check Internet Connection"
	}
	Write-Host ""
	Write-Host "* Report persistent errors to JTSDK Forum (https:`/`/groups.io`/g`/JTSDK)"
	Write-Host ""
	exit(-1)
}

function DisplayHeading() {
	Clear-Host
	Write-Host "-----------------------------------------------"
	Write-Host "       JTSDK64 Boost Deployment $env:JTSDK64_VERSION" -ForegroundColor yellow;
	Write-Host "-----------------------------------------------"
	Write-Host ""
}

######################## MAIN EXECUTION BLOCK ########################

# Process variables from Versions.ini

$env:jtsdk64VersionConfig = "$env:JTSDK_CONFIG\Versions.ini"
Get-Content $env:jtsdk64VersionConfig | foreach-object -begin {$configTable=@{}} -process { $k = [regex]::split($_,'='); if(($k[0].CompareTo("") -ne 0) -and ($k[0].StartsWith("[") -ne $True)) { $configTable.Add($k[0], $k[1]) } }

# Backup original path

# $env:PATH_BKP = $env:PATH 

# Append needed MSYS2 MinGW directories to Path

# $env:PATH = $env:PATH + ";" + "C:\JTSDK64-Tools\tools\msys64\mingw64\bin; C:\JTSDK64-Tools\tools\msys64\mingw64\usr\local\bin; C:\JTSDK64-Tools\tools\msys64\mingw64\bin; C:\JTSDK64-Tools\tools\msys64\usr\bin" 

$scriptRoot = $PSScriptRoot				# Save execution location
Set-Location -Path $env:JTSDK_HOME		#Change to the JTSDK HOME Directory

DisplayHeading

# End if Unix Environment is not deployed

$varTableItem = $configTable.Get_Item("unixtools")

$varTest = "enabled"
if ($varTableItem -eq $varTest) {
	Write-Host "* MSYS2 Environment is available."
	Write-Host ""
	
	# Retrieve Boost Version

	$boostv = $configTable.Get_Item("boostv")

	$pathTest = $env:JTSDK_HOME + "\tools\boost\" + $env:boostv
	if (!(Test-Path $pathTest)) {
		Write-Host "* Requested Boost v$env:boostv not found. Deploying."
		Write-Host ""
		Invoke-Expression -Command $scriptRoot\Download-Boost.ps1
		if ($LASTEXITCODE -ne 0) { ErrorDetected -fnctn "Download" }
		Invoke-Expression -Command $scriptRoot\Compile-Boost.ps1
		if ($LASTEXITCODE -ne 0) { ErrorDetected -fnctn "Build" }	
	} else {
		Write-Host "* Requested Boost v$env:boostv already deployed."
	}	
} else {
	ErrorDetected -fnctn "IN Versions.ini" -msg1 "  ==> Set unixtools=enabled in Versions.ini"
	
	#Write-Host "  ==> Close all JTSDK64-Tools windows to set variable on restart."
}	
Write-Host ""

# Restore original path

# $env:PATH = $env:PATH_BKP
# $env:PATH_BKP = ""

exit(0)