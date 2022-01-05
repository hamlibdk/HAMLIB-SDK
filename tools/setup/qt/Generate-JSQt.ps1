#-----------------------------------------------------------------------------#
# Name .........: Generate-JSQt.ps1
# Project ......: Part of the JTSDK64 Tools Project
# Version ......: 3.2.1 r1
# Description ..: Downloads the latest Qt Installer
# Usage ........: Call this file directly from the command line
#
# Concept ......: Greg, Beam, KI7MT, <ki7mt@yahoo.com>
# Author .......: Hamlib SDK Contributors <hamlibdk@hotmail.com>
# Copyright ....: Copyright (C) 2013-2021 Greg Beam, KI7MT
#               : (C) 2020 - 2022 Hamlib SDK Contributors
# License ......: GPL-3
#
# Usage of files created:
#
#      Minimal Install
#      qt-unified-windows-x86-online.exe --script .\qt-min-install.qs
#
#      Full Install
#      qt-unified-windows-x86-online.exe --script .\qt-full-install.qs
#
#-----------------------------------------------------------------------------#


# GENERATOR ERROR ------------------------------------------------------------

function GenerateError {
	Write-Host " "
	Write-Host " Post Install Test Failed!!"
	Write-Host " Report error to JTSDK@Groups.io"
	exit(-1)
}

# MAIN LOGIC FLOW ------------------------------------------------------------

$appName="qt"
$appFormalName="Qt"

# For Test and Development purposes only !
# Script should be run in an environ that sets these !
if (-not (Test-Path env:JTSDK_HOME)) {
    Write-Host "* Setting Environment Variables"
    $env:JTSDK_HOME = "C:\JTSDK64-Tools"
    $env:JTSDK_CONFIG = $env:JTSDK_HOME + "\config"
    $env:JTSDK_DATA= $env:JTSDK_HOME + "\data"
    $env:JTSDK_SRC = $env:JTSDK_HOME + "\src"
    $env:JTSDK_TMP = $env:JTSDK_HOME + "\tmp"
    $env:JTSDK_TOOLS = $env:JTSDK_HOME + "\tools"
    $env:JTSDK_SCRIPTS = $env:JTSDK_TOOLS + "\scripts"
    Set-Location -Path "$env:JTSDK_TOOLS\setup\qt"
}

# source and output file paths
$sourceDir = "$env:JTSDK_HOME\tools\setup\qt"
$toolsRoot = "$env:JTSDK_HOME\tools"
$outFilePath = $sourceDir

# Qs scripts
$minOutFileText = "Qt Minimal Install Script"
$minOutFilename = "qt-min-install.qs"

$fullOutFileText = "Qt Full Install Script"
$fullOutFilename = "qt-full-install.qs"

# app directories
$installDir_F="$env:JTSDK_TOOLS\$appFormalName"

# covert back-slahes to forward-slashes, as Qt installer will fail otherwise
$installDir_F = $installDir_F.replace("\","/")

# -----------------------------------------------------------------
#  INSTALL SECTION
# -----------------------------------------------------------------

# Write-Host " "
Write-Host "-----------------------------------------------------"
Write-Host " Generate QT Install Scripts"
Write-Host "-----------------------------------------------------"
Write-Host " "
Write-Host "* $minOutFileText"
Write-Host " "
Write-Host "  --> Expected Path .... $outFilePath"
Write-Host "  --> Script Location .. $outFilePath\$minOutFilename"

$of = "$outFilePath\$minOutFilename"

New-Item -Force $of > $null
Add-Content $of  "function Controller`(`) `{"
Add-Content $of  " installer.autoRejectMessageBoxes`(`);"
Add-Content $of  " installer.installationFinished.connect`(function`(`) `{"
Add-Content $of  "  gui.clickButton`(buttons.NextButton`)`;"
Add-Content $of  " `}`)"
Add-Content $of  "`}"
Add-Content $of  " "
Add-Content $of  "Controller.prototype.WelcomePageCallback `= function`(`) `{"
Add-Content $of  " gui.clickButton`(buttons.NextButton`, 3000`)`;"
Add-Content $of  "`}"
Add-Content $of  " "
Add-Content $of  "Controller.prototype.CredentialsPageCallback `= function`(`)`{"
Add-Content $of  " gui.clickButton`(buttons.NextButton`)`;"
Add-Content $of  "`}"
Add-Content $of  " "
Add-Content $of  "Controller.prototype.IntroductionPageCallback `= function`(`) `{"
Add-Content $of  " gui.clickButton`(buttons.NextButton`)`;"
Add-Content $of  "`}"
Add-Content $of  " "
Add-Content $of  "Controller.prototype.TargetDirectoryPageCallback `= function`(`) `{"
Add-Content $of  " gui.currentPageWidget`(`).TargetDirectoryLineEdit.setText`(`"$installDir_F`"`)`;"
Add-Content $of  " gui.clickButton`(buttons.NextButton`)`;"
Add-Content $of  "`}"
Add-Content $of  " "
Add-Content $of  "Controller.prototype.ComponentSelectionPageCallback `= function`(`) `{"
Add-Content $of  " var widget `= gui.currentPageWidget`(`)`;"
Add-Content $of  " widget.deselectAll`(`)`;"
Add-Content $of  " widget.selectComponent`(`"qt.tools.vcredist_msvc2017_x64`"`)`;"
Add-Content $of  " widget.selectComponent`(`"qt.tools.vcredist_msvc2019_x64`"`)`;"
Add-Content $of  " widget.selectComponent`(`"qt.tools.maintenance`"`)"
Add-Content $of  " widget.selectComponent`(`"qt.tools.qtcreator`"`)`;"
Add-Content $of  " widget.selectComponent`(`"qt.tools.cmake.win64`"`)`;"
Add-Content $of  " widget.selectComponent`(`"qt.tools.win64_mingw730`"`)`;"
Add-Content $of  " widget.selectComponent`(`"qt.qt5.51212.win64_mingw73`"`)`;"
Add-Content $of  " gui.clickButton`(buttons.NextButton`)`;"
Add-Content $of  "`}"
Add-Content $of  " "
Add-Content $of  "Controller.prototype.LicenseAgreementPageCallback `= function`(`) `{"
Add-Content $of  " gui.currentPageWidget`(`).AcceptLicenseRadioButton.setChecked`(true`);"
Add-Content $of  " gui.clickButton`(buttons.NextButton`)`;"
Add-Content $of  "`}"
Add-Content $of  " "
Add-Content $of  "Controller.prototype.StartMenuDirectoryPageCallback `= function`(`) `{"
Add-Content $of  " gui.clickButton`(buttons.NextButton`)`;"
Add-Content $of  "`}"
Add-Content $of  " "
Add-Content $of  "Controller.prototype.ReadyForInstallationPageCallback `= function`(`)"
Add-Content $of  "`{"
Add-Content $of  "  gui.clickButton`(buttons.NextButton`)`;"
Add-Content $of  "`}"
Add-Content $of  " "
Add-Content $of  "Controller.prototype.FinishedPageCallback `= function`(`) `{"
Add-Content $of  "  var checkBoxForm `= gui.currentPageWidget`(`).LaunchQtCreatorCheckBoxForm"
Add-Content $of  "  if `(checkBoxForm `&`& checkBoxForm.launchQtCreatorCheckBox`) `{"
Add-Content $of  "    checkBoxForm.launchQtCreatorCheckBox.checked `= false`;"
Add-Content $of  "  `}"
Add-Content $of  "  gui.clickButton`(buttons.FinishButton`);"
Add-Content $of  "`}"

$pathTest = "$outFilePath\$minOutFilename"

if (Test-Path $pathTest) {
    Write-Host "  --> Validation ....... Passed `[found $minOutFilename`]"
    Write-Host " "
} else {
    GenerateError
}

# GENERATE FULL SCRIPT --------------------------------------------------------

Write-Host "* $fullOutFileText"
Write-Host " "
Write-Host "  --> Expected Path .... $outFilePath"
Write-Host "  --> Script Location .. $outFilePath\$fullOutFilename"

# install Qt Creator, QTLIBS, and GCC Tool Chain

$of = "$outFilePath\$fullOutFilename"

New-Item -Force $of > $null
Add-Content $of  "function Controller`(`) `{"
Add-Content $of  " installer.autoRejectMessageBoxes`(`)`;"
Add-Content $of  " installer.installationFinished.connect`(function`(`) `{"
Add-Content $of  "  gui.clickButton`(buttons.NextButton`)`;"
Add-Content $of  " `}`)"
Add-Content $of  "`}"
Add-Content $of  " "
Add-Content $of  "Controller.prototype.WelcomePageCallback `= function`(`) `{"
Add-Content $of  " gui.clickButton`(buttons.NextButton`, 3000`)`;"
Add-Content $of  "`}"
Add-Content $of  " "
Add-Content $of  "Controller.prototype.CredentialsPageCallback `= function`(`)`{"
Add-Content $of  " gui.clickButton`(buttons.NextButton`)`;"
Add-Content $of  "`}"
Add-Content $of  " "
Add-Content $of  "Controller.prototype.IntroductionPageCallback `= function`(`) `{"
Add-Content $of  " gui.clickButton`(buttons.NextButton`)`;"
Add-Content $of  "`}"
Add-Content $of  " "
Add-Content $of  "Controller.prototype.TargetDirectoryPageCallback `= function`(`) `{"
Add-Content $of  " gui.currentPageWidget`(`).TargetDirectoryLineEdit.setText`(`"$installDir_F`"`)`;"
Add-Content $of  " gui.clickButton`(buttons.NextButton`)`;"
Add-Content $of  "`}"
Add-Content $of  " "
Add-Content $of  "Controller.prototype.ComponentSelectionPageCallback `= function`(`) `{"
Add-Content $of  " var widget `= gui.currentPageWidget`(`)`;"
Add-Content $of  " widget.deselectAll`(`)`;"
Add-Content $of  " widget.selectComponent`(`"qt.tools.vcredist_msvc2017_x64`"`)`;"
Add-Content $of  " widget.selectComponent`(`"qt.tools.vcredist_msvc2019_x64`"`)`;"
Add-Content $of  " widget.selectComponent`(`"qt.tools.maintenance`"`)"
Add-Content $of  " widget.selectComponent`(`"qt.tools.qtcreator`"`)`;"
Add-Content $of  " widget.selectComponent`(`"qt.tools.cmake.win64`"`)`;"
Add-Content $of  " widget.selectComponent`(`"qt.tools.win64_mingw730`"`)`;"
Add-Content $of  " widget.selectComponent`(`"qt.tools.win64_mingw810`"`)`;"
Add-Content $of  " widget.selectComponent`(`"qt.qt5.51212.win64_mingw73`"`)`;"
Add-Content $of  " widget.selectComponent`(`"qt.qt5.5152.win64_mingw81`"`)`;"
Add-Content $of  " widget.selectComponent`(`"qt.qt6.622.win64_mingw81`"`)`;"
Add-Content $of  " gui.clickButton`(buttons.NextButton`)`;"
Add-Content $of  "`}"
Add-Content $of  " "
Add-Content $of  "Controller.prototype.LicenseAgreementPageCallback `= function`(`) `{"
Add-Content $of  " gui.currentPageWidget`(`).AcceptLicenseRadioButton.setChecked`(true`)`;"
Add-Content $of  " gui.clickButton`(buttons.NextButton`)`;"
Add-Content $of  "`}"
Add-Content $of  " "
Add-Content $of  "Controller.prototype.StartMenuDirectoryPageCallback `= function`(`) `{"
Add-Content $of  " gui.clickButton`(buttons.NextButton`)`;"
Add-Content $of  "`}"
Add-Content $of  " "
Add-Content $of  "Controller.prototype.ReadyForInstallationPageCallback `= function`(`)"
Add-Content $of  "`{"
Add-Content $of  "  gui.clickButton`(buttons.NextButton`)`;"
Add-Content $of  "`}"
Add-Content $of  " "
Add-Content $of  "Controller.prototype.FinishedPageCallback `= function`(`) `{"
Add-Content $of  "  var checkBoxForm `= gui.currentPageWidget`(`).LaunchQtCreatorCheckBoxForm"
Add-Content $of  "  if `(checkBoxForm `&`& checkBoxForm.launchQtCreatorCheckBox`) `{"
Add-Content $of  "    checkBoxForm.launchQtCreatorCheckBox.checked `= false`;"
Add-Content $of  "  `}"
Add-Content $of  "  gui.clickButton`(buttons.FinishButton`)`;"
Add-Content $of  "`}"

$pathTest = "$outFilePath\$fullOutFilename"
if (Test-Path $pathTest) {
    Write-Host "  --> Validation ....... Passed `[found $fullOutFilename`]"
} else {
    GenerateError
}
Write-Host " "
exit(0)