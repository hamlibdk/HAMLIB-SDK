#-----------------------------------------------------------------------------#
# Name .........: Generate-Versions.ps1
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
# This script generates the Versions.cmake file in C:\JTSDK64-Tools\tmp\wsjtx
# that has been deprecated from WSJTX 2.3.0 rc2 source onwards.
#
# Author: Steve VK3SIR 19/01/2020
#
#-----------------------------------------------------------------------------#

#$env:JTSDK_TMP

# GENERATOR ERROR ------------------------------------------------------------

function GenerateError($type) {
	Write-Host "*** Error: $type ***"
	Write-Host "*** Report error to JTSDK@Groups.io *** "
	Write-Host ""
	exit(-1)
}

# MAIN LOGIC FLOW ------------------------------------------------------------

Write-Host ""
Write-Host "* Generating Versions.cmake from CMakeLists.txt"
Write-Host ""

$mlConfig = Get-Content $env:JTSDK_TMP\wsjtx\CMakeLists.txt
[Int]$wVMa = 0
[Int]$wVMi = 0
[Int]$wVPa = 0
[Int]$wVRel = 0
[Int]$wRcv = 0

[Int]$count = 0
foreach ($line in $mlConfig) {
	if (($line.trim() |  Select-String -Pattern "\d{1,3}(\.\d{1,3}){3}" -AllMatches).Matches.Value) {
		$temp = ($line  |  Select-String -Pattern "\d{1,3}(\.\d{1,3}){3}" -AllMatches).Matches.Value
		Write-Host -NoNewLine "  --> Version data: $temp "
		$verArr = @($temp.split('.'))
		$wVMa = $verArr[0]
		$wVMi = $verArr[1]
		$wVPa = $verArr[2]
		$wVRel = $verArr[3]
	}
	if ($line -like 'set_build_type*') {
		$wRcv = ($line) -replace "[^0-9]" , ''
		Write-Host "rc $wRcv"
		$count++
	}
}

if ($count -eq 0) { Write-Host "" }

try { 
	if ($verArr[0] -eq 0) { GenerateError("Data not read from CMakeLists.txt" ) } 
}
catch { 
	GenerateError("Unable to read data from CMakeList.txt") 
}

$of = "$env:JTSDK_TMP\wsjtx\Versions.cmake"

try {
	New-Item -Force $of > $null
	Add-Content $of  "`# Version number components"
	Add-Content $of  "set (WSJTX_VERSION_MAJOR $wVMa)"
	Add-Content $of  "set (WSJTX_VERSION_MINOR $wVMi)"
	Add-Content $of  "set (WSJTX_VERSION_PATCH $wVPa)"
	Add-Content $of  "set (WSJTX_RC $wRcv)"
	Add-Content $of  "set (WSJTX_VERSION_IS_RELEASE $wVRel)"
}
catch { 
	GenerateError("Unable to create Versions.cmake") 
} 

# Check to see that file created
if (Test-Path $pathTest) {
    Write-Host "  --> Validation: found $of"
    Write-Host " "
} else {
    GenerateError("Versions.cmake not created")
}

exit(0)