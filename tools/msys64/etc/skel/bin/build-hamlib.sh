#!/usr/bin/bash
################################################################################
#
# Title ........: build-hamlib.sh
# Version ......: 3.2.0 
# Description ..: Build Hamlib from GIT-distributed Hamlib Integration Branches
# Project URL ..: https://github.com/KI7MT/jtsdk64-tools-scripts.git
#
# Adjusted by Steve VK3VM 21-04 to 28-08-2020 for JTSDK 3.1 and GIT sources
#          Qt Version Adjustments 21-04 to 11-Feb-2021
#          Refactoring to use Environment variables better 13-2-2021 - 21-3-2021
#
# Author .......: Greg, Beam, KI7MT, <ki7mt@yahoo.com>
# Copyright ....: Copyright (C) 2013-2021 Greg Beam, KI7MT
#                 Copyright (c) 2020-2021 Subsequent JTSDK Contributors
#
# Support for Qt 5.12.10, 5.14.2, 5.15.2, 6.0.1 by Steve VK3VM
#
################################################################################

# Exit on errors
set -e

#-----------------------------------------------------------------------------#
# SET UP VARIABLES THAT NEED GLOBAL SCOPE                                     #
#-----------------------------------------------------------------------------#

# Script Info

SCRIPT_NAME="JTSDK64 Tools MSYS2 Hamlib Build Script"

# Foreground colors
C_R='\033[01;31m'		# red
C_G='\033[01;32m'		# green
C_Y='\033[01;33m'		# yellow
C_C='\033[01;36m'		# cyan
C_NC='\033[01;37m'		# no color

# -- Process Variables --------------------------------------------------------

PKG_NAME=Hamlib
TODAY=$(date +"%d-%m-%Y")
TIMESTAMP=$(date +"%d-%m-%Y at %R")
BUILDER=$(whoami)
# CPUS=$((`nproc --all`))
DRIVE=`cygpath -w ~ | head -c 1 | tr '[:upper:]' '[:lower:]'`
SRCD="$HOME/src/hamlib"
BUILDD="$SRCD/build"
PREFIX="${JTSDK_TOOLS_F}/hamlib/qt/$QTV"
LIBUSBINC="${libusb_dir_f/:}/include"
LIBUSBD="${libusb_dir_f/:}/MinGW64/dll"
mkdir -p $HOME/src/hamlib/{build,src} >/dev/null 2>&1

# -- QT Tool Chain Paths ------------------------------------------------------
# QTV="$QTV"

export PATH="$GCCD_F:$QTD_F:$QTP_F:$LIBUSBINC:$LIBUSBD:$PATH"

#-----------------------------------------------------------------------------#
# FUNCTIONS                                                                   #
#-----------------------------------------------------------------------------#

# Function: main script header ------------------------------------------------
Script-Header () {
	echo ''
	echo '---------------------------------------------------------------'
	echo -e ${C_C}"       $SCRIPT_NAME $JTSDK64_VERSION"${C_NC}
	echo '---------------------------------------------------------------'
	echo ''
	echo '* This script compiles static Hamlib Libraries for the JTSDK'
	#echo ''
}

# Function: Determine Nbr CPUs to allocate ------------------------------------
function Determine-CPUs () {
	CPUREC=$(sed -n 's/.*cpuusage *= *\([^ ]*.*\)/\1/p' < "${JTSDK_CONFIG_F}/Versions.ini")
	if [ "$CPUREC" = "All" ]; 
	then 
		CPUS=$((`nproc --all`))
	fi
	if [ "$CPUREC" = "Half" ]; 
	then 
		echo "Half"
		NONO=`nproc --all`
		CPUS=$(($NONO / 2))
		echo $CPUS
	fi
	if [ "$CPUREC" = "Solo" ]; 
	then 
		CPUS=1
	fi
}

# Function: package data ------------------------------------------------------
Package-Data () {
	echo ''
	echo '----------------------------------------------------------------'
	echo -e ${C_G} " COMPILE INFORMATION [ $PKG_NAME ]"${C_NC}
	echo '----------------------------------------------------------------'
	echo ''
	echo -e " Date ................ ${C_G}$TODAY"${C_NC}
	echo -e " Package ............. ${C_G}$PKG_NAME"${C_NC}
	echo -e " User ................ ${C_G}$BUILDER"${C_NC}
	echo -e " CPU/Job Count ....... ${C_G}$CPUS"${C_NC}
	echo -e " QT Version .......... ${C_G}$QTV"${C_NC}
	echo -e " QT Tools/Toolchain .. ${C_G}$GCCD_F"${C_NC}
	echo -e " QT Directory ........ ${C_G}$QTD_F"${C_NC}
	echo -e " QT Platform ......... ${C_G}$QTP_F"${C_NC}
	echo -e " SRC Dir ............. ${C_G}$HOME/${BUILD_BASE_DIR}"${C_NC}	
	echo -e " Build Dir ........... ${C_G}$BUILDD"${C_NC}
	echo -e " Install Prefix ...... ${C_G}$PREFIX"${C_NC}
	echo -e " Libusb Include ...... ${C_G}$LIBUSBINC"${C_NC}
	echo -e " Libusb DLL .......... ${C_G}$LIBUSBD"${C_NC}
	echo -e " Package Config....... ${C_G}$PREFIX/lib/pkgconfig/hamlib.pc"${C_NC}
	echo -e " Tool Chain .......... ${C_G}$GCCD_F"${C_NC}
	echo ''
}

# Function: tool chain check ---------------------------------------------------
Tool-Check () {
	#echo ''
	echo '---------------------------------------------------------------'
	echo -e ${C_Y}" CHECKING TOOL-CHAIN [ QT $QTV ]"${C_NC}
	echo '---------------------------------------------------------------'

	# setup array and perform simple version checks
	echo ''
	array=( 'ar' 'nm' 'ld' 'gcc' 'g++' 'ranlib' )

	for i in "${array[@]}"
	do
		"$i" --version >/dev/null 2>&1

		if [ "$?" = "1" ];
		then
			echo -en " $i check" && echo -e ${C_R}' FAILED'${C_NC}
			echo ''
			echo ' If you have not sourced one of the two options, try'
			echo ' that first, otherwise set you path correctly:'
			echo ''
			echo ' [ 1 ] For the QT5 Tool Chain type, ..: source-qt5'
			echo ' [ 2 ] For MinGW Tool-Chain, type ....: source-mingw32'
			echo ''
			exit 1
		else
			echo -en " $i .." && echo -e ${C_G}' OK'${C_NC}
		fi
	done

	# List tools versions
	echo -e ' Compiler ........... '${C_G}"$(gcc --version |awk 'FNR==1')"${C_NC}
	echo -e ' Bin Utils .......... '${C_G}"$(ranlib --version |awk 'FNR==1')"${C_NC}
	echo -e ' Libtool ............ '${C_G}"$(libtool --version |awk 'FNR==1')"${C_NC}
	echo -e ' Pkg-Config ......... '${C_G}"$(pkg-config --version)"${C_NC}
	
	if [ "$?" = "0" ];
	then
	echo -en " Tool-Chain ......... "&& echo -e ${C_G}'OK'${C_NC}
		echo ''
	else
		echo ''
		echo -e ${C_R}"TOOL-CHAIN WARNING"${C_NC}
		echo 'There was a problem with the Tool-Chain.'
		echo "$0 Will now exit .."
		exit ''
		exit 1
	fi
	
}

#Function: Clone Repository ---------------------------------------------------
# As long as HLREPO does not = NONE (First added Steve I VK3VM 11-30/5/2020)
#
# Default (no valid entry of hlnone or hlg4wjs or in C:\JTSDK64-Tools\ )
# is the master HAMLIB repository

function Clone-Repo () {
	echo '---------------------------------------------------------------'
	echo -e ${C_Y} " CLONING GIT REPOSITORY [ $HLREPO ]"${C_NC}
	echo '---------------------------------------------------------------'
	echo ''
	if [ "$HLREPO" = "NONE" ];
	then 
		echo 'HAMLIB: Use existing: No GIT pull (hlnone} unless no source present'
		echo ''
		cd "$SRCD"
		
		if [[ -f $SRCD/src/bootstrap ]];
		then
			echo 'HAMLIB: Static Source detected : GIT pull not attempted.'
			# echo ''
		else	 	
			echo 'HAMLIB: Static Source selected : No source detected so MASTER repo pull attempted.'
			echo ''
			# ensure the directory is removed first
			if [[ -d $SRCD/src ]];
			then
				rm -rf "$SRCD/src"
			fi

			# clone the DEFAULT repository
			git clone https://github.com/Hamlib/Hamlib.git src
			
			cd "$SRCD/src"

			# checkout the master branch
			git checkout master
		fi
	else
		mkdir -p "$BUILDD"
		if [[ -f $SRCD/src/bootstrap ]];
		then
			cd "$SRCD/src"
			# git config pull.rebase false   # Merge from Repos
			# git config pull.rebase true	 # Rebase from Repos	
			git config pull.ff only 		 # Base off "fast-forwards" 
			git pull
		else
			cd "$SRCD"

			# ensure the directory is removed first
			if [[ -d $SRCD/src ]];
			then
				rm -rf "$SRCD/src"
			fi

			# clone the repository
			if [ "$HLREPO" = "G4WJS" ];
			then 
				echo 'HAMLIB: Cloning from G4WJS Repository'
				echo ''
				git clone https://git.code.sf.net/u/bsomervi/hamlib src
			else 
				if [ "$HLREPO" = "W9MDB" ];
				then
					echo 'HAMLIB: Cloning from W9MDB Repository'
					echo ''
					git clone https://github.com/mdblack98/Hamlib src
				else
					echo 'HAMLIB: Cloning from MASTER Repository'
					echo ''
					git clone https://github.com/Hamlib/Hamlib.git src
				fi
			fi 
			
			cd "$SRCD/src"

			# checkout the master branch
			git checkout master
		fi
	fi
}

# Function: Perfporm Bootstrap Function ---------------------------------------
function Perform-Bootstrap () {
	# -- run hamlib bootstrap -------------------------------------------------
	cd "$SRCD/src"
	echo ''
	echo '---------------------------------------------------------------'
	echo -e ${C_Y} " RUN BOOTSTRAP [ $PKG_NAME ]"${C_NC}
	echo '---------------------------------------------------------------'
	echo ''
	echo 'Running bootstrap'
	./bootstrap
}

# Function: Run configure -----------------------------------------------------
function Run-Config () {
	cd "$BUILDD"
	echo ''
	echo '---------------------------------------------------------------'
	echo -e ${C_Y} " CONFIGURING [ $PKG_NAME ]"${C_NC}
	echo '---------------------------------------------------------------'
	echo ''
	echo '.. This may take a several minutes to complete'

	# configure for static only with Libusb, without readline
	# Note: --without-libusb added by VK3VM 12-Apr-2020 to to solve
	# wsjtx 2.1.2 Linker error at final stage
	echo -en ".. Build Type: " && echo -e ${C_G}'Static'${C_NC}
	echo ''
	../src/configure --prefix="$PREFIX" \
	--disable-shared \
	--enable-static \
	--disable-winradio \
	--without-cxx-binding \
	--without-readline \
	--without-libusb \
	CC="$GCCD_F/gcc.exe" \
	CXX="$GCCD_F/g++.exe" \
	CFLAGS="-g -O2 -fdata-sections -ffunction-sections -I$LIBUSBINC" \
	LDFLAGS="-Wl,--gc-sections" \
	LIBUSB_LIBS="-L$LIBUSBD -lusb-1.0"
}

# Function: Clean Build -------------------------------------------------------
function Clean-Build {
	echo ''
	echo '---------------------------------------------------------------'
	echo -e ${C_Y} " RUNNING MAKE CLEAN [ $PKG_NAME ]"${C_NC}
	echo '---------------------------------------------------------------'
	echo ''
	# Updated in v3.1.0.2 Release
	if [ -f "${JTSDK_CONFIG_F}/hlclean" ]
	then
		make clean
	fi
}

# Function: Run Make ----------------------------------------------------------
function Run-Make {
	echo ''
	echo '----------------------------------------------------------------'
	echo -e ${C_Y} " RUNNING MAKE ALL [ $PKG_NAME ]"${C_NC}
	echo '----------------------------------------------------------------'
	echo ''
	make -j $CPUS
}

# Function: Make InstallStrip -------------------------------------------------
function Make-InstallStrip {
	echo ''
	echo '----------------------------------------------------------------'
	echo -e ${C_Y} " INSTALLING [ $PKG_NAME ]"${C_NC}
	echo '----------------------------------------------------------------'
	echo ''
	make install-strip
}

# Function: Generate Build Info -----------------------------------------------
function Generate-BuildInfo {
	if [[ $? = "0" ]];
	then
		if [[ -f $PREFIX/$PKG_NAME.build.info ]]
		then
			rm -f "$PREFIX/$PKG_NAME.build.info"
		fi

		echo ''
		echo '---------------------------------------------------------------'
		echo -e ${C_Y} " ADDING BUILD INFO [ $PKG_NAME.build.info ] "${C_NC}
		echo '---------------------------------------------------------------'
		echo ''
		echo '  Creating Hamlib3 Build Info File'

	(
	cat <<EOF

# Package Information
Build Date...: $TIMESTAMP
BUILDER......: $BUILDER
Prefix.......: $PREFIX
Pkg Name.....: $PKG_NAME
Pkg Version..: development
Tool Chain...: $QTV

# Source Location and Integration
Git URL......: https://github.com/Hamlib/Hamlib.git
Git Extra....: git checkout integration

# Configure Options <for Static>
--prefix="$PREFIX" \
--disable-shared \
--enable-static \
--disable-winradio \
--without-cxx-binding \
--without-readline \
CC="$GCCD_F/gcc.exe" \
CXX="$GCCD_F/g++.exe" \
CFLAGS="-g -O2 -fdata-sections -ffunction-sections -I$LIBUSBINC" \
LDFLAGS="-Wl,--gc-sections" \
LIBUSB_LIBS="-L$LIBUSBD -lusb-1.0"

# Build Commands
make -j$CPUS
make install-strip

EOF
	) > "$PREFIX/$PKG_NAME.build.info"
		echo '  Finished'
	fi
}

# Function: Copy DLL ----------------------------------------------------------
function Copy-DLLs {
	echo ''
	echo '---------------------------------------------------------------'
	echo -e ${C_Y} " COPY DLL's TO [ $PREFIX/BIN ]"${C_NC}
	echo '---------------------------------------------------------------'
	echo ''
	echo "* $LIBUSBD/libusb-1.0.dll"
	cp -u "$LIBUSBD/libusb-1.0.dll" "$PREFIX/bin"
	echo "* $GCCD_F/libwinpthread-1.dll"
	cp -u "$GCCD_F/libwinpthread-1.dll" "$PREFIX/bin"
}

# Function: Fixup Pkgconfig ---------------------------------------------------
function Fixup-PkgConfig {
	echo ''
	echo '---------------------------------------------------------------'
	echo -e ${C_Y} " FIXUP PKGCONFIG "${C_NC}
	echo '---------------------------------------------------------------'
	echo ''
	echo '  Updating hamlib.pc'
	sed -i 's/Requires.private\: libusb-1.0/Requires.private\:/g' "$PREFIX/lib/pkgconfig/hamlib.pc" >/dev/null 2>&1
}

# Function: Test-RigctlBinary -------------------------------------------------
function Test-RigCtlBinary {
	echo ''
	echo '---------------------------------------------------------------'
	echo -e ${C_Y} " TESTING RIGCTL"${C_NC}
	echo '---------------------------------------------------------------'
	echo ''
	$PREFIX/bin/rigctl.exe --version
}

#------------------------------------------------------------------------------#
# START MAIN SCRIPT                                                            #
#------------------------------------------------------------------------------#

# -- run tool check -----------------------------------------------------------
cd
clear
Determine-CPUs
Script-Header
Package-Data
Tool-Check

# -- Start Git clone ----------------------------------------------------------
Clone-Repo

# -- Set Release Info ---------------------------------------------------------
# Note: This WILL ONLY WORK ONCE HAMLIB SOURCE IS DOWNLOADED
#RELEASE=$(/usr/bin/awk 'BEGIN{FS="["; RS="]"} /\[4\./ {print $2;exit}' $SRCD/$PACKVER/configure.ac)
#export HL_FILENAME=hamlib-w64-${RELEASE}

Perform-Bootstrap

# -- run configure ------------------------------------------------------------

Run-Config

# -- clean build --------------------------------------------------------------

Clean-Build

# -- Run Make -----------------------------------------------------------------

Run-Make

# -- Make install-strip -------------------------------------------------------

Make-InstallStrip

# -- Generate Build Info file -------------------------------------------------

Generate-BuildInfo

# -- copy dll -----------------------------------------------------------------

Copy-DLLs

# -- update pkgconfig ---------------------------------------------------------

Fixup-PkgConfig

# -- test rigctl.exe binary ---------------------------------------------------

Test-RigCtlBinary

# -- Finished -----------------------------------------------------------------

Package-Data

# exit script
exit 0
