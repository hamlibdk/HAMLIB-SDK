#-----------------------------------------------------------------------------------#
# Name .........: Compile-Boost.ps1
# Project ......: Part of the JTSDK64 Tools Project
# Version ......: 4.0.0
# Description ..: Compiles selected Boost deployment specified in Versions.ini
# Usage ........: Call this file directly from the command line
#
# Concept ......: Greg, Beam, KI7MT, <ki7mt@yahoo.com>
# Author .......: Hamlib SDK Contributors <hamlibdk@hotmail.com>
# Copyright ....: Copyright (C) 2021 - 2024 Hamlib SDK Contributors
# License ......: GPL-3
#
# Base Ref......: https://gist.github.com/zrsmithson/0b72e0cb58d0cb946fc48b5c88511da8
#
# Deveopment....: Version 3.2.3.3 Corrects using GITHUB static release site and different package nomenclature for source - Steve I 2024-01-08
#                 Slight script cleanups  - Steve I 2024-01-08
#                 As of Version 3.2.4 using GIT source for Boost - Steve I 2024-01-08
#                 Version 4.0 (beta) - Reverting back to JFrog and JFrog notation Steve I VK3VM 2024-04-22
#                 Version 3.4.1 (beta) - Reverting back to 3.4.1-stream; minor enhancement so that /include dir is checked to see if endpoint exists Steve I VK3VM 2024-09-19
#                 Version 4.0.0 - Adjustments to support builds on versions > 1.85.0 coordinated by Steve I VK3VM 2025-04-03
#
#-----------------------------------------------------------------------------------#

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

# Clear-Host
Write-Host " "
Write-Host "* Compiling Boost"
Write-Host " "

# Process variables from Versions.ini into hash Table $configTable

$env:jtsdkVConf = "$env:JTSDK_CONFIG\Versions.ini"
Get-Content $env:jtsdkVConf | foreach-object -begin {$configTable=@{}} -process { $k = [regex]::split($_,'='); if(($k[0].CompareTo("") -ne 0) -and ($k[0].StartsWith("[") -ne $True)) { $configTable.Add($k[0], $k[1]) } }

# Retrieve Boost Version

$boostv = $configTable.Get_Item("boostv")
$boostv_u = $boostv.replace(".","_") 			# Comment if using GITHUB Nomenclature - that uses - and .
Write-Host "  --> Boost version to be compiled: $boostv"
Write-Host ""

# ##### ##### ##### Do not compile if source already exists ##### ##### #####  

if (!(Test-Path("$env:JTSDK_TOOLS\boost\$boostv\include"))) {
	Write-Host -ForegroundColor Yellow "  --> Requested Boost Library `[$boostv`] Not Found`: Starting to Compile Source."
	Write-Host " "
	# Final Distribution Directory

	$boostDir = "$env:JTSDK_Tools\boost\$boostv"

	# Compilation
	# Ref: https://gist.github.com/zrsmithson/0b72e0cb58d0cb946fc48b5c88511da8 

	# ############################################################################################
	# Create Required Directories
	# ############################################################################################
	
	Write-Host -NoNewLine "  --> Creating Source Directories: "

	if (!(Test-Path("$env:JTSDK_SRC\boost_$boostv_u"))) {				# Use if JFrog
	#if (!(Test-Path("$env:JTSDK_SRC\boost-$boostv"))) {				# Use if GIT
		New-Item -Force -Path "$env:JTSDK_SRC\boost_$boostv_u" -ItemType Directory | Out-Null  	# If JFrog
		#New-Item -Force -Path "$env:JTSDK_SRC\boost-$boostv" -ItemType Directory | Out-Null  	# If GIT
		Write-Host "$env:JTSDK_SRC\boost_$boostv_u"
	}
	
	Write-Host -NoNewLine "  --> Creating  Library Directories: "	

	New-Item -Force -Path "$env:JTSDK_TOOLS\boost\$boostv" -ItemType Directory | Out-Null		# If GIT
	Write-Host "$env:JTSDK_TOOLS\boost\$boostv"
	Write-Host ""

	# ############################################################################################
	# Boost.Build setup
	# ############################################################################################

	Set-Location -Path "$env:JTSDK_SRC\boost_$boostv_u\tools\build"		# For JFrog
	# Set-Location -Path "$env:JTSDK_SRC\boost-$boostv\tools\build"		# For GitHub

	Write-Host "* Commencing Boost.Build Setup"
	Write-Host ""
	# prepare b2
	# bootstrap.bat mingw
	$cmds = ".\bootstrap.bat"
	$args = "gcc"	# formerly mingw
	Start-Process -NoNewWindow -wait $cmds $args

	Write-Host ""
	Write-Host "  --> `'bootstrap.bat gcc`' Complete."

	# Build boost.build with b2

	$cmds = ".\b2"
	######################################
	# Fixes here for GITHUB commented out#
	######################################
	
	$args = "--prefix='$env:JTSDK_TMP\boost_$boostv_u\boost-build' toolset=gcc"
	# $args = "--prefix='$env:JTSDK_TMP\boost-$boostv\boost-build' toolset=gcc"
	Start-Process -NoNewWindow -wait $cmds $args

	Write-Host "  --> b2 install --prefix=`"$env:JTSDK_TMP\boost_$boostv_u\boost-build`" Complete."
	# Write-Host "  --> b2 install --prefix=`"$env:JTSDK_TMP\boost-$boostv\boost-build`" Complete."

	$env:PATH=$env:PATH + ";" + "$env:JTSDK_TMP\boost_$boostv_u\boost-build\bin" + ";" + "$env:JTSDK_SRC\boost_$boostv_u\tools\build\src\engine"
	# $env:PATH=$env:PATH + ";" + "$env:JTSDK_TMP\boost-$boostv\boost-build\bin" + ";" + "$env:JTSDK_SRC\boost-$boostv\tools\build\src\engine"

	Write-Host "  --> Added `"$env:JTSDK_SRC\boost_$boostv_u\tools\build\src\engine`" to system path."
	# Write-Host "  --> Added `"$env:JTSDK_SRC\boost-$boostv\tools\build\src\engine`" to system path."


	# ############################################################################################
	# Building Boost
	# ############################################################################################
	Write-Host ""
	Write-Host "* Build Boost"

	Set-Location -Path "$env:JTSDK_SRC\boost_$boostv_u"			# For JFrog
	# Set-Location -Path "$env:JTSDK_SRC\boost-$boostv"			# For GitHub
	Write-Host "  --> Commencing actual build"

	$cmds = "b2"
	# For JFrog
	# $args = "--build-dir=`"$env:JTSDK_SRC\boost_$boostv_u\build`" --build-type=complete --prefix=`"$env:JTSDK_TOOLS\boost\$boostv`" toolset=gcc install"
	# To support versions > 1.85.0
	$args = "--build-dir=`"$env:JTSDK_SRC\boost_$boostv_u\build`" --build-type=complete --prefix=`"$env:JTSDK_TOOLS\boost\$boostv`" toolset=gcc link=static,shared address-model=64 install"

	# For GitHub
	# $args = "--build-dir=`"$env:JTSDK_SRC\boost-$boostv\build`" --build-type=complete --prefix=`"$env:JTSDK_TOOLS\boost\$boostv`" toolset=gcc install"
	Start-Process -NoNewWindow -wait $cmds $args

	Write-Host -ForegroundColor Yellow "  --> Build Complete."
} else {
	
	Write-Host -ForegroundColor Yellow "  --> Source already Compiled"
	Write-Host "  --> To refresh: Delete source directory in $env:JTSDK_TOOLS\boost\$boostv and re-run `'Compile-Boost.ps1`'"
}
# Complete

Write-Host "  --> Distribution in $env:JTSDK_TOOLS\boost\$boostv"
Write-Host " "

exit(0)