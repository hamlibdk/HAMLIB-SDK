# -----------------------------------------------------------------------------
# Name ..............: jtbuild.ps1
# Version ...........: 3.2.2 
# Description .......: Build script for WSJT-X, JTDX and JS8CALL
# Concept ...........: Greg, Beam, KI7MT, <ki7mt@yahoo.com>
# Author ............: JTSDK Contributors 20-01-2021 -> 10-09-2021
# Copyright .........: Copyright (C) 2018-2021 Greg Beam, KI7MT
#                      Copyright (C) 2018-2022 JTSDK Contributors
# License ...........: GPL-3
#
# jtbuild.cmd adjustments: Steve VK3VM to work with JTSDK 3.1 12-04 --> 03-01-2021
#
# # Code is capable of auto-downloading from a WSJTX, JTDX or JS8CALL repository
# based on flag [ src-wsjtx | src-jtdx | src-js8call ] in C:\JTSDK64-Tools\config
# 
# Stage 1 objectives (PowerShell conversion; refactoring; prime functionality; 
# Qt-independence) commenced 20-1-2020. Objectives met 29-01-2021 (Steve VK3VM)
#
# Stage 2 Objectives (Command Line switches to disable GIT and Configure steps)
# commenced 10/09/2021 with main objectives met 10/09/2021 (Steve VK3VM)
#
# jtbuild.ps1 is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free
# Software Foundation either version 3 of the License, or (at your option) any
# later version. 
#
# This script is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
# details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#-----------------------------------------------------------------------------#

# ---------------------------------------------------------------- THIS IS THE END !!!
function TheEnd($code) {

	#Push-Location $env:JTSDK_TOOLS\msys64\usr\bin
	#Rename-Item $env:JTSDK_TOOLS\msys64\usr\bin\sh-bak.exe $env:JTSDK_TOOLS\msys64\usr\bin\sh.exe | Out-Null
	#Pop-Location

	exit($code)
}

# ----------------------------------------------------------------- CHECK JT_SRC IS ALIGNED WITH MARKER
function AlignJT_SRCWithMarker {
	
	$nbrSrcMarkers = (Get-ChildItem -Path $env:JTSDK_CONFIG -filter "src-*" | Measure-Object).Count
	
	if ($nbrSrcMarkers -gt 1) { GenerateError("Multiple Source Markers Exist")}
	
	$listSrcDeploy = Get-ChildItem -Path $env:JTSDK_CONFIG -EA SilentlyContinue
	$subPathSrcStore = "NULL";
	ForEach ($subPathSrc in $listSrcDeploy)
	{    
		if ($subPathSrc.Name -like 'src*') {
			Write-Host "* Aligning `$env`:JT_ENV with selection marker"
			Write-Host ""
			$subPathSrcStore = $subPathSrc
			$env:JT_SRC = $subPathSrc.Name.substring(4)
			break
		}
	}
}

# ---------------------------------------------------------------- COMMENCE BUILD
function CommenceBuildMessage {
	
	Write-Host ""
	Write-Host "--------------------------------------------"
	Write-Host " Commencing Build of JT- Source"
	Write-Host "--------------------------------------------"
	Write-Host ""
}

# ---------------------------------------------------------------- RESTART ENVIRONMENT
function RestartEnvironMessage {
	Param ($retCode)
	Write-Host ""
	Write-Host "--------------------------------------------"
	Write-Host " **** PLEASE RESTART ALL ENVIRONMENTS ****"
	Write-Host "--------------------------------------------"
	Write-Host ""
	TheEnd($retCode)
}

# ---------------------------------------------------------------- PROCESS OPTIONS
# - Refactor for use of a switch construct - Al AB2ZY
# - Improved 10/9/2021 to handle -nc (no config) and -ng (no git pull) options
	
# Call: ProcessOptions $aarg -rcopt ([ref]$copt) -rtopt ([ref]$topt) -rcgopt ([ref]$ncg) -rgopt ([ref]$ngp)	
	
function ProcessOptions {
	Param ($aarg, [ref]$rcopt, [ref]$rtopt, [ref]$rcgopt, [ref]$rgopt)
	$mainOptionFlag=0
	$count=0
	if ( -not ([string]::IsNullOrEmpty($aarg))) { 
		$charArray =$aarg.Split(" ")

		while ($count -lt $charArray.count) {
			
			switch($charArray[$count])
			{
				"rconfig" { 
					$rcopt.Value="Release"
					$rtopt.Value="Config"
					$mainOptionFlag=1
				}
				"dconfig" { 
					$rcopt.Value="Debug"
					$rtopt.Value="Config"
					$mainOptionFlag=1
				}
				"rinstall" { 
					$rcopt.Value="Release"
					$rtopt.Value="Install"
					$mainOptionFlag=1
				}
				"dinstall" { 
					$rcopt.Value="Debug"
					$rtopt.Value="Install"
					$mainOptionFlag=1
				}
				"package" { 
					$rcopt.Value="Release"
					$rtopt.Value="Package"
					$mainOptionFlag=1
				}
				"docs" { 
					$rcopt.Value="Release"
					$rtopt.Value="Docs"
					$mainOptionFlag=1
				}
				"-nc" { $rcgopt.Value = "T" }
				"-ng" { $rgopt.Value = "T" }
				"zero" { HelpOptions } 
				"-h" { HelpOptions } 
				"help" { HelpOptions }
				$null { HelpOptions } 
				default { HelpOptions }
			}
			
			$count++
		}
	} else {
		HelpOptions
	}
	
	if ( $mainOptionFlag -eq 0) { HelpOptions }
}

# ---------------------------------------------------------------- DOWNLOAD SOURCE
# If no switch in $env:JTSDK_CONFIG src-wsjtx is set for you !
# setting src-null in env:JTSDK_TMP forces a pull-down !
function DownloadSource {
	Param ($srcd, $pullUpdates)
	
	$nbrSrcMarkers = (Get-ChildItem -Path $env:JTSDK_CONFIG -filter "src-*" | Measure-Object).Count
	[bool]$bypassFlag = $false
	
	if ($nbrSrcMarkers -gt 1) { GenerateError("Multiple Source Markers Exist")}
	
	# Option if no source directory or source marker exists: set to WSJT-X
	if ((!(Test-Path $srcd)) -and ($nbrSrcMarkers -eq 0)) { 
		# Write-Host ""
		Write-Host "* No source directory detected."
		Remove-Item "$env:JTSDK_TMP\*" -include src-* | Out-Null
		Out-File -FilePath "$env:JTSDK_TMP\src-null" | Out-Null
		$env:JT_SRC="wsjtx"			# Needed to over-ride None for source on first-run
		Write-Host ""
		Write-Host "  --> Pulling down WSJTX as a default"
		SelectionChanged("src-wsjtx")
		$bypassFlag = $true
	}
	
	if ($bypassFlag -eq $false) {
	
		# Option if no source directory exists but WSJTX marker Exists
		if ((!(Test-Path $srcd)) -and (Test-Path $env:JTSDK_CONFIG\src-wsjtx)) { 
			# Write-Host ""
			Write-Host "* No source directory detected but WSJTX Marker Found"
			Remove-Item "$env:JTSDK_TMP\*" -include src-* | Out-Null
			Out-File -FilePath "$env:JTSDK_TMP\src-null" | Out-Null
			SelectionChanged("src-wsjtx")
			$bypassFlag = $true
		}
		
		# Option if no source directory exists but JTDX marker Exists
		if ((!(Test-Path $srcd)) -and (Test-Path $env:JTSDK_CONFIG\src-jtdx)) { 
			# Write-Host ""
			Write-Host "* No source directory detected but JTDX Marker Found"
			Remove-Item "$env:JTSDK_TMP\*" -include src-* | Out-Null
			Out-File -FilePath "$env:JTSDK_TMP\src-null" | Out-Null
			SelectionChanged("src-jtdx")
			$bypassFlag = $true
		}
		
		# Option if no source directory exists but JS8CALL marker Exists
		if ((!(Test-Path $srcd)) -and (Test-Path $env:JTSDK_CONFIG\src-js8call)) { 
			# Write-Host ""
			Write-Host "* No source directory detected but JS8CALL Marker Found"
			Remove-Item "$env:JTSDK_TMP\*" -include src-* | Out-Null
			Out-File -FilePath "$env:JTSDK_TMP\src-null" | Out-Null
			SelectionChanged("src-js8call")
			$bypassFlag = $true
		}
		
		# Source selection changed detection block - Only executed if $bypassFlag is false
		if (!($bypassFlag)) {
			 
			if ((Test-Path $env:JTSDK_CONFIG\src-wsjtx)) { 
				if (!(Test-Path $env:JTSDK_TMP\src-wsjtx)) { 
					SelectionChanged("src-wsjtx") 
				} 
			} else { 
				if ((Test-Path $env:JTSDK_CONFIG\src-jtdx))  { 
					if (!(Test-Path $env:JTSDK_TMP\src-jtdx)) { 
						SelectionChanged("src-jtdx") 
					}			
				} else {
					if ((Test-Path $env:JTSDK_CONFIG\src-js8call))  { 
						if (!(Test-Path $env:JTSDK_TMP\src-js8call)) { 
							SelectionChanged("src-js8call") 		
						}
					}
				}
			}
		}
	}
	
	if (Test-Path $env:JTSDK_CONFIG\src-none) {
		$pullUpdates = "No"
	}
	
	if ($pullUpdates -ne "No") {
		Write-Host "* Performing a source update check"
		write-Host ""
		# Ensure source is latest with a git pull
		Set-Location -Path $srcd | Out-Null
		git pull
		write-Host ""
	} else {
		Write-Host "* Source update checking disabled"
		Write-Host ""
	}
}

# ---------------------------------------------------------------- GENERATE ERROR
function GenerateError($type) {
	Write-Host "*** Error: $type ***"
	Write-Host "*** Report error to JTSDK@Groups.io *** "
	Write-Host ""
	TheEnd(-1)
}

# ---------------------------------------------------------------- CLONE SOURCE 
function CloneSource {
	Param($jtSrc, $url)	
	$upperJtSrc=($jtSrc).ToUpper()
	
	if ( $upperJTSrc -eq "NONE" ) { $upperJTSrc = "WSJTX"}		# A special case for messages !

	Write-Host ""
	Write-Host "* Downloading $upperJTSrc from Home Repository"
	Write-Host ""
	Set-Location $env:JTSDK_TMP
	Write-Host "URL...: $url"
	git clone $url $srcd
	Remove-Item "$env:JTSDK_TMP\src*"
	Write-Host ""
	Write-Host "* $upperJTSrc set as Previous"
	Write-Host ""	
	Out-File -FilePath "$env:JTSDK_TMP\src-$jtSrc" | Out-Null
}

# ---------------------------------------------------------------- SOURCE SELECTION CHANGED
function SelectionChanged {
	Param ($selection)
	# Source selection has changed so delete old source
	if ((Test-Path $env:JTSDK_TMP\wsjtx)) {
		# Write-Host ""
		Write-Host -NoNewline "* Deleting Original Source: " 
		#Remove-Item $env:JTSDK_HOME\tmp\wsjtx -Recurse -Force | Out-Null
		Remove-Item $srcd -Recurse -Force | Out-Null
		Write-Host "Done"
	} else {
		# prepare to write a source marker if none exists
		$nbrSrcMarkers = (Get-ChildItem -Path $env:JTSDK_CONFIG -filter "src-*" | Measure-Object).Count
		if ($nbrSrcMarkers -eq 0) {
			Write-Host "  --> Setting configuration marker for wsjtx"
			Out-File -FilePath "$env:JTSDK_CONFIG\src-wsjtx"
		}
	}

	if ($selection -eq "src-wsjtx") { CloneSource -jtSrc $env:JT_SRC -url "git://git.code.sf.net/p/wsjt/wsjtx" }
	if ($selection -eq "src-jtdx") { CloneSource -jtSrc $env:JT_SRC -url "https://github.com/jtdx-project/jtdx.git" }
	if ($selection -eq "src-js8call") { CloneSource -jtSrc $env:JT_SRC -url "https://widefido@bitbucket.org/widefido/js8call.git" }	
}

# ---------------------------------------------------------------- NO SOURCE
function NoSourceMarker {
	Write-Host ""
	Write-Host "--------------------------------------------"
	Write-Host " NO SOURCE SELECTION MARKER FILE"
	Write-Host "--------------------------------------------"
	Write-Host ""
	Write-Host " Place ONE of the following marker files in:" 
	Write-Host " $env:JTSDK_CONFIG"
	Write-Host ""
	Write-Host "` - src-wsjtx ... Pull git package for WSJT-X "   
	Write-Host "` - src-jtdx .... Pull git package for JTDX"
	Write-Host "` - src-js8call . Pull git package for JS8CALL"
	Write-Host ""
	TheEnd(-1)
}

# ---------------------------------------------------------------- CMAKE ERROR
function ErrorCMake {
	Write-Host ""
	Write-Host "--------------------------------------------"
	Write-Host " CMAKE BUILD ERROR"
	Write-Host "--------------------------------------------"
	Write-Host ""
	Write-Host " There was a problem building `( $desc `)"
	Write-Host ""
	Write-Host " Check the screen for error messages."
	Write-Host ""
	Write-Host " Correct the issue then try to re-build."
	Write-Host ""
	Write-Host ""
	TheEnd(-1)
}

# ---------------------------------------------------------------- HELP OPTIONS
function HelpOptions {
	Write-Host ""
	Write-Host "--------------------------------------------"
	Write-Host " Default Build Commands"
	Write-Host "--------------------------------------------"
	Write-Host ""
	Write-Host " Usage .....`: jtbuild `[ OPTION `] `[`[ SWITCH `]`]"
	Write-Host ""
	Write-Host " Examples...`: jtbuild rinstall"
	Write-Host "            `: jtbuild rinstall -ng"
	Write-Host ""
	Write-Host " Options:"
	Write-Host ""
	Write-Host "    rconfig    Release, Config Only"
	Write-Host "    dconfig    Debug, Config Only"
	Write-Host "    rinstall   Release, Non-packaged Install"
	Write-Host "    dinstall   Debug, Non-packaged Install"
	Write-Host "    package    Release, Windows Package"
	Write-Host "    docs       Release, User Guide"
	Write-Host ""
	Write-Host " Switches:" 
	Write-Host ""
	Write-Host "    Switches only work if an `[ OPTION `] is supplied."
	Write-Host ""
	Write-Host "    -nc        Do not run configure"
	Write-Host "    -ng        Do not check`/pull source"
	Write-Host ""
	Write-Host " * To Display this message, type .....`: jtbuild `-h"
	Write-Host ""
	TheEnd(0)
}

# ---------------------------------------------------------------- BUILD INFORMATION
function BuildInformation {
	Write-Host "--------------------------------------------"
	Write-Host " Build Information"
	Write-Host "--------------------------------------------"
	Write-Host ""
	Write-Host "  Description ...`: $desc"
	Write-Host "  Version .......`: $aver"
	Write-Host "  Type ..........`: $copt"
	Write-Host "  Target ........`: $topt"
	Write-Host "  Tool Chain ....`: $qtv"
	Write-Host "  SRC ...........`: $srcd"
	Write-Host "  Build .........`: $buildd"
	Write-Host "  Install .......`: $installd"
	Write-Host "  Package .......`: $pkgd"
	Write-Host "  TC File .......`: $tchain"
	Write-Host "  Clean .........`: $cleanFirst"
	Write-Host "  Reconfigure ...`: $reconfigure"
	# Write-Host ""
}

# --------------------------------------------------------------- CONFIGURATION ONLY
function ConfigOnly {

	Set-Location -Path $buildd
	Write-Host ""
	Write-Host "--------------------------------------------"
	Write-Host " Configuring Build Tree"
	Write-Host "--------------------------------------------"
	Write-Host ""
	cmake -G "MinGW Makefiles" -Wno-dev -D CMAKE_TOOLCHAIN_FILE=$tchain `
		-D CMAKE_COLOR_MAKEFILE=OFF `
		-D CMAKE_BUILD_TYPE=$copt `
		-D CMAKE_INSTALL_PREFIX=$installd $srcd
	if ($LastExitCode -eq 1) { ErrorCMake }
	TheEnd(0)
}

# ---------------------------------------------------------------- FINISH CONFIGURATION
function FinishConfig {
	Write-Host ""
	Write-Host "--------------------------------------------"
	Write-Host " Configure Summary"
	Write-Host "--------------------------------------------"
	Write-Host ""
	Write-Host "  Description .`: $desc"
	Write-Host "  Version .....`: $aver"
	Write-Host "  Type ........`: $copt"
	Write-Host "  Target ......`: $topt"
	Write-Host "  Tool Chain ..`: $qtv"
	Write-Host "  Clean .......`: $cleanFirst"
	Write-Host "  Reconfigure .`: $reconfigure"
	Write-Host "  SRC .........`: $srcd"
	Write-Host "  Build .......`: $buildd"
	Write-Host "  Install .....`: $installd"
	Write-Host ""
	Write-Host " Config Only builds simply configure the build tree with"
	Write-Host " default options. To further configure or re-configure this build,"
	Write-Host " run the following commands:"
	Write-Host ""
	Write-Host " cd $buildd"
	Write-Host " cmake-gui ."
	Write-Host ""
	Write-Host " Once the CMake-GUI opens, click on Generate, then Configure"
	Write-Host ""
	Write-Host " You now have have a fully configured build tree."
	Write-Host ""
}

# ---------------------------------------------------------------- FINISHED UG MSG
function FinishUserGuide {
	$dn = Split-Path $docname -leaf
	Write-Host ""
	Write-Host "--------------------------------------------"
	Write-Host " User Guide Summary"
	Write-Host "--------------------------------------------"
	Write-Host ""
	Write-Host "  Name ........`: $dn"
	Write-Host "  Version .....`: $aver"
	Write-Host "  Type ........`: $copt"
	Write-Host "  Target ......`: $topt"
	Write-Host "  Tool Chain ..`: $qtv"
	Write-Host "  SRC .........`: $srcd"
	Write-Host "  Build .......`: $buildd"
	Write-Host "  Location ....`: $buildd\doc\$dn"
	Write-Host ""
	Write-Host " The user guide does *not* get installed like normal install"
	Write-Host " builds, it remains in the build folder to aid in browser"
	Write-Host " shortcuts for quicker refresh during development iterations."
	Write-Host ""
	Write-Host " The name `[ $dn `] also remains constant rather"
	Write-Host " than including the version infomation."
	Write-Host ""
	TheEnd(0)
}

# ---------------------------------------------------------------- FINISH PACKAGE MSG
function FinishPackage {
	Write-Host ""
	Write-Host "--------------------------------------------"
	Write-Host " Windows Installer Summary"
	Write-Host "--------------------------------------------"
	Write-Host ""
	Write-Host "  Name ........`: $wsjtxpkg"
	Write-Host "  Version .....`: $aver"
	Write-Host "  Type ........`: $copt"
	Write-Host "  Target ......`: $topt"
	Write-Host "  Tool Chain ..`: $qtv"
	Write-Host "  Clean .......`: $cleanFirst"
	Write-Host "  Reconfigure .`: $reconfigure"
	Write-Host "  SRC .........`: $srcd"
	Write-Host "  Build .......`: $buildd"
	Write-Host "  Location ....`: $pkgd\$wsjtxpkg"
	Write-Host ""
	Write-Host " To Install the package, browse to Location and"
	Write-Host " run as you normally do to install Windows applications."
	Write-Host ""
	TheEnd(0)
}

# ---------------------------------------------------------------- NSIS ERROR
function NSISError {
	Write-Host ""
	Write-Host "--------------------------------------------"
	Write-Host " WINDOWS INSTALLER BUILD ERROR"
	Write-Host "--------------------------------------------"
	Write-Host ""
	Write-Host " There was a problem building the package,"
	Write-Host " or the script could not find:"
	Write-Host ""
	Write-Host " $buildd\$WSJTXPKG"
	Write-Host ""
	Write-Host " Check the Cmake logs for any errors, or" 
	Write-Host " correct any build script issues that were" 
	Write-Host " obverved and try to rebuild the package."
	Write-Host ""
	TheEnd(-1)
}

# ---------------------------------------------------------------- PACKAGE TARGET FUNCTIONS
function PackageTarget {
	Set-Location -Path $buildd
	$jtSrc=($env:JT_SRC).ToUpper()
	Write-Host ""
	Write-Host "--------------------------------------------"
	Write-Host " Building $jtSrc "
	Write-Host "--------------------------------------------"
	Write-Host ""
	Write-Host "* Build Directory: $buildd"
	Write-Host ""
	
	# The following 2 lines first introduced by Steve VK3VM 30-4-2020 
	# removes an ald annoyance in final info screens !
	
	Write-Host "* Removing Old Install Packages `(if exist`)"
	Write-Host ""
	Get-childitem $buildd\* -include *.exe -recurse -force | Remove-Item
	
	# Remove-Item * -force -include *.exe | Out-Null

	Write-Host "--------------------------------------------"
	# Write-Host ""
	
	if (!(Test-Path "$buildd\Makefile")) { PackageTargetOne }
	
	if ($reconfigure -eq "Yes") {
		PackageTargetOne
	} else {
		PackageTargetTwo
	}
}

function PackageTargetOne {
	if ( $ncg -eq "F")
	{
		cmake -G "MinGW Makefiles" -Wno-dev -D CMAKE_TOOLCHAIN_FILE=$tchain `
			-D CMAKE_BUILD_TYPE=$copt `
			-D CMAKE_INSTALL_PREFIX=$pkgd $srcd
		if ($LastExitCode -ne 0) { ErrorCMake }
	}
	PackageTargetTwo
}

function PackageTargetTwo {
	$topt=($topt).ToLower()
	if ($cleanFirst -eq "Yes") { mingw32-make -f Makefile clean | Out-Null }
	Write-Host ""
	cmake --build . --target $topt -- -j $JJ
	if ($LastExitCode -ne 0) { NSISError }
	#	DIR /B $buildd\*-win64.exe >p.k & $/P wsjtxpkg=<p.k & rm p.k **** Equivalent Below ***
	$wsjtxpkg = Get-ChildItem -Path $buildd -Filter *-win64.exe | Select -First 1
	Write-Host "Copying package to`: $pkgd"
	Copy-Item -Path $buildd\$wsjtxpkg  -Destination $pkgd | Out-Null
	FinishPackage
}

# ---------------------------------------------------------------- SETUP DIRECTORIES
function SetupDirectories {
	
	Write-Host ""
	Write-Host "--------------------------------------------"
	Write-Host " Folder Locations"
	Write-Host "--------------------------------------------"
	Write-Host ""
	if (!(Test-Path "$buildd")) {  New-Item -Path "$buildd" -ItemType directory | Out-Null }
	if (!(Test-Path "$installd")) { New-Item -Path "$installd" -ItemType directory | Out-Null }
	if (!(Test-Path "$pkgd")) { New-Item -Path "$pkgd" -ItemType directory | Out-Null }
	Write-Host "  Build .........`: $buildd"
	Write-Host "  Install .......`: $installd"
	Write-Host "  Package .......`: $pkgd"
	Write-Host ""
}

# ---------------------------------------------------------------- FINISH INSTALLATION
function FinishInstall {
	Write-Host ""
	Write-Host "--------------------------------------------"
	Write-Host " Build Summary"
	Write-Host "--------------------------------------------"
	Write-Host ""
	Write-Host "  Source ........`: $env:JT_SRC"
	Write-Host "  Description ...`: $desc"
	Write-Host "  Version .......`: $aver"
	Write-Host "  Type ..........`: $copt"
	Write-Host "  Target ........`: $topt"
	Write-Host "  Tool Chain ....`: $qtv"
	Write-Host "  Clean .........`: $cleanFirst"
	Write-Host "  Reconfigure ...`: $reconfigure"
	Write-Host "  SRC ...........`: $srcd"
	Write-Host "  Build .........`: $buildd"
	Write-Host "  Install .......`: $installd"
	
	# AUTO RUN ----------------------------------------------------------- 

	if ($autorun -eq "Yes") {
		Write-Host "  JTSDK Option ..: Autorun Enabled"
		Write-Host "  Starting ......: wsjtx $aver r$sver $desc in $copt mode"
		Write-Host ""
		if ($copt -eq "Debug") {
			Write-Host ""
			Set-Location -Path "$installd\bin"
			Invoke-Expression "cmd.exe /c ./wsjtx.cmd"
			TheEnd(0)
		} else {
			Write-Host ""
			Invoke-Expression "./wsjtx.exe" 
			TheEnd(0)
		}
		TheEnd(0)	
	} else {
		Write-Host ""
		TheEnd(0)
	}
}

# ---------------------------------------------------------------- INSTALL-TARGET
function InstallTarget {
	Set-Location -Path $buildd
	Write-Host ""
	Write-Host "--------------------------------------------"
	Write-Host " Building $env:JT_SRC Install Target"
	Write-Host "--------------------------------------------"
	Write-Host ""
	if (!(Test-Path "$buildd\Makefile")) { InstallTargetOne }
	if ($reconfigure -eq "Yes") { InstallTargetOne }
	InstallTargetTwo
}

function InstallTargetOne {
	# Write-Host "* In InstallTargetOne"
	cmake -G "MinGW Makefiles" -Wno-dev -D CMAKE_TOOLCHAIN_FILE=$tchain `
		-D CMAKE_BUILD_TYPE=$copt `
		-D CMAKE_COLOR_MAKEFILE=OFF `
		-D CMAKE_INSTALL_PREFIX=$installd $srcd
	if ($LastExitCode -ne 0) { ErrorCMake }
	InstallTargetTwo
}

function InstallTargetTwo {
	# Write-Host "* In InstallTargetTwo"
	$topt=($topt).ToLower()
	if ($cleanFirst -eq "Yes") { mingw32-make -f Makefile clean | Out-Null }
	cmake --build . --target $topt -- -j $JJ
	if ($LastExitCode -ne 0) { ErrorCMake }
	if ($copt -eq "Debug") { InstallTargetThree }
	FinishInstall
}

# DEBUG MAKE BATCH FILE ------------------------------------------ DEBUG BATCH FILE
function InstallTargetThree {
	# Write-Host "* In InstallTargetThree"
	Write-Host -NoNewLine "* Generating Debug Batch File ... "
	Set-Location -Path "$installd\bin"
	$of="wsjtx.cmd"
	if ((Test-Path $of)) { 	Remove-Item -Path $of -Force  }

	New-Item -Force $of > $null

	Add-Content $of "@ECHO OFF"
	Add-Content $of "REM -- Debug Batch File"
	Add-Content $of "REM -- Part of the JTSDK v2.0 Project"
	Add-Content $of "SETLOCAL"
	Add-Content $of "TITLE WSJT-X Debug Terminal"
	Add-Content $of "$PATH=.;.\data;.\doc;$fft;$gccd;$qt5d;$qt5a;$qt5p;$hl3"
	Add-Content $of "CALL wsjtx.exe"
	Add-Content $of "CD /D $dest"
	Add-Content $of "ENDLOCAL"
	Add-Content $of "COLOR 0B"
	Add-Content $of "EXIT /B 0"
	
	Write-Host "Complete"
	
	FinishInstall
}

# ---------------------------------------------------------------- USER GUIDE
function DocsTarget {
	Set-Location -Path $buildd
	Write-Host ""
	Write-Host "--------------------------------------------"
	Write-Host " Building $env:JT_SRC User Guide"
	Write-Host "--------------------------------------------"
	Write-Host ""
	if (!(Test-Path "$buildd\Makefile")) { DocsTargetOne }
	if ($reconfigure -eq "Yes") { DocsTargetOne }
	DocsTargetTwo
}

function DocsTargetOne {
	# Write-Host "* In DocsTargetOne"
	cmake -G "MinGW Makefiles" -Wno-dev -D CMAKE_TOOLCHAIN_FILE=$tchain `
		-D CMAKE_BUILD_TYPE=$copt `
		-D CMAKE_INSTALL_PREFIX=$installd $srcd
	if ($LastExitCode -ne 0) { ErrorCMake }
	DocsTargetTwo
}

function DocsTargetTwo {
	# Write-Host "* In DocsTargetTwo"
	if ($cleanFirst -eq "Yes") { mingw32-make -f Makefile clean | Out-Null }
	cmake --build . --target docs
	if ($LastExitCode -ne 0) { ErrorCMake }
	if ($copt -eq "Debug") { InstallTargetThree }
	# DIR /B $buildd\doc\*.html >d.n & $/P docname=<d.n & rm d.n
	$docname = Get-ChildItem -Path "$buildd\doc\*.html" -Filter *.html | Select -First 1

	FinishUserGuide
}

# ---------------------------------------------------------------- GET VERSION DATA
# Source is either from CMakeLists.txt or from Versions.cmake
function GetVersionData ([ref]$rmav, [ref]$rmiv, [ref]$rpav, [ref]$rrcx, [ref]$rrelx) {
	Write-Host "* Obtaining Source Version Data"
	Write-Host ""
	if (!(Test-Path "$env:JTSDK_TMP\wsjtx\Versions.cmake")) {  # From CMakeList.txt ---------------
		$mlConfig = Get-Content $env:JTSDK_TMP\wsjtx\CMakeLists.txt
		Write-Host "  --> Source ....: $env:JTSDK_TMP\wsjtx\CMakeLists.txt"
		[Int]$count = 0
		foreach ($line in $mlConfig) {
			[Bool] $incCont = 0
			if (($line.trim() |  Select-String -Pattern "\d{1,3}(\.\d{1,3}){3}" -AllMatches).Matches.Value) {
				$temp = ($line  |  Select-String -Pattern "\d{1,3}(\.\d{1,3}){3}" -AllMatches).Matches.Value
				#Write-Host "  --> Raw Version data: $temp"
				$verArr = @($temp.split('.'))
				$rmav.value = $verArr[0]
				$rmiv.value = $verArr[1]
				$rpav.value = $verArr[2]
				$rrelx.value = $verArr[3]
				$incCount = 1
			}
			
			if ($line -like 'set_build_type*') {
				$rrcx.value = ($line) -replace "[^0-9]" , ''
				$incCount = 1
			}
			if ($incCount -eq 1) { $count++ }
		}
		
		# Write-Host 	$rmav.value $rmiv.value $rpav.value $rrelx.value

		if ($count -eq 0) { Write-Host "" }

		try { 
			if ($verArr[0] -eq 0) { GenerateError("Data not read from CMakeLists.txt" ) } 
		}
		catch { 
			GenerateError("Unable to read data from $env:JTSDK_TMP\wsjtx\CMakeList.txt") 
		}
	} else {	# From Versions.cmake -------------------------------------------------------------
		$vcConfig = Get-Content $env:JTSDK_TMP\wsjtx\Versions.cmake
		Write-Host "  --> Source ....: $env:JTSDK_TMP\wsjtx\Versions.cmake"
		[Int]$count = 0
		foreach ($line in $vcConfig) {
			if ($line -like '*WSJTX_VERSION_MAJOR*') {
				$rmav.value = ($line) -replace "[^0-9]" , ''
			}
			if ($line -like '*WSJTX_VERSION_MINOR*') {
				$rmiv.value = ($line) -replace "[^0-9]" , ''
			}
			if ($line -like '*WSJTX_VERSION_PATCH*') {
				$rpav.value = ($line) -replace "[^0-9]" , ''
			}
			if ($line -like '*#set (WSJTX_RC*') {
				Write-Host "  --> Development Version: `[WSJTX_RC Disabled`]"
			} else {   # This logic handles possible line with bad structure or changed data
				if ($line -like '*WSJTX_RC*') {
					$rrelx.value = ($line) -replace "[^0-9]" , ''
				}
			}
			if ($line -like '*WSJTX_VERSION_SUB*') {
				$relx = $rrelx.value = ($line) -replace "[^0-9]" , ''				
			}

			if ($line -like '*WSJTX_VERSION_IS_RELEASE*') {
				# Problem: Can have Two 1's in output string so need stop at match first nbrSrcMarkers
				# Limitation: This technique works number 0 - 9 only !
				if ($line -match "(?<number>\d)")
				{
					[Int]$val = $line.substring($line.indexof($Matches.number),1)
				} else {  # No match HOPEFULLY sets $count to -1, becoming 0, so trips error handler
					$count = -1
				}
				
				$rrcx.value = $val
			}
			$count++
		}
	}
	if ($count -ne 0) { 
		if ((Test-Path "$env:JTSDK_TMP\wsjtx\Versions.cmake")) { # JTDX Detected ---------------
			Write-Host "  --> Version ...: $mav.$miv.$pav rc $relx"
			Write-Host "  --> RC ........: $rcx"
		} else { #WSJTX Detected ---------------------------------------------------------------
			Write-Host "  --> Version ...: $mav.$miv.$pav rc $rcx"
			Write-Host "  --> Release ...: $relx"

		}
		# Write-Host ""
	} else {    # Excessive - Only needs Version.cmake but extra logic to be double-sure !!!!
		if (!(Test-Path "$env:JTSDK_TMP\wsjtx\Versions.cmake")) {
			GenerateError("Unable to read version data from $env:JTSDK_TMP\wsjtx\Versions.cmake")
		} else {
			GenerateError("Unable to read version data from $env:JTSDK_TMP\wsjtx\CMakeList.txt")
		}	
	}
	# pause
}

####################################################################
############################ MAIN LOGIC ############################
####################################################################

# Used to prevent CMake errors with MinGW Makefiles
# This prevents a long-standing annoyance seen while developing...  !!!
#if (Test-Path("$env:JTSDK_TOOLS\msys64\usr\bin\sh-bak.exe")) { 
#	Rename-Item $env:JTSDK_TOOLS\msys64\usr\bin\sh-bak.exe $env:JTSDK_TOOLS\msys64\usr\bin\sh.exe | Out-Null 
#}

#Push-Location $env:JTSDK_TOOLS\msys64\usr\bin
#Rename-Item $env:JTSDK_TOOLS\msys64\usr\bin\sh.exe $env:JTSDK_TOOLS\msys64\usr\bin\sh-bak.exe | Out-Null
#Pop-Location

# Process Options ------------------------------------------------ PROCESS OPTIONS
# This processes the options behind the command jtbuild

if ($args -ne $null) { $aarg = [string]$args } else { $aarg=$null }
$copt="Release"
$topt="Config"
$ncg="F"											# No Configuration Flag (note negative logic)				
$ngp="F"											# No GIT-Pull Flag (note negative logic)
ProcessOptions $aarg -rcopt ([ref]$copt) -rtopt ([ref]$topt) -rcgopt ([ref]$ncg) -rgopt ([ref]$ngp)	

# Reads in configuration data from Versions.ini ------------------ PROCESS key data from Versions.ini

$env:JTSDK_VC = "$env:JTSDK_CONFIG\Versions.ini"
Get-Content $env:JTSDK_VC | foreach-object -begin {$configTable=@{}} -process { $k = [regex]::split($_,'='); if(($k[0].CompareTo("") -ne 0) -and ($k[0].StartsWith("[") -ne $True)) { $configTable.Add($k[0], $k[1]) } }

$srcd = $configTable.Get_Item("srcd")				# Sets srcd => Source Location
$dest = $configTable.Get_Item("destd")				# Sets dest => Desctination Location
$cfgd = $env:JTSDK_CONFIG							# Sets cfgd => JTSDK_CONFIG location
$qtv = $env:QTV										# Sets qtv => QTV

$cleanFirst="No"
$cleanFirst=$configTable.Get_Item("cleanfirst")		# Clean First Flag 

$reconfigure="No"
$reconfigure=$configTable.Get_Item("reconfigure")	# Reconfigure Flag

$autorun="No"
$autorun= $configTable.Get_Item("autorun")			# Autorun Flag

$pullUpd="No"
$pullUpd=$configTable.Get_Item("pulllatest")		# Pull latest updates Flag

$JJ=$env:NUMBER_OF_PROCESSORS						# Read from ENV; Can set manually


# Display Build Commencement Message ----------------------------- COMMENCE BUILD

CommenceBuildMessage

# Adjust $env:JT_SRC if there has been a source change ----------- COMMENCE BUILD

AlignJT_SRCWithMarker

# Download source based on switch in $cfgd ----------------------- DOWNLOAD SOURCE
# Switch is src-wsjtx, src-jtdx or src-js8call

if ( $ngp -eq "F" ) { DownloadSource -srcd $srcd -pullupd $pullUpd }

# QT CMake Tool Chain File Selection # --------------------------- QT TOOLCHAIN

$pathDPDel = $env:QTV
$pathDPDelR = $pathDPDel -replace "\.",''
$tchain = ($env:JTSDK_TOOLS + "\tc-files\QT"+$pathDPDelR+".cmake").replace("\","/")

# Set Version Data  ---------------------------------------------- SET VERSION DATA

[Int]$mav = 0  # Major Version
[Int]$miv = 0  # Minor Version
[Int]$pav = 0  # Patch Version
[Int]$rcx = 0  # Release Candidate Nbr  
[Int]$relx = 0 # Release flag

GetVersionData -rmav ([ref]$mav) -rmiv ([ref]$miv) -rpav ([ref]$pav) -rrcx ([ref]$rcx) -rrelx([ref]$relx)

$aver="$mav.$miv.$pav"
$desc="Development"
if ($relx -eq 1) { $desc="GA Release" }
if (($relx -gt 0) -and ($relx -eq 1)) { $desc="GA Release" }
if (($relx -eq 0) -and ($relx -eq 0)) { $desc="Development" }
if (($relx -gt 0) -and ($relx -eq 0)) { $desc="Release Candidate" }

# Setup Directories ---------------------------------------------- SETUP DIRECTORIES

$buildd="$dest\qt\$qtv\$aver\$copt\build"
$installd="$dest\qt\$qtv\$aver\$copt\install"
$pkgd="$dest\qt\$qtv\$aver\$copt\package"
SetupDirectories

# Build Information ---------------------------------------------- BUILD INFORMATION

BuildInformation

# select build type ---------------------------------------------- BUILD SELECT

if ($topt -like "Config") { ConfigOnly }
if ($topt -like "Install") { InstallTarget }
if ($topt -like "Package") { PackageTarget }
if ($topt -like "Docs") { DocsTarget } 

# ---------------------------------------------------------------- FINAL CATCH-ALL !!!
GenerateError("Undefined Target")

TheEnd (-1)
