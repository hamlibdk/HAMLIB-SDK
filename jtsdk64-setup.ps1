#-----------------------------------------------------------------------------::
# Name .........: jtsdk64-tools-setup.ps1
# Project ......: Part of the JTSDK64 Tools Project
# Version ......: 3.2.0 Beta
# Description ..: JTSDK64 Postinstall Setup Environment
# Project URL ..: https://github.com/KI7MT/jtsdk64-tools.git
# Usage ........: Call this file directly from the command line
# 
# Author .......: Hamlib SDK Contributors <hamlibdk@hotmail.com>
#
# Concept ......: Greg, Beam, KI7MT, <ki7mt@yahoo.com>
#
# Copyright ....: Copyright (C) 2013-2021 Greg Beam, KI7MT
#                 And (C) 2020 - 2021 subsequent JTSDK Contributors
# License ......: GPL-3
#
# Adjustments...: Steve VK3VM 8 Dec 2020 - 8 Feb 2021

$env:JTSDK64_VERSION = [IO.File]::ReadAllText($PSScriptRoot+"\ver.jtsdk")
$host.ui.RawUI.WindowTitle = “JTSDK64 Tools Setup ” + $env:JTSDK64_VERSION

Clear-Host
Write-Host "-----------------------------------------------"
Write-Host "       JTSDK64 Tools Setup $env:JTSDK64_VERSION"
Write-Host "-----------------------------------------------"
Write-Host " "

#------------------------------------------------------------------------------
# GLOBAL ENVIRONMENT VARIABLES and PATHS
#------------------------------------------------------------------------------

# --- Main Paths --------------------------------------------------------------

Write-Host "* Setting Environment Variables"
$env:JTSDK_HOME = $PSScriptRoot
$env:JTSDK_TOOLS = $env:JTSDK_HOME + "\tools"
$env:JTSDK_SETUP = $env:JTSDK_HOME + "\tools\setup"
$env:JTSDK_CURL_BIN = $env:JTSDK_HOME + "\curl\bin"

# --- Global Environment Variables --------------------------------------------

$env:JTSDK_GIT_INSTALL_DIR = $env:ProgramFiles+"\Git"		# $env:ProgramFiles : System : where x64 progs deployed
$env:JTSDK_QT_INSTALL_DIR = $env:JTSDK_TOOLS + "\Qt"
$JTSDK_MSYS2 = $env:JTSDK_TOOLS + "\MSYS64"

$env:PATH=$env:PATH+";"+$env:JTSDK_HOME+";"+$env:JTSDK_TOOLS+";"+$env:JTSDK_SETUP+";"+$env:JTSDK_CURL_BIN+";"+$JTSDK_MSYS2

#------------------------------------------------------------------------------
# TOOL INSTALL VALIDATION
#------------------------------------------------------------------------------

# --- Set Initial tool status -------------------------------------------------

$env:GIT_STATUS="Not Installed"
$env:QTMAINT_STATUS="Not Installed"
$env:QTCREATOR_STATUS="Not Installed"
$env:GCC73_STATUS="Not Installed"
$env:GCC81_STATUS="Not Installed"
$env:QT51210_STATUS="Not Installed"
$env:QT5142_STATUS="Not Installed"
$env:QT5152_STATUS="Not Installed"
$env:QT601_STATUS="Not Installed"
$env:VSCODE_STATUS="Not Installed"
$env:BOOST_STATUS="Not Installed"
$env:OMNIRIG_STATUS="Not Installed"

#------------------------------------------------------------------------------
# APP CHECK
#------------------------------------------------------------------------------

# --- OmniRig -----------------------------------------------------------------

Write-Host "* Checking OmniRig"
$exe = "$env:ProgramFiles `(x86`)\Afreet\OmniRig\OmniRig.exe"
if (Test-Path $exe) { $env:OMNIRIG_STATUS="Installed" }
# --- Git ---------------------------------------------------------------------

Write-Host "* Checking Git"

#Ref: https://stackoverflow.com/questions/46743845/trying-to-find-out-if-git-is-installed-via-powershell
try {
    $exe = "git.exe"
    $params = "--version"
    &$exe $params | Out-Null
    if ($LASTEXITCODE -eq 0) { $env:GIT_STATUS="Installed" }
} 
catch [System.Management.Automation.CommandNotFoundException]
{

}

# --- VS Code ----------------------------------------------------------------

Write-Host "* Checking VS Code"
$exe = "$env:LOCALAPPDATA"+"\Programs\Microsoft VS Code\unins000.exe"
if (Test-Path $exe) { $env:VSCODE_STATUS="Installed"}

# --- Boost ------------------------------------------------------------------

Write-Host "* Checking Boost"
$exe = "$env:JTSDK_TOOLS"+"\boost"
if (Test-Path $exe) { $env:BOOST_STATUS="Installed"}

# --- Qt Scripted Version Deploy Tool Chain -----------------------------------

Write-Host "* Checking QT Deployment"

if (Test-Path "$env:JTSDK_TOOLS\Qt\MaintenanceTool.exe") { $env:QTMAINT_STATUS="Installed" }
if (Test-Path "$env:JTSDK_TOOLS\Qt\Tools\QtCreator\bin\qtcreator.exe") { $env:QTCREATOR_STATUS="Installed" }
if (Test-Path "$env:JTSDK_TOOLS\Qt\5.12.10\mingw73_64\bin\Qt5Core.dll") { $env:QT51210_STATUS="Installed" }
if (Test-Path "$env:JTSDK_TOOLS\Qt\5.14.2\mingw73_64\bin\Qt5Core.dll") { $env:QT5142_STATUS="Installed" }
if (Test-Path "$env:JTSDK_TOOLS\Qt\5.15.2\mingw81_64\bin\Qt5Core.dll") { $env:QT5152_STATUS="Installed" }
if (Test-Path "$env:JTSDK_TOOLS\Qt\6.0.1\mingw81_64\bin\Qt6Core.dll") { $env:QT601_STATUS="Installed" }
if (Test-Path "$env:JTSDK_TOOLS\Qt\Tools\mingw730_64\bin\gcc.exe") { $env:GCC73_STATUS="Installed" }
if (Test-Path "$env:JTSDK_TOOLS\Qt\Tools\mingw810_64\bin\gcc.exe") { $env:GCC81_STATUS="Installed" }

# --- Complete ! --------------------------------------------------------------

Write-Host " "
Write-Host "The environment for JTSDK deployment is now in place."
Write-Host " "
pause

#------------------------------------------------------------------------------
# PRINT TOOL CHAN STATUS / CREATE INTERACTIVE POWERSHELL ENVIRON
#------------------------------------------------------------------------------

invoke-expression 'cmd /c start powershell -NoExit -Command {                           `           `
    $host.UI.RawUI.WindowTitle = "JTSDK64 Setup Powershell Window" 
    New-Alias msys2 "$env:JTSDK_TOOLS\msys64\msys2_shell.cmd"
	New-Alias postinstall "$env:JTSDK_TOOLS\setup\jtsdk64-postinstall.ps1"
    Write-Host "-----------------------------------------------"
	Write-Host "  JTSDK64 Tools Setup $env:JTSDK64_VERSION"
	Write-Host "-----------------------------------------------"
	Write-Host " "
	Write-Host "  Required Tool Status"
	Write-Host " "
	Write-Host "     Git ........... $env:GIT_STATUS"
	Write-Host "     OmniRig ....... $env:OMNIRIG_STATUS"
	Write-Host " "
	Write-Host "  Qt Script-Provisioned Tool Chain Status"
	Write-Host " "
	Write-Host "     5.12.10 ....... $env:QT51210_STATUS"
	Write-Host "     5.14.2 ........ $env:QT5142_STATUS"
	Write-Host "     5.15.2 ........ $env:QT5152_STATUS"
	Write-Host "     6.0.1 ......... $env:QT601_STATUS"
	Write-Host "     GCC 7.3 ....... $env:GCC73_STATUS"
	Write-Host "     GCC 8.1 ....... $env:GCC81_STATUS"
	Write-Host "     QtCreator ..... $env:QTCREATOR_STATUS"
	Write-Host "     Maintenance ... $env:QTMAINT_STATUS"
	Write-Host " "
	Write-Host "     Note: jtbuild.ps1 will detect manually added MinGW"
	Write-Host "           Qt installations outside of scripted deploys."
	Write-Host " "
	Write-Host "  Optional Component Status"
	Write-Host " "
	Write-Host "     VS Code ....... $env:VSCODE_STATUS"
	Write-Host "     Boost ......... $env:BOOST_STATUS"
	Write-Host " "
	Write-Host "  Post Installation / Manual Setup"
	Write-Host " "
	Write-Host "  Commands:"
	Write-Host " "
	Write-Host "     Main Install .. postinstall"
	Write-Host "     MSYS2 Shell ... msys2"
	Write-Host " "
}'