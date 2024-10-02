function Controller() {
 installer.autoRejectMessageBoxes();
 installer.installationFinished.connect(function() {
  gui.clickButton(buttons.NextButton);
 })
}
 
Controller.prototype.WelcomePageCallback = function() {
 gui.clickButton(buttons.NextButton, 3000);
}
 
Controller.prototype.CredentialsPageCallback = function(){
 gui.clickButton(buttons.NextButton);
}
 
Controller.prototype.IntroductionPageCallback = function() {
 gui.clickButton(buttons.NextButton);
}
 
Controller.prototype.TargetDirectoryPageCallback = function() {
 gui.currentPageWidget().TargetDirectoryLineEdit.setText("C:/JTSDK64-Tools/tools/Qt");
 gui.clickButton(buttons.NextButton);
}
 
Controller.prototype.ComponentSelectionPageCallback = function() {
 var widget = gui.currentPageWidget();
 widget.deselectAll();
 widget.selectComponent("qt.license.thirdparty");
 widget.selectComponent("qt.license.lgpl");
 widget.selectComponent("qt.tools.vcredist_msvc2017_x64");
 widget.selectComponent("qt.tools.vcredist_msvc2019_x64");
 widget.selectComponent("qt.tools.maintenance")
 widget.selectComponent("qt.tools.qtcreator");
 widget.selectComponent("qt.tools.cmake");
 widget.selectComponent("qt.tools.openssl");
 widget.selectComponent("qt.tools.openssl.win_x64");
 widget.selectComponent("qt.tools.win64_mingw810");
 widget.selectComponent("qt.qt5.5152.win64_mingw81");
 widget.selectComponent("qt.qt6.661");
 widget.selectComponent("qt.qt6.661.win64_mingw");
 widget.selectComponent("qt.qt6.661.qt5compat");
 widget.selectComponent("qt.qt6.661.qt5compat.win64_mingw");
 widget.selectComponent("qt.qt6.661.addons");
 widget.selectComponent("qt.qt6.661.addons.qt3d");
 widget.selectComponent("qt.qt6.661.addons.qt3d.win64_mingw");
 widget.selectComponent("qt.qt6.661.addons.qtactiveqt");
 widget.selectComponent("qt.qt6.661.addons.qtactiveqt.win64_mingw");
 widget.selectComponent("qt.qt6.661.addons.qtactiveqt");
 widget.selectComponent("qt.qt6.661.addons.qtactiveqt.win64_mingw");
 widget.selectComponent("qt.qt6.661.addons.qtcharts");
 widget.selectComponent("qt.qt6.661.addons.qtcharts.win64_mingw");
 widget.selectComponent("qt.qt6.661.addons.qtconnectivity");
 widget.selectComponent("qt.qt6.661.addons.qtconnectivity.win64_mingw");
 widget.selectComponent("qt.qt6.661.addons.qtdatavis3d");
 widget.selectComponent("qt.qt6.661.addons.qtdatavis3d.win64_mingw");
 widget.selectComponent("qt.qt6.661.addons.qtimageformats");
 widget.selectComponent("qt.qt6.661.addons.qtimageformats.win64_mingw");
 widget.selectComponent("qt.qt6.661.addons.qtlanguageserver");
 widget.selectComponent("qt.qt6.661.addons.qtlanguageserver.win64_mingw");
 widget.selectComponent("qt.qt6.661.addons.qtlottie");
 widget.selectComponent("qt.qt6.661.addons.qtlottie.win64_mingw");
 widget.selectComponent("qt.qt6.661.addons.qtmultimedia");
 widget.selectComponent("qt.qt6.661.addons.qtmultimedia.win64_mingw");
 widget.selectComponent("qt.qt6.661.addons.qtnetworkauth");
 widget.selectComponent("qt.qt6.661.addons.qtnetworkauth.win64_mingw");
 widget.selectComponent("qt.qt6.661.addons.qtpdf");
 widget.selectComponent("qt.qt6.661.addons.qtpdf.win64_mingw");
 widget.selectComponent("qt.qt6.661.addons.qtpositioning");
 widget.selectComponent("qt.qt6.661.addons.qtpositioning.win64_mingw");
 widget.selectComponent("qt.qt6.661.addons.qtremoteobjects");
 widget.selectComponent("qt.qt6.661.addons.qtremoteobjects.win64_mingw");
 widget.selectComponent("qt.qt6.661.addons.qtscxml");
 widget.selectComponent("qt.qt6.661.addons.qtscxml.win64_mingw");
 widget.selectComponent("qt.qt6.661.addons.qtsensors");
 widget.selectComponent("qt.qt6.661.addons.qtsensors.win64_mingw");
 widget.selectComponent("qt.qt6.661.addons.qtserialbus");
 widget.selectComponent("qt.qt6.661.addons.qtserialbus.win64_mingw");
 widget.selectComponent("qt.qt6.661.addons.qtserialport");
 widget.selectComponent("qt.qt6.661.addons.qtserialport.win64_mingw");
 widget.selectComponent("qt.qt6.661.addons.qtvirtualkeyboard");
 widget.selectComponent("qt.qt6.661.addons.qtvirtualkeyboard.win64_mingw");
 widget.selectComponent("qt.qt6.661.addons.qtwebchannel");
 widget.selectComponent("qt.qt6.661.addons.qtwebchannel.win64_mingw");
 widget.selectComponent("qt.qt6.661.addons.qtwebengine");
 widget.selectComponent("qt.qt6.661.addons.qtwebengine.win64_mingw");
 widget.selectComponent("qt.qt6.661.addons.qtwebsockets");
 widget.selectComponent("qt.qt6.661.addons.qtwebsockets.win64_mingw");
 widget.selectComponent("qt.qt6.661.addons.qtwebview");
 widget.selectComponent("qt.qt6.661.addons.qtwebview.win64_mingw");
 widget.selectComponent("qt.qt6.661.debug_info");
 widget.selectComponent("qt.qt6.661.debug_info.win64_mingw");
 widget.selectComponent("qt.qt6.661.qtquick3d");
 widget.selectComponent("qt.qt6.661.qtquick3d.win64_mingw");
 widget.selectComponent("qt.qt6.661.qtquicktimeline");
 widget.selectComponent("qt.qt6.661.qtquicktimeline.win64_mingw");
 widget.selectComponent("qt.qt6.661.qtshadertools");
 widget.selectComponent("qt.qt6.661.qtshadertools.win64_mingw");
 widget.selectComponent("qt.tools.windows_kits_debuggers");
 gui.clickButton(buttons.NextButton);
}
 
Controller.prototype.LicenseAgreementPageCallback = function() {
 gui.currentPageWidget().AcceptLicenseRadioButton.setChecked(true);
 gui.clickButton(buttons.NextButton);
}
 
Controller.prototype.StartMenuDirectoryPageCallback = function() {
 gui.clickButton(buttons.NextButton);
}
 
Controller.prototype.ReadyForInstallationPageCallback = function()
{
  gui.clickButton(buttons.NextButton);
}
 
Controller.prototype.FinishedPageCallback = function() {
  var checkBoxForm = gui.currentPageWidget().LaunchQtCreatorCheckBoxForm
  if (checkBoxForm && checkBoxForm.launchQtCreatorCheckBox) {
    checkBoxForm.launchQtCreatorCheckBox.checked = false;
  }
  gui.clickButton(buttons.FinishButton);
}
