#-----------------------------------------------------------------------------::
# Name .........: jtsdk64-setup.ps1
# Project ......: Part of the JTSDK64 Tools Project
# Version ......: 3.4.1b
# Description ..: JTSDK64 Postinstall Setup Environment
# Project URL ..: https://github.com/KI7MT/jtsdk64-tools.git
# Usage ........: Call this file directly from the command line
# 
# Author .......: Hamlib SDK Contributors <hamlibdk@outlook.com>
#
# Concept ......: Greg, Beam, KI7MT, <ki7mt@yahoo.com>
#
# Copyright ....: Copyright (C) 2013-2021 Greg Beam, KI7MT
#                 (C) 2020 - 2024 subsequent JTSDK Contributors
# License ......: GPL-3
#
# Adjustments...: Steve VK3VM 8 Dec 2020 - 11 Apr 2023
#                 Uwe DG2YCB 25 Mar 2021 - 17 May 2022 (support for 32-bit)
#
#                 Additions for JTSDK 3.4.0 [ PowerShell Deploys ] 2024-01-13 Steve I VK3VM  
#
#-----------------------------------------------------------------------------::

# --- CONVERT FORWARD ---------------------------------------------------------
# --> Converts to Unix/MinGW/MSYS2 Path format !

function ConvertForward($inValue) {
	$inValue = ($inValue).substring(0,1).tolower() + ($inValue).substring(1)
	$inValue = ($inValue).replace("\","/")
	$inValue = ($inValue).Insert(0,'/')
	return $inValue.replace(":","")
}

# --- CENTER TEXT -------------------------------------------------------------
# --> Writest text in the center of the line
# --> Based off: https://stackoverflow.com/questions/48621267/is-there-a-way-to-center-text-in-powershell
# --> if Width = 0 assumes buffer width
# function Write-HostCenter { param($Message) Write-Host ("{0}{1}" -f (' ' * (([Math]::Max(0, $Host.UI.RawUI.BufferSize.Width / 2) - [Math]::Floor($Message.Length / 2)))), $Message) }
function Write-HostCenter($Message, $width) {
	if ( $width -eq 0 ) { 
		$bufferWidth =  [Math]::Max(0, $Host.UI.RawUI.BufferSize.Width)
	} else {
		$bufferWidth = $width
	}
	$pad=""
	For ($i=0; $i -le $bufferWidth/2; $i++) {
		Write-Host -NoNewLine " "
	}
	Write-Host $Message 
}


#------------------------------------------------------------------------------
# GLOBAL ENVIRONMENT VARIABLES and PATHS
#------------------------------------------------------------------------------

# --- Main Paths --------------------------------------------------------------

$env:JTSDK64_VERSION = [IO.File]::ReadAllText($PSScriptRoot+"\ver.jtsdk")
$host.ui.RawUI.WindowTitle = 'JTSDK64 Tools Setup ' + $env:JTSDK64_VERSION

#Clear-Host
# Write-HostCenter("Test", 12);
Write-Host "------------------------------------------------------------"
Write-Host "                  JTSDK64 Setup $env:JTSDK64_VERSION" -ForegroundColor Yellow
Write-Host "------------------------------------------------------------"
Write-Host ""

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
$env:PS_VER=$psVersionTable.PSVersion.ToString()


#------------------------------------------------------------------------------
# TOOL INSTALL VALIDATION
#------------------------------------------------------------------------------

# --- Set Initial tool status -------------------------------------------------

$env:VCRUNTIME_STATUS="Not Installed"
$env:GIT_STATUS="Not Installed"
$env:QTMAINT_STATUS="Not Installed"
$env:QTCREATOR_STATUS="Not Installed"
$env:VSCODE_STATUS="Not Installed"
$env:BOOST_STATUS="Not Installed"
$env:OMNIRIG_STATUS="Not Installed"

#------------------------------------------------------------------------------
# APP CHECK
#------------------------------------------------------------------------------

# --- Display version of PowerShell invoked -----------------------------------

Write-Host "* Checking current PowerShell environment"

# --- VC Runtime Path ---------------------------------------------------------

Write-Host "* Checking for Visual C/C++ 2022 runtime availability (Please wait)"

$env:JTSDK_VC = "$env:JTSDK_CONFIG\Versions.ini"
Get-Content $env:JTSDK_VC | foreach-object -begin {$configTable=@{}} -process { $k = [regex]::split($_,'='); if(($k[0].CompareTo("") -ne 0) -and ($k[0].StartsWith("[") -ne $True)) { $configTable.Add($k[0], $k[1]) } }
$env:VC_RUNPATH = $configTable.Get_Item("vcrunurl")
$env:QT5_VER = $configTable.Get_Item("qt5v")
$env:QT6_VER = $configTable.Get_Item("qt6v")
Write-Host -NoNewLine "  --> VC/C++ Runtime Path "
Write-Host -NoNewLine "$env:VC_RUNPATH" -ForegroundColor DarkCyan
Write-Host " from Versions.ini ... Set"

$vcRunInstance = Get-CimInstance -ClassName Win32_Product -Filter "Vendor = 'Microsoft Corporation' and Name LIKE '%Microsoft Visual C++ 2022%'"
if ($vcRunInstance) { $env:VCRUNTIME_STATUS="Installed" }

# --- OmniRig -----------------------------------------------------------------

Write-Host "* Checking for OmniRig"
$exe = "$env:ProgramFiles `(x86`)\Afreet\OmniRig\OmniRig.exe"
if (Test-Path $exe) { $env:OMNIRIG_STATUS="Installed" }

# --- Git ---------------------------------------------------------------------

Write-Host "* Checking for Git-SCM"

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

Write-Host "* Checking fot VS Code"
$exe = "$env:LOCALAPPDATA"+"\Programs\Microsoft VS Code\unins000.exe"
if (Test-Path $exe) { $env:VSCODE_STATUS="Installed"}

# --- Boost ------------------------------------------------------------------

Write-Host "* Checking for Boost"
$exe = "$env:JTSDK_TOOLS"+"\boost"
if (Test-Path $exe) { $env:BOOST_STATUS="Installed"}

# --- Qt Scripted Version Deploy Tool Chain -----------------------------------

Write-Host "* Checking Qt deployment"

if (Test-Path "$env:JTSDK_TOOLS\Qt\MaintenanceTool.exe") { $env:QTMAINT_STATUS="Installed" }
if (Test-Path "$env:JTSDK_TOOLS\Qt\Tools\QtCreator\bin\qtcreator.exe") { $env:QTCREATOR_STATUS="Installed" }

# $objList = Where-Object {$_.name -match "[\d+].[\d+].[\d+]?"} | select name
# $objTest = Get-ChildItem C:\JTSDK64-Tools\Tools\Qt\Tools -filter "mingw*" -Directory
# $objTest | ForEach-Object -process {$_.Name}

$env:QtMinGWDeployed="None"
if (Test-Path -path "$env:SystemDrive:\JTSDK64-Tools\Tools\Qt\Tools") {	 
	Get-ChildItem "$env:SystemDrive:\JTSDK64-Tools\Tools\Qt\Tools" -filter "mingw*" -Directory | ForEach-Object -process {
		if ( $env:QtMinGWDeployed -eq "None" ) { $env:QtMinGWDeployed = "" }
		$env:QtMinGWDeployed=$env:QtMinGWDeployed + $_.Name + " "
	}
}

$env:QtDeployed="None"
if (Test-Path -path "$env:SystemDrive:\JTSDK64-Tools\Tools\Qt\Licenses" ) { 
	try {
		Get-ChildItem "$env:SystemDrive:\JTSDK64-Tools\Tools\Qt\" | Where-Object {$_.name -match "[\d+].[\d+].[\d+]?"} | ForEach-Object -process {
			if ( $env:QtDeployed -eq "None" ) { $env:QtDeployed = "" }
			$env:QtDeployed=$env:QtDeployed + $_.name + " "
		}
	}
	catch {
	}
}

# --- Complete ! --------------------------------------------------------------

Write-Host " "
Write-Host -ForegroundColor yellow  "Note: PowerShell Windows 5.1 is preferred for Deployment."
Write-Host " "
Write-Host "* The environment for JTSDK deployment is now in place."
Write-Host " "

$input = $(Write-Host -NoNewLine -ForegroundColor blue "*** Press [ENTER] to Launch JTSDK64-Setup Environment *** " ; Read-Host) 

#------------------------------------------------------------------------------
# PRINT TOOL CHAN STATUS / CREATE INTERACTIVE POWERSHELL ENVIRON
#------------------------------------------------------------------------------

invoke-expression 'cmd /c start powershell -NoExit -Command {                           `           `
    $host.UI.RawUI.WindowTitle = "JTSDK64 PowerShell Windows 5.1" 
    New-Alias msys2 "$env:JTSDK_TOOLS\msys64\msys2_shell.cmd"
	New-Alias postinstall "$env:JTSDK_TOOLS\setup\jtsdk64-postinstall.ps1"
    Write-Host "-------------------------------------------"
	Write-Host "          JTSDK64 Setup $env:JTSDK64_VERSION" -ForegroundColor Yellow
	Write-Host "-------------------------------------------"
	Write-Host ""
	Write-Host "  Required Tools"  -ForegroundColor Yellow
	Write-Host ""
	Write-Host "     PowerShell ..... $env:PS_VER"
	Write-Host "     VC Runtimes .... $env:VCRUNTIME_STATUS"
	Write-Host "     Git ............ $env:GIT_STATUS"
	Write-Host "     OmniRig ........ $env:OMNIRIG_STATUS"
	Write-Host ""
	Write-Host "  Qt Tool Chain(s) Deployed"  -ForegroundColor Yellow
	Write-Host ""
	Write-Host -NoNewLine "    Qt: "  -ForegroundColor Green
    Write-Host "$env:QtDeployed"
	Write-Host ""
	Write-Host -NoNewLine "    Tools: "  -ForegroundColor Green 
	Write-Host "$env:QtMinGWDeployed"
	Write-Host ""
	Write-Host "  Optional Components"  -ForegroundColor Yellow
	Write-Host ""
	Write-Host "     VS Code ........ $env:VSCODE_STATUS"
	Write-Host "     Boost .......... $env:BOOST_STATUS"
	Write-Host ""
	Write-Host "  Post Install / Manual Setup Commands"  -ForegroundColor Yellow
	Write-Host ""
	Write-Host "     Main Install ... postinstall"
	Write-Host "     MSYS2 Shell .... msys2"
	Write-Host ""
}'