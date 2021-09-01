#-----------------------------------------------------------------------------::
# Name .........: jtsdk64-setup.ps1
# Project ......: Part of the JTSDK64 Tools Project
# Version ......: 3.2.1
# Description ..: JTSDK64 Postinstall Setup Environment
# Project URL ..: https://github.com/KI7MT/jtsdk64-tools.git
# Usage ........: Call this file directly from the command line
# 
# Author .......: Hamlib SDK Contributors <hamlibdk@outlook.com>
#
# Concept ......: Greg, Beam, KI7MT, <ki7mt@yahoo.com>
#
# Copyright ....: Copyright (C) 2013-2021 Greg Beam, KI7MT
#                 And (C) 2020 - 2021 subsequent JTSDK Contributors
# License ......: GPL-3
#
# Adjustments...: Steve VK3VM 8 Dec 2020 - 25 Mar 2021
#                 Uwe DG2YCB 25 Mar 2021

# --- CONVERT FORWARD ---------------------------------------------------------
# --> Converts to Unix/MinGW/MSYS2 Path format !

function ConvertForward($inValue) {
	$inValue = ($inValue).substring(0,1).tolower() + ($inValue).substring(1)
	$inValue = ($inValue).replace("\","/")
	$inValue = ($inValue).Insert(0,'/')
	return $inValue.replace(":","")
}

$env:JTSDK64_VERSION = [IO.File]::ReadAllText($PSScriptRoot+"\ver.jtsdk")
$host.ui.RawUI.WindowTitle = “JTSDK64 Tools Setup ” + $env:JTSDK64_VERSION

Clear-Host
Write-Host "--------------------------------------------------------------"
Write-Host "               JTSDK64 Tools Setup $env:JTSDK64_VERSION" -ForegroundColor Yellow
Write-Host "--------------------------------------------------------------"
Write-Host " "

#------------------------------------------------------------------------------
# GLOBAL ENVIRONMENT VARIABLES and PATHS
#------------------------------------------------------------------------------

# --- Main Paths --------------------------------------------------------------

Write-Host "* Setting Environment Variables"
$env:JTSDK_HOME = $PSScriptRoot 
$env:JTSDK_HOME_F = ConvertForward($env:JTSDK_HOME) 
$env:JTSDK_CONFIG = $env:JTSDK_HOME + "\config"
$env:JTSDK_CONFIG_F = ConvertForward($env:JTSDK_CONFIG)
$env:JTSDK_DATA= $env:JTSDK_HOME + "\data"
$env:JTSDK_DATA_F = ConvertForward($env:JTSDK_DATA)
$env:JTSDK_SRC = $env:JTSDK_HOME + "\src"
$env:JTSDK_SRC_F = ConvertForward($env:JTSDK_SRC) 
$env:JTSDK_TMP = $env:JTSDK_HOME + "\tmp"
$env:JTSDK_TMP_F = ConvertForward($env:JTSDK_TMP)
$env:JTSDK_TOOLS = $env:JTSDK_HOME + "\tools"
$env:JTSDK_TOOLS_F = ConvertForward($env:JTSDK_TOOLS)
$env:JTSDK_SCRIPTS = $env:JTSDK_TOOLS + "\scripts"
$env:JTSDK_SCRIPTS_F = ConvertForward($env:JTSDK_SCRIPTS) 

$env:JTSDK_SETUP = $env:JTSDK_HOME + "\tools\setup"

# --- Global Environment Variables --------------------------------------------

$env:JTSDK_GIT_INSTALL_DIR = $env:ProgramFiles+"\Git"		# $env:ProgramFiles : System : where x64 progs deployed
$env:JTSDK_QT_INSTALL_DIR = $env:JTSDK_TOOLS + "\Qt"
$JTSDK_MSYS2 = $env:JTSDK_TOOLS + "\msys64"

$env:PATH=$env:PATH+";"+$env:JTSDK_HOME+";"+$env:JTSDK_TOOLS+";"+$env:JTSDK_SETUP+";"+$JTSDK_MSYS2

#------------------------------------------------------------------------------
# TOOL INSTALL VALIDATION
#------------------------------------------------------------------------------

# --- Set Initial tool status -------------------------------------------------

$env:VCRUNTIME_STATUS="Not Installed"
$env:GIT_STATUS="Not Installed"
$env:QTMAINT_STATUS="Not Installed"
$env:QTCREATOR_STATUS="Not Installed"
$env:MinGW73_STATUS="Not Installed"
$env:MinGW81_STATUS="Not Installed"
$env:VSCODE_STATUS="Not Installed"
$env:BOOST_STATUS="Not Installed"
$env:OMNIRIG_STATUS="Not Installed"

#------------------------------------------------------------------------------
# APP CHECK
#------------------------------------------------------------------------------

# --- VC Runtimes -------------------------------------------------------------

Write-Host -NoNewline "* Checking VC 2019 Runtime availability (Please wait) ..."

$vcRunInstance = Get-CimInstance -ClassName Win32_Product -Filter "Vendor = 'Microsoft Corporation' and Name LIKE '%Microsoft Visual C++ 2019%'"
Write-Host " Done"
if ($vcRunInstance) { $env:VCRUNTIME_STATUS="Installed" }

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

if (Test-Path "$env:JTSDK_TOOLS\Qt\[1-9]*\mingw73_64\bin") { $env:MinGW73_STATUS = Get-ChildItem $env:JTSDK_TOOLS\Qt\[1-9]*\mingw73_64\bin\Qt?Core.dll }
$env:MinGW73_STATUS = $env:MinGW73_STATUS -replace "64" -replace "73" -replace "81" -replace "Qt5Core.dll" -replace "Qt6Core.dll" -replace "[^\d\.\  ]" -replace (" ",", Qt ")
if ($env:MinGW73_STATUS -eq ", Qt ") { $env:MinGW73_STATUS="Not Installed" }

if (Test-Path "$env:JTSDK_TOOLS\Qt\[1-9]*\mingw81_64\bin") { $env:MinGW81_STATUS = Get-ChildItem $env:JTSDK_TOOLS\Qt\[1-9]*\mingw81_64\bin\Qt?Core.dll }
$env:MinGW81_STATUS = $env:MinGW81_STATUS -replace "64" -replace "73" -replace "81" -replace "Qt5Core.dll" -replace "Qt6Core.dll" -replace "[^\d\.\  ]" -replace (" ",", Qt ")
if ($env:MinGW81_STATUS -eq ", Qt ") { $env:MinGW81_STATUS="Not Installed" }

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
    Write-Host "---------------------------------------------------------"
	Write-Host "            JTSDK64 Tools Setup $env:JTSDK64_VERSION" -ForegroundColor Cyan
	Write-Host "---------------------------------------------------------"
	Write-Host " "
	Write-Host "  Required Tool Status"
	Write-Host " "
	Write-Host "     VC Runtimes ... $env:VCRUNTIME_STATUS"
	Write-Host "     Git ........... $env:GIT_STATUS"
	Write-Host "     OmniRig ....... $env:OMNIRIG_STATUS"
	Write-Host " "
	Write-Host "  Qt Script-Provisioned Tool Chain Status"
	Write-Host " "
	Write-Host "     MinGW 7.3 ..... Qt $env:MinGW73_STATUS"
	Write-Host "     MinGW 8.1 ..... Qt $env:MinGW81_STATUS"
	Write-Host " "
	Write-Host "  Optional Component Status"
	Write-Host " "
	Write-Host "     VS Code ....... $env:VSCODE_STATUS"
	Write-Host "     Boost ......... $env:BOOST_STATUS"
	Write-Host " "
	Write-Host "  Post Install / Manual Setup Commands"
	Write-Host " "
	Write-Host "     Main Install .. postinstall"
	Write-Host "     MSYS2 Shell ... msys2"
	Write-Host " "
}'