#-----------------------------------------------------------------------------#
# Name .........: Get-Boost.ps1
# Project ......: Part of the JTSDK64 Tools Project
# Version ......: 4.0.0 Alpha
# Description ..: Downloads selected Boost deployment specified in Versions.ini
# Usage ........: Call this file directly from the command line
# 
# Author .......: Mike Black W9MDB and Hamlib SDK Contributors <hamlibdk@outlook.com>
# Copyright ....: Copyright (C) 2021 - 2025 Hamlib SDK Contributors
# License ......: GPL-3
#
# Development ..: Initial post by Mike at https://groups.io/g/JTSDK/message/2938 - Mike W9MDB 2025-01-12
#
#-----------------------------------------------------------------------------#

param (
    [Parameter(Mandatory=$true)]
    [string]$version
)

# Base URL for SourceForge Boost files
$baseURL = "https://sourceforge.net/projects/boost/files/boost"

# Construct the URL for the specific version
$versionURL = "$baseURL/$version/"
$zipFileName = "boost_$($version -replace '\.', '_').zip"
$downloadURL = "$versionURL$zipFileName/download"

# Destination file path
$outputFile = Join-Path $PWD $zipFileName

# Log the details
Write-Host "Attempting to download Boost version $version from:"
Write-Host "Source URL: $downloadURL"
Write-Host "Saving to: $outputFile"

# Resolve the final download URL
try {
    Write-Host "Fetching intermediate page..."
    $response = Invoke-WebRequest -Uri $downloadURL -ErrorAction Stop
    $html = $response.Content

    # Search for the redirect meta-refresh or JS redirect pattern
    $metaRefreshPattern = '<meta http-equiv="refresh" content="[^"]*url=([^"]*)'
    $jsRedirectPattern = 'window\.location\.href\s*=\s*["' + "`'" + '"]([^"' + "`'" + ']+)["' + "`'" + '"]'

    $finalURL = if ($html -match $metaRefreshPattern) {
        $matches[1]
    } elseif ($html -match $jsRedirectPattern) {
        $matches[1]
    } else {
        throw "Could not resolve the final download link from the intermediate page."
    }

    Write-Host "Resolved final URL: $finalURL"

    # Download the file
    Write-Host "Downloading file..."
    Invoke-WebRequest -Uri $finalURL -OutFile $outputFile
    Write-Host "Download completed successfully: $outputFile"
} catch {
    Write-Error "Failed to download Boost version $version. Error: $_"
}