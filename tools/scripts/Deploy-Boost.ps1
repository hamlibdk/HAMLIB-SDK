#-----------------------------------------------------------------------------#
# Name .........: Deploy-Boost.ps1
# Project ......: Part of the JTSDK64 Tools Project
# Version ......: 3.4.1 Beta
# Description ..: Downloads the latest Git Installer
# Usage ........: Call this file directly from the command line
#
# Concept ......: Greg, Beam, KI7MT, <ki7mt@yahoo.com>
# Author .......: Hamlib SDK Contributors <hamlibdk@hotmail.com>
# Copyright ....: Copyright (C) 2021 - 2024 Hamlib SDK Contributors
# License ......: GPL-3
#
# Version 3.2.3.3 Corrects using GITHUB static release site and different package nomenclature for source - Steve I 2024-01-08
#
# Development Note: As of Version 3.2.4 using GIT source for Boost - Steve I 2024-01-08
# Clean-up some messy items and fix path issue - Steve I 2024-09-19
#
#-----------------------------------------------------------------------------#

# --- CleanExit - Restore Backed-Up Path and exit cleanly --------------------
function CleanExit {
		
	$env:PATH = $env:PATH_BKP
	Remove-Item env:PATH_BKP
	exit(-1)
}

# --- ErrorDetected - Handle errors setected cleanly ------------------------
function ErrorDetected($fnctn) {
	Write-Host ""
	Write-Host -ForegroundColor Red "*** *** ERROR DETECTED IN $fnctn *** ***"
	Write-Host ""
	Write-Host "* Check Internet Connection"
	Write-Host "* Report errors to JTSDK Forum (https:`/`/groups.io`/g`/JTSDK)"
	CleanExit
}

# ----------------------------------------------------------------------------
# Main Logic
# ----------------------------------------------------------------------------

Clear-Host
# Commence backup of original Path
if ( -Not ( Test-Path env:PATH_BKP ) ) { $env:PATH_BKP = $env:PATH }
# $env:PATH = $env:PATH +";" + $env:QT_JTSDK_PATH

# Make the path of the MSYS2 environment available for use by the Boost Compiler
$env:PATH = $env:PATH + ";" + $pwd.drive.name + ":\JTSDK64-Tools\tools\msys64\mingw64\bin;" + $pwd.drive.name + ":\JTSDK64-Tools\tools\msys64\mingw64\usr\local\bin;" + $pwd.drive.name + ":\JTSDK64-Tools\tools\msys64\mingw64\bin;" + $pwd.drive.name + ":\JTSDK64-Tools\tools\msys64\usr\bin" 

# Fudge: In response to https://groups.io/g/JTSDK/message/2773 
# Note that this is ALREADY there ... It just moves it "higher up the foodchain" 
# to prevent other compilers being detected and used first (i.e Visual Studio Compilers !

$env:Path = $env:SystemDrive + "\JTSDK64-Tools\tools\Qt\Tools\" + $env:GCC_MINGW + "\bin;" + $env:Path

$scriptRoot = $PSScriptRoot				# Save execution location
Set-Location -Path $env:JTSDK_HOME		#Change to the JTSDK HOME Directory


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

#$pathTest = $env:JTSDK_HOME + "\tools\boost\" + $env:boostv
$pathTest = $env:JTSDK_HOME + "\tools\boost\$env:boostv\include"
if (!(Test-Path $pathTest)) {
	Write-Host "* Requested Boost v$env:boostv not found. Deploying."
	Write-Host ""
	Invoke-Expression -Command $scriptRoot\Download-Boost.ps1
	if ($LASTEXITCODE -ne 0) { ErrorDetected("Download") }
	Invoke-Expression -Command $scriptRoot\Compile-Boost.ps1
	if ($LASTEXITCODE -ne 0) { ErrorDetected("Build") };	
} else {
	Write-Host -ForegroundColor Yellow "* Configured version of Boost in Versions.ini [v$env:boostv] already deployed."
}	

Write-Host ""

CleanExit
exit(0)