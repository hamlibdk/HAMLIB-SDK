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
 widget.selectComponent("qt.tools.vcredist_msvc2017_x64");
 widget.selectComponent("qt.tools.vcredist_msvc2019_x64");
 widget.selectComponent("qt.tools.maintenance")
 widget.selectComponent("qt.tools.qtcreator");
 widget.selectComponent("qt.tools.cmake.win64");
 widget.selectComponent("qt.tools.win64_mingw730");
 widget.selectComponent("qt.qt5.51212.win64_mingw73");
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
