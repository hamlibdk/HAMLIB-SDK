#-----------------------------------------------------------------------------#
# Name .........: Compile-Boost.ps1
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
# Base Ref......: https://gist.github.com/sim642/29caef3cc8afaa273ce6#
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

# Clear-Host
Write-Host " "
Write-Host "* Compiling Boost"
Write-Host " "

# Process variables from Versions.ini into hash Table $configTable

$env:jtsdk64VersionConfig = "$env:JTSDK_CONFIG\Versions.ini"
Get-Content $env:jtsdk64VersionConfig | foreach-object -begin {$configTable=@{}} -process { $k = [regex]::split($_,'='); if(($k[0].CompareTo("") -ne 0) -and ($k[0].StartsWith("[") -ne $True)) { $configTable.Add($k[0], $k[1]) } }

# Retrieve Boost Version

$boostv = $configTable.Get_Item("boostv")
$boostvReplUnd=$dlFile = $boostv.replace(".","_")
Write-Host "  --> Boost version to be compiled: $boostv"

# Final Distribution Directory

$boostDir = "$env:JTSDK_Tools\boost\$boostv"

# Compilation
# Ref: https://gist.github.com/zrsmithson/0b72e0cb58d0cb946fc48b5c88511da8
# Ref: https://gist.github.com/sim642/29caef3cc8afaa273ce6# 

# ############################################################################################
# Create Required Directories
# ############################################################################################
Write-Host "  --> Creating Required Directories"

# mkdir C:\JTSDK64-Tools\src\boost_1_74_0 # Source Dir
if (!(Test-Path("C:\JTSDK64-Tools\src\boost_1_74_0"))) {
	New-Item -Force -Path "C:\JTSDK64-Tools\src\boost_1_74_0" -ItemType Directory | Out-Null
}

# mkdir C:\JTSDK64-Tools\src\boost_1_74_0\boost-build # Boost.Build Installation
New-Item -Force -Path "C:\JTSDK64-Tools\tmp\boost_1_74_0\boost-build" -ItemType Directory | Out-Null
New-Item -Force -Path "C:\JTSDK64-Tools\tmp\boost_1_74_0\boost-build\build" -ItemType Directory | Out-Null # For Building
# mkdir C:\JTSDK64-Tools\tools\boost # Installation
New-Item -Force -Path "C:\JTSDK64-Tools\tools\boost" -ItemType Directory | Out-Null
Write-Host ""

# ############################################################################################
# Boost.Build setup
# ############################################################################################

# cd C:\JTSDK64-Tools\src\boost_1_74_0\tools\build
Set-Location -Path "C:\JTSDK64-Tools\src\boost_1_74_0\tools\build"

Write-Host "* Commencing Boost.Build Setup"
Write-Host ""
# prepare b2
# bootstrap.bat mingw
$cmds = ".\bootstrap.bat"
$args = "mingw"
Start-Process -NoNewWindow -wait $cmds $args

Write-Host ""
Write-Host "  --> `'bootstrap.bat mingw`' Complete."

# Build boost.build with b2
# b2 --prefix="$env:JTSDK_TMP\boost-build" install
$cmds = ".\b2"
$args = "--prefix='C:\JTSDK64-Tools\tmp\boost_1_74_0\boost-build' toolset=gcc"
Start-Process -NoNewWindow -wait $cmds $args

Write-Host "  --> b2 install --prefix=`"C:\JTSDK64-Tools\tmp\boost_1_74_0\boost-build`" Complete."

# Add C:\JTSDK64-Tools\tmp\boost-build\bin to your session PATH variable
# set PATH=%PATH%;C:\JTSDK64-Tools\tmp\boost_1_74_0-build\bin
$env:PATH=$env:PATH + ";" + "C:\JTSDK64-Tools\tmp\boost_1_74_0\boost-build\bin" + ";" + "C:\JTSDK64-Tools\src\boost_1_74_0\tools\build\src\engine"

Write-Host "  --> Added `"C:\JTSDK64-Tools\tmp\boost_1_74_0\boost-build`" to system path."

# ############################################################################################
# Building Boost
# ############################################################################################
Write-Host ""
Write-Host "* Build Boost"

Set-Location -Path "C:\JTSDK64-Tools\src\boost_1_74_0"
Write-Host "  --> Commencing actual build"

# b2 --build-dir="C:\Program Files\boost_1_59_0\build" --prefix="C:\Program Files\boost" toolset=gcc install
$cmds = "b2"
$args = "--build-dir=`"C:\JTSDK64-Tools\src\boost_1_74_0\build`" --prefix=`"C:\JTSDK64-Tools\tools\boost`" toolset=gcc install"
Start-Process -NoNewWindow -wait $cmds $args

Write-Host "  --> Build Complete."

# Complete

Write-Host "  --> Distribution in in $boostDir"
Write-Host " "

exit(0)