#-----------------------------------------------------------------------------#
# Name .........: Generate-JSQt.ps1
# Project ......: Part of the JTSDK64 Tools Project
# Version ......: 4.0 Alpha
# Description ..: Downloads the latest Qt Installer
# Usage ........: Call this file directly from the command line
#
# Concept ......: Greg, Beam, KI7MT, <ki7mt@yahoo.com>
# Author .......: Hamlib SDK Contributors <hamlibdk@hotmail.com>
# Copyright ....: Copyright (C) 2013-2021 Greg Beam, KI7MT
#               : (C) 2020 - 2023 Hamlib SDK Contributors
# License ......: GPL-3
#
# Usage of files created:
#
#      Minimal Install
#      qt-unified-windows-x64-online.exe --script .\qt-min-install.qs
#
#      Full Install
#      qt-unified-windows-x64-online.exe --script .\qt-full-install.qs
#
# Updated for Qt 5.15.2 as default Steve VK3VM 18-5-2022
# Major maintenance for Qt 6.3.1; 5.12.12 references removed Steve VK3VM 7-8-2022
# Minor maintenance for Qt 6.3.2 Steve VK3VM 07-8-2022
# Minor maintenance for Qt 6.5.0 Steve VK3VM 10-4-2023
# Minor maintenance for Qt 6.5.1 Coordinated by Steve VK3VM 02-6-2023
# Bump to Version 4.0: Incorporation of QT5_VER and QT6_VER variables Coordinated by Steve VK3VM 04-6-2023
# --> The versions of Qt deployed now set inside Versions.ini. Maintenance now reduced.
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
    $env:JTSDK_HOME = $env:SystemDrive + "\JTSDK64-Tools"
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

$qt5ver=$env:QT5_VER.replace(".","")
$qt6ver=$env:QT6_VER.replace(".","")

# -----------------------------------------------------------------
#  INSTALL SECTION
# -----------------------------------------------------------------

# Write-Host " "
Write-Host "-----------------------------------------------------"
Write-Host " Generate QT Install Scripts"
Write-Host "-----------------------------------------------------"
Write-Host " "
Write-Host "* Qt Versions to be deployed - Read from Versions.ini"
Write-Host " "
Write-Host "  --> Qt 5 Deployment .. $env:QT5_VER"
Write-Host "  --> Qt 6 Deployment .. $env:QT6_VER"
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
Add-Content $of  " widget.selectComponent`(`"qt.license.thirdparty`"`)`;"
Add-Content $of  " widget.selectComponent`(`"qt.license.lgpl`"`)`;"
Add-Content $of  " widget.selectComponent`(`"qt.tools.vcredist_msvc2017_x64`"`)`;"
Add-Content $of  " widget.selectComponent`(`"qt.tools.vcredist_msvc2019_x64`"`)`;"
Add-Content $of  " widget.selectComponent`(`"qt.tools.maintenance`"`)"
Add-Content $of  " widget.selectComponent`(`"qt.tools.qtcreator`"`)`;"
Add-Content $of  " widget.selectComponent`(`"qt.tools.cmake`"`)`;"
Add-Content $of  " widget.selectComponent`(`"qt.tools.openssl.win_x64`"`)`;"
Add-Content $of  " widget.selectComponent`(`"qt.tools.win64_mingw810`"`)`;"
#Add-Content $of  " widget.selectComponent`(`"qt.qt5.5152.win64_mingw81`"`)`;"
Add-Content $of  " widget.selectComponent`(`"qt.qt5.$qt5ver.win64_mingw81`"`)`;"
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
    Write-Host "  --> Script Validation: Passed `[found $minOutFilename`]"
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
Add-Content $of  " widget.selectComponent`(`"qt.license.thirdparty`"`)`;"
Add-Content $of  " widget.selectComponent`(`"qt.license.lgpl`"`)`;"
Add-Content $of  " widget.selectComponent`(`"qt.tools.vcredist_msvc2017_x64`"`)`;"
Add-Content $of  " widget.selectComponent`(`"qt.tools.vcredist_msvc2019_x64`"`)`;"
Add-Content $of  " widget.selectComponent`(`"qt.tools.maintenance`"`)"
Add-Content $of  " widget.selectComponent`(`"qt.tools.qtcreator`"`)`;"
Add-Content $of  " widget.selectComponent`(`"qt.tools.cmake`"`)`;"
Add-Content $of  " widget.selectComponent`(`"qt.tools.openssl`"`)`;"
Add-Content $of  " widget.selectComponent`(`"qt.tools.openssl.win_x64`"`)`;"
Add-Content $of  " widget.selectComponent`(`"qt.tools.win64_mingw810`"`)`;"
Add-Content $of  " widget.selectComponent`(`"qt.qt5.$qt5ver.win64_mingw81`"`)`;"

Add-Content $of  " widget.selectComponent`(`"qt.qt6.$qt6ver`"`)`;"
Add-Content $of  " widget.selectComponent`(`"qt.qt6.$qt6ver.win64_mingw`"`)`;"
# Add-Content $of  " widget.selectComponent`(`"qt.tools.win64_mingw900`"`)`;"
Add-Content $of  " widget.selectComponent`(`"qt.qt6.$qt6ver.qt5compat`"`)`;"
Add-Content $of  " widget.selectComponent`(`"qt.qt6.$qt6ver.qt5compat.win64_mingw`"`)`;"
Add-Content $of  " widget.selectComponent`(`"qt.qt6.$qt6ver.addons`"`)`;"
Add-Content $of  " widget.selectComponent`(`"qt.qt6.$qt6ver.addons.qt3d`"`)`;"
Add-Content $of  " widget.selectComponent`(`"qt.qt6.$qt6ver.addons.qt3d.win64_mingw`"`)`;"
Add-Content $of  " widget.selectComponent`(`"qt.qt6.$qt6ver.addons.qtactiveqt`"`)`;"
Add-Content $of  " widget.selectComponent`(`"qt.qt6.$qt6ver.addons.qtactiveqt.win64_mingw`"`)`;"
Add-Content $of  " widget.selectComponent`(`"qt.qt6.$qt6ver.addons.qtactiveqt`"`)`;"
Add-Content $of  " widget.selectComponent`(`"qt.qt6.$qt6ver.addons.qtactiveqt.win64_mingw`"`)`;"
Add-Content $of  " widget.selectComponent`(`"qt.qt6.$qt6ver.addons.qtcharts`"`)`;"
Add-Content $of  " widget.selectComponent`(`"qt.qt6.$qt6ver.addons.qtcharts.win64_mingw`"`)`;"
Add-Content $of  " widget.selectComponent`(`"qt.qt6.$qt6ver.addons.qtconnectivity`"`)`;"
Add-Content $of  " widget.selectComponent`(`"qt.qt6.$qt6ver.addons.qtconnectivity.win64_mingw`"`)`;"
Add-Content $of  " widget.selectComponent`(`"qt.qt6.$qt6ver.addons.qtdatavis3d`"`)`;"
Add-Content $of  " widget.selectComponent`(`"qt.qt6.$qt6ver.addons.qtdatavis3d.win64_mingw`"`)`;"
Add-Content $of  " widget.selectComponent`(`"qt.qt6.$qt6ver.addons.qtimageformats`"`)`;"
Add-Content $of  " widget.selectComponent`(`"qt.qt6.$qt6ver.addons.qtimageformats.win64_mingw`"`)`;"
Add-Content $of  " widget.selectComponent`(`"qt.qt6.$qt6ver.addons.qtlanguageserver`"`)`;"
Add-Content $of  " widget.selectComponent`(`"qt.qt6.$qt6ver.addons.qtlanguageserver.win64_mingw`"`)`;"
Add-Content $of  " widget.selectComponent`(`"qt.qt6.$qt6ver.addons.qtlottie`"`)`;"
Add-Content $of  " widget.selectComponent`(`"qt.qt6.$qt6ver.addons.qtlottie.win64_mingw`"`)`;"
Add-Content $of  " widget.selectComponent`(`"qt.qt6.$qt6ver.addons.qtmultimedia`"`)`;"
Add-Content $of  " widget.selectComponent`(`"qt.qt6.$qt6ver.addons.qtmultimedia.win64_mingw`"`)`;"
Add-Content $of  " widget.selectComponent`(`"qt.qt6.$qt6ver.addons.qtnetworkauth`"`)`;"
Add-Content $of  " widget.selectComponent`(`"qt.qt6.$qt6ver.addons.qtnetworkauth.win64_mingw`"`)`;"
Add-Content $of  " widget.selectComponent`(`"qt.qt6.$qt6ver.addons.qtpdf`"`)`;"
Add-Content $of  " widget.selectComponent`(`"qt.qt6.$qt6ver.addons.qtpdf.win64_mingw`"`)`;"
Add-Content $of  " widget.selectComponent`(`"qt.qt6.$qt6ver.addons.qtpositioning`"`)`;"
Add-Content $of  " widget.selectComponent`(`"qt.qt6.$qt6ver.addons.qtpositioning.win64_mingw`"`)`;"
Add-Content $of  " widget.selectComponent`(`"qt.qt6.$qt6ver.addons.qtremoteobjects`"`)`;"
Add-Content $of  " widget.selectComponent`(`"qt.qt6.$qt6ver.addons.qtremoteobjects.win64_mingw`"`)`;"
Add-Content $of  " widget.selectComponent`(`"qt.qt6.$qt6ver.addons.qtscxml`"`)`;"
Add-Content $of  " widget.selectComponent`(`"qt.qt6.$qt6ver.addons.qtscxml.win64_mingw`"`)`;"
Add-Content $of  " widget.selectComponent`(`"qt.qt6.$qt6ver.addons.qtsensors`"`)`;"
Add-Content $of  " widget.selectComponent`(`"qt.qt6.$qt6ver.addons.qtsensors.win64_mingw`"`)`;"
Add-Content $of  " widget.selectComponent`(`"qt.qt6.$qt6ver.addons.qtserialbus`"`)`;"
Add-Content $of  " widget.selectComponent`(`"qt.qt6.$qt6ver.addons.qtserialbus.win64_mingw`"`)`;"
Add-Content $of  " widget.selectComponent`(`"qt.qt6.$qt6ver.addons.qtserialport`"`)`;"
Add-Content $of  " widget.selectComponent`(`"qt.qt6.$qt6ver.addons.qtserialport.win64_mingw`"`)`;"
Add-Content $of  " widget.selectComponent`(`"qt.qt6.$qt6ver.addons.qtvirtualkeyboard`"`)`;"
Add-Content $of  " widget.selectComponent`(`"qt.qt6.$qt6ver.addons.qtvirtualkeyboard.win64_mingw`"`)`;"
Add-Content $of  " widget.selectComponent`(`"qt.qt6.$qt6ver.addons.qtwebchannel`"`)`;"
Add-Content $of  " widget.selectComponent`(`"qt.qt6.$qt6ver.addons.qtwebchannel.win64_mingw`"`)`;"
Add-Content $of  " widget.selectComponent`(`"qt.qt6.$qt6ver.addons.qtwebengine`"`)`;"
Add-Content $of  " widget.selectComponent`(`"qt.qt6.$qt6ver.addons.qtwebengine.win64_mingw`"`)`;"
Add-Content $of  " widget.selectComponent`(`"qt.qt6.$qt6ver.addons.qtwebsockets`"`)`;"
Add-Content $of  " widget.selectComponent`(`"qt.qt6.$qt6ver.addons.qtwebsockets.win64_mingw`"`)`;"
Add-Content $of  " widget.selectComponent`(`"qt.qt6.$qt6ver.addons.qtwebview`"`)`;"
Add-Content $of  " widget.selectComponent`(`"qt.qt6.$qt6ver.addons.qtwebview.win64_mingw`"`)`;"
Add-Content $of  " widget.selectComponent`(`"qt.qt6.$qt6ver.debug_info`"`)`;"
Add-Content $of  " widget.selectComponent`(`"qt.qt6.$qt6ver.debug_info.win64_mingw`"`)`;"
Add-Content $of  " widget.selectComponent`(`"qt.qt6.$qt6ver.qtquick3d`"`)`;"
Add-Content $of  " widget.selectComponent`(`"qt.qt6.$qt6ver.qtquick3d.win64_mingw`"`)`;"
Add-Content $of  " widget.selectComponent`(`"qt.qt6.$qt6ver.qtquicktimeline`"`)`;"
Add-Content $of  " widget.selectComponent`(`"qt.qt6.$qt6ver.qtquicktimeline.win64_mingw`"`)`;"
Add-Content $of  " widget.selectComponent`(`"qt.qt6.$qt6ver.qtshadertools`"`)`;"
Add-Content $of  " widget.selectComponent`(`"qt.qt6.$qt6ver.qtshadertools.win64_mingw`"`)`;"
Add-Content $of  " widget.selectComponent`(`"qt.tools.windows_kits_debuggers`"`)`;"
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
    Write-Host "  --> Script Validation: Passed `[found $fullOutFilename`]"
} else {
    GenerateError
}
Write-Host " "
exit(0)