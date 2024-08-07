#-----------------------------------------------------------------------------#
# Name ........: jtsdk64-postinstall.ps1
# Project .....: HAMLIB SDK - JTSDK64 Tools Project
# Version .....: 3.4.0.2
# Description .: Installs Components based on User selections
# 
# Usage .......: Call from jtsdk64-tools-setup environ => jtsdk64-postinstall $*
#
# Concept .....: (C) Greg, Beam, KI7MT, <ki7mt@yahoo.com> and batch file work
#
# Copyright ...: (c) Copyright (C) 2021-2024 JTSDK Contributors
#
# License .....: GPLv3
# 
# Updates .....: Conversion to PS: Steve VK3VM 24-12-2020 - 10-04-2023
#                Slight mods for migration to Version 4 of HLSDK (JTSDK): Coordinated by Steve VK3VM 02-6-2023
#                Code to pull and deploy PowerShell: Coordiated by Steve VK3VM 15-1-2024
#
# Note ........: This script will FAIL unless it is executed from within a
#                shell generated by jtsdk64-setup.ps1 ! 
#
#-----------------------------------------------------------------------------#

# ------------------------------------------------------------------- GLOBALS

$defaultQt="5.15.2"

# ------------------------------------------------------------------- MESSAGE DISPLAY
function MsgDisplay {
	Write-Host ""
	Write-Host " If you wish to re-enter selections type: postinstall"
	exit (0)
}

# ------------------------------------------------------------------- WRITE ERROR MESSAGE
function WriteErrorMessage($param) {
    Write-Host ""
    Write-Host "**************************************************** "
	Write-Host "Processing Error"
    Write-Host "**************************************************** "
	Write-Host ""
	Write-Host "The exit status from step `[ $param `] returned"
	Write-Host "a non-zero status. Check the error message and"
	Write-Host "and try again."
	Write-Host ""
	Write-Host "If the problem presists, contact: JTSDK@Groups.io"
	Write-Host ""
	exit (-1)
}

# ------------------------------------------------------------------- START MESSAGE
function StartMessage {
	Write-Host ""
	Write-Host "------------------------------------------------------"
	Write-Host "  JTSDK64 Tools Post Install/Redeployment Selections"
	Write-Host "------------------------------------------------------"
	Write-Host ""
	Write-Host " At the prompts indicate which components you want to"
	Write-Host " install or redeploy."
	Write-Host ""
	Write-Host " For VC Runtimes, OmniRig, Git, MSYS2 and VS Code use"
	Write-Host " --> Y`/Yes or N`/No"
	Write-Host ""
	Write-Host " For the Qt Install Selection:"
	Write-Host ""
	Write-Host "   D / Y = Default ( minimal set of tools )"
	Write-Host "   F = Full ( full set of tools )"
	Write-Host "   N = Skip Installation"
	Write-Host ""
	Write-Host " NOTE: VC Runtimes, Git, Qt and MSYS2 are mandatory to build"  
	Write-Host " JT-software. The Latest PowerShell is highly recommended."
}

# ------------------------------------------------------------------- DISPLAY SELECTIONS
function DisplaySelections ($userInputPS, $userInputVCR, $userInputOmniRig, $userInputGit, $userInputQt, $userInputMsys2, $userInputVSCode) {
	Write-Host ""
	Write-Host "* Your Installation Selections:"
	Write-Host ""
	Write-Host "  --> Latest PowerShell .............: $userInputPS"
	Write-Host "  --> VC Runtimes ...................: $userInputVCR"
	Write-Host "  --> OmniRig .......................: $userInputOmniRig"
	Write-Host "  --> Git ...........................: $userInputGit"
	Write-Host "  --> Qt ............................: $userInputQt"
	Write-Host "  --> MSYS2 .........................: $userInputMsys2"
	Write-Host "  --> VS Code .......................: $userInputVSCode"
	Write-Host ""
}

# ------------------------------------------------------------------- GET SELECTIONS
function GetSelections([ref]$iPS, [ref]$iVCR, [ref]$iOmniRig, [ref]$iGit, [ref]$iQt, [ref]$iMsys2, [ref]$iVSCode) {
	Write-Host ""
	Write-Host "* Enter Your Install/Redeployment Selection(s)`:"
	Write-Host ""

	$iPS.value      = Read-Host " (required) Latest PowerShell (Y|N) ."
	$iVCR.value     = Read-Host " (required) VC/C++ Runtimes (Y|N) ..."
	$iOmniRig.value = Read-Host " (required) OmniRig (Y|N) ..........."
	$iGit.value     = Read-Host " (required) Git-SCM (Y|N) ..........."
	$iQt.value      = Read-Host " (required) Default Qt (D/Y|F|N) ...."
	$iMsys2.value   = Read-Host " (required) MSYS2 Setup (Y|N) ......."
	$iVSCode.value  = Read-Host " (optional) VS Code (Y|N) ..........."
	$iPS.value      = $iPS.value.ToUpper()
	$iVCR.value     = $iVCR.value.ToUpper()
	$iOmniRig.value = $iOmniRig.value.ToUpper() 
	$iGit.value     = $iGit.value.ToUpper()
	$iQt.value      = $iQt.value.ToUpper() 
	$iMsys2.value   = $iMsys2.value.ToUpper() 
	$iVSCode.value  = $iVSCode.value.ToUpper()
}


# ------------------------------------------------------------------- PROCESS PowerShell
function ProcessPS {
	$install = "Y"
    $step = "Latest PowerShell Install"

    $cmd = "$env:JTSDK_SETUP\powershell\Install-PowerShell.ps1"
    $param="install"
    Invoke-Expression "$cmd $param"
	
    if ($LASTEXITCODE -ne 0) { WriteErrorMessage($step) }
}

# ------------------------------------------------------------------- PROCESS VC RUNTIMES
function ProcessVCR {
	$install = "Y"
    $step = "VC Runtimes Install"

    $cmd = "$env:JTSDK_SETUP\vcruntime\Install-VCRuntime.ps1"
    $param="install"
    Invoke-Expression "$cmd $param"
	
    if ($LASTEXITCODE -ne 0) { WriteErrorMessage($step) }
}

# ------------------------------------------------------------------- PROCESS OMNIRIG
function ProcessOmniRig {
	$install = "Y"
    $step = "OmniRig Install"

    $cmd = "$env:JTSDK_SETUP\omnirig\Install-Omnirig.ps1"
    $param="install"
    Invoke-Expression "$cmd $param"
	
    if ($LASTEXITCODE -ne 0) { WriteErrorMessage($step) }
}

# ------------------------------------------------------------------- PROCESS GIT
function ProcessGit {
    $install = "Y"
    $step = "Git Install"

    $cmd = "$env:JTSDK_SETUP\git\Install-Git.ps1"
    $param="install"
    Invoke-Expression "$cmd $param"
	
    if ($LASTEXITCODE -ne 0) { WriteErrorMessage($step) }
}

# ------------------------------------------------------------------- PROCESS VS CODE
function ProcessVSCode {
    $install="Y"
    $step = "VS Code Install"
    
    $cmd = "$env:JTSDK_SETUP\vscode\Install-VSCode.ps1" # install"
    $param="install"
    Invoke-Expression "$cmd $param"

    if ($LASTEXITCODE -ne 0) { WriteErrorMessage($step) }
}

# ------------------------------------------------------------------- PROCESS Qt
function ProcessQt {
	$cmd = "$env:JTSDK_SETUP\qt\Generate-JSQt.ps1"
	$step = "QT Generate Script"
    Invoke-Expression "$cmd $param"
    if ($LASTEXITCODE -ne 0) { WriteErrorMessage($step) }

	$cmd = "$env:JTSDK_SETUP\qt\Install-Qt.ps1"
	
	# If option -eq D, install default (minimal) set of scripted Qt options
	
	if  (($userInputQt -eq "D") -or ($userInputQt -eq "Y")) {
		$install="Y"
		$step = "QT Default Install"
        $param="min"
        Invoke-Expression "$cmd $param"
        if ($LASTEXITCODE -ne 0) { WriteErrorMessage($step) }
		Write-Host "* Removing pre-existing Qt Configration marker(s)"
		Get-ChildItem $env:JTSDK_CONFIG | Where{$_.Name -Match "qt*"} | Remove-Item
		Write-Host "* Setting Qt Configration marker [$defaultQt]"
		$tmpOut = $env:JTSDK_CONFIG + "\qt" + $defaultQt
		Out-File -FilePath $tmpOut
	}
	
	# If option -eq F, install full (basic) set of Scripted Qt options
	
	if  ($userInputQt -eq "F") {
		$install="Y"
		$step = "QT Full Install"
        $param="full"
        Invoke-Expression "$cmd $param"
        if ($LASTEXITCODE -ne 0) { WriteErrorMessage($step) }
		Write-Host "* Using Tools-delivered Qt Configration marker --> Check that this is appropriate."
	}
}

# ------------------------------------------------------------------- PROCESS MSYS2
function ProcessMSYS2 {
	$install="Y"
	$step = "MSYS2 Deploy"
    $cmd = "$env:JTSDK_HOME\tools\msys64\msys2_shell.cmd"
	$exitCode = Invoke-Command -ScriptBlock { cmd /c $cmd *> $null; return $LASTEXITCODE }
	if ($exitCode -ne 0) { WriteErrorMessage($step) }
}

# ------------------------------------------------------------------- DISPLAY POST INSTALL MESSAGES
function DisplayPostInstall ($userInputVCR, $userInputOmniRig, $userInputGit, $userInputQt, $userInputMsys2, $userInputVSCode, $install) {
	if  ($install -eq "Y") {
		
		Write-Host ""
		# Clear-Host
		Write-Host "------------------------------------------------------"
		Write-Host " JTSDK64 Tools Post Install Summary"
		Write-Host "------------------------------------------------------"
		Write-Host ""
		Write-Host "* Post Installation Stage Complete"
		Write-Host ""
		Write-Host " Exit the JTSDK64 Tools Setup Environment and re-open"
		Write-Host " to see the current status of installed tools."

		if  ($userInputMsys2 -eq "Y") {
			Write-Host ""
			Write-Host " MSYS2 Initial Setup requires several additional steps."
			Write-Host " Open the MSYS2 environemnt and refer to the on-screen" 
			Write-Host " messages to perform the initial installation`/updates."
			Write-Host ""
			Write-Host " After fully updating MSYS2, select the appropriate menu"
			Write-Host " option to install the Hamlib Dependencies. Close the"
			Write-Host " installation environment."
			Write-Host ""
			Write-Host " Perform the remaining tasks including building Hamlib" 
			Write-Host " under the `"JTSDK64-Tools`" Environment."
			Write-Host ""
		}
	} 
	# EXIT INSTALL

	Write-Host ""

}

#-----------------------------------------------------------------------------#
# Main Logic
#-----------------------------------------------------------------------------#

$install="N"
$userInputPS = " "
$userInputVCR = " "
$userInputOmniRig = " "
$userInputGit = " "
$userInputQt = " "
$userInputMsys2 = " "
$userInputVSCode = " "

Clear-Host

StartMessage 

GetSelections([ref]$userInputPS) ([ref]$userInputVCR) ([ref]$userInputOmniRig) ([ref]$userInputGit) ([ref]$userInputQt) ([ref]$userInputMsys2) ([ref]$userInputVSCode)

DisplaySelections ($userInputPS) ($userInputVCR) ($userInputOmniRig) ($userInputGit) ($userInputQt) ($userInputMsys2) ($userInputVSCode)

# ----------------------------------------------------------------------------- SELECTIONS

if ($userInputPS -eq "Y") { 
	ProcessPS 
	$install = "Y"
}
if ($userInputVCR -eq "Y") { 
	ProcessVCR 
	$install = "Y"
}
if ($userInputOmniRig -eq "Y") { 
	ProcessOmniRig 
	$install = "Y"
}
if ($userInputGit -eq "Y") { 
	ProcessGit
	$install = "Y"	
}
if ($userInputVSCode -eq "Y") { 
	ProcessVSCode
	$install = "Y"
}
if ($userInputQt -ne "N") { 
	ProcessQt
	$install = "Y"	
}
if ($userInputMsys2 -eq "Y") { 
	ProcessMSYS2
	$install = "Y"	
}

# FINISHED

DisplayPostInstall($userInputPS) ($userInputVCR) ($userInputOmniRig) ($userInputGit) ($userInputQt) ($userInputMsys2) ($userInputVSCode) ($install)

exit (0)