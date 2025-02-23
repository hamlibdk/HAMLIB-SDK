#-----------------------------------------------------------------------------::
# Name .........: test.ps1
# Project ......: Part of the JTSDK64 Tools Project
# Version ......: 4.0.0a
# Description ..: Test script to locate path of Qt instances
# Original URL .: https://github.com/KI7MT/jtsdk64-tools.git
# Project URL ..: https://sourceforge.net/projects/hamlib-sdk
# Usage ........: Call this file directly from the command line
# 
# Author .......: Mike Black W9MDB
#				  Hamlib SDK Contributors <hamlibdk@outlook.com>
#
# Concept ......: Greg Beam, KI7MT, <ki7mt@yahoo.com>
#
# Copyright ....: (C) 2013-2021 Greg Beam, KI7MT
#                 (C) 2020-2025 JTSDK Contributors
# License ......: GPL-3
#
# Adjustments...: Initial post: https://groups.io/g/JTSDK/message/2912 2024-12-22 Mike W9MDB
#				: Evolution (heading into integration with Create-LinkQt.ps1 2024-12-23 coordinated by  Steve VK3VM
#
#-----------------------------------------------------------------------------::

# --- MAIN LOGIC --------------------------------------------------------------

Write-Output "* Locating Qt deployments ... Please Wait (This may take a few minutes)"
Write-Output ""

# Test to see if Qt Link/Junction already exists
if (Test-Path -Path $env:JTSDK_TOOLS"\Qt") {
	# No point continuing !
    Write-Host "  --> Link/Junction to Qt Deployment already exists."  -ForegroundColor yellow
	Write-Output ""
} else {

	$directories = @()

	# Directly check for MaintenanceTool.exe under JTSDK64-Tools\tools\Qt
	$jtSdkPath = "C:\JTSDK64-Tools\tools\Qt\MaintenanceTool.exe"
	if (Test-Path $jtSdkPath) {
		$directories += (Get-Item $jtSdkPath).DirectoryName
	}

	# Also check Qt* directories as needed
	$qtDirectories = Get-PsDrive -PSProvider 'FileSystem' | 
		ForEach-Object {
			Get-ChildItem $_.Root -Directory 2>$null | 
			Where-Object { $_.Name -like "Qt*" } | 
			ForEach-Object {
				Get-ChildItem -Recurse $_.FullName -File 2>$null | 
				Where-Object { $_.Name -eq "MaintenanceTool.exe" } | 
				Select-Object -ExpandProperty DirectoryName
			}
		}

	$directories += $qtDirectories

	if ($directories.Count -gt 1) {
		Write-Host "  --> Multiple directories found:"
		Write-Host ""
		for ($i = 0; $i -lt $directories.Count; $i++) {
			Write-Host ("{0}: {1}" -f $i, $directories[$i])
		}
		Write-Host ""
		
		# Migrate to .NET enabled input box as will be MUCH MORE ELEGANT !!!
		$selectedIndex = Read-Host "  --> Please enter the number corresponding to the directory you want"
		if ($selectedIndex -match "^\d+$" -and $selectedIndex -lt $directories.Count) {
			$chosenDirectory = $directories[$selectedIndex]
			Write-Host "  --> You selected: $chosenDirectory"
			Write-Host ""
		} else {
			Write-Host "*** Invalid selection***"  -ForegroundColor yellow
			Write-Host ""
		}
	} elseif ($directories.Count -eq 1) {
		$chosenDirectory = $directories[0]
		Write-Host "  --> Only one directory found: $chosenDirectory"
		Write-Host ""
	} else {
		Write-Host "* No matching directories found." -ForegroundColor yellow
		Write-Host ""
		Write-Host "  --> Check to see that Qt is properly deployed"
		Write-Host ""
	}
	
	if ($directories.Count -ge 1) {
		New-Item -Path "$env:JTSDK_TOOLS\Qt" -ItemType Junction -Value $chosenDirectory | out-null
		Write-Host "* Junction created:"$env:JTSDK_TOOLS"\Qt --> "$chosenDirectory
		Write-Host ""
	}
}