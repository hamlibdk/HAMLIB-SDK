#!/usr/bin/bash
################################################################################
#
# Title ........: build-hamlib.sh
# Version ......: 3.2.2.1
# Description ..: Build Hamlib from GIT-distributed Hamlib Integration Branches
# Base Project .: https://github.com/KI7MT/jtsdk64-tools-scripts.git
# Project URL ..: https://sourceforge.net/projects/hamlib-sdk/files/Windows/JTSDK-3.2-Stream
#
# Adjusted by Steve VK3VM 21-04 to 28-08-2020 for JTSDK 3.1 and GIT sources
#          Qt Version Adjustments 21-04 to 11-Feb-2021
#          Refactoring to use Environment variables better 13-2-2021 - 21-3-2021
#          Fix for LibUSB Non Inclusion 6 - 7/9/2021 Steve VK3VM
#          Aligned configure otions to (src)/scripts/build-w64.sy 9/9/2021
#          Dynamic libraries delivered properly to main library tree 4/5-01-2022 Steve VK3VM
#          LibUSB DLL library path set from Versions.ini 6-1-2022 Steve VK3VM
#          Modifications to handle opposite CLI switches and default path dynamic build now 15-1-2022 Steve VK3VM
#
# Author .......: Greg, Beam, KI7MT, <ki7mt@yahoo.com>
# Copyright ....: Copyright (C) 2013-2021 Greg Beam, KI7MT
#                 Copyright (c) 2020-2022 JTSDK Contributors
#
# Support for Qt 5.12.12, 5.15.2, 6.2.2 by Steve VK3VM
#
################################################################################

# Exit on errors
set -e

#-----------------------------------------------------------------------------#
# SET UP VARIABLES THAT NEED GLOBAL SCOPE                                     #
#-----------------------------------------------------------------------------#

OPTIONS=$@
SCRIPT_NAME="JTSDK64 Tools MSYS2 Hamlib Build Script"
#HOST_ARCH=x86_64-w64-mingw32
HOST_ARCH=$MINGW_CHOST
PKG_NAME=Hamlib
BUILDER=$(whoami)
GCCUSED="$(which gcc)"

# -- Colours ------------------------------------------------------------------

C_R='\033[01;31m'		# red
C_G='\033[01;32m'		# green
C_Y='\033[01;33m'		# yellow
C_C='\033[01;36m'		# cyan
C_NC='\033[01;37m'		# no color

# -- Process Variables --------------------------------------------------------

TODAY=$(date +"%d-%m-%Y")
TIMESTAMP=$(date +"%d-%m-%Y at %R")
# CPUS=$((`nproc --all`))
DRIVE=`cygpath -w ~ | head -c 1 | tr '[:upper:]' '[:lower:]'`

# -- Source and Destination Directories ---------------------------------------

SRCD="$HOME/src/hamlib"
BUILDD="$SRCD/build"
PREFIX="${JTSDK_TOOLS_F}/hamlib/qt/$QTV"

# -- LibUSB Variables ---------------------------------------------------------
# Using the VS2019 Delivered DLL as issues with MinGW version delivered in LibUSB 1.0.24

LIBUSBINC="${libusb_dir_f/:}/include"
# LIBUSBDLL="${libusb_dir_f/:}/MinGW64/dll" # MinGW Package possibly broken SIR 6-7/9/2021
# LIBUSBDLL="${libusb_dir_f/:}/VS2019/MS64/dll"
LIBUSBDLL="${libusb_dir_f/:}${libusb_dll}"

# -- Variables for Command Line Switches --------------------------------------

PROCESSBOOTSTRAP="Yes"
PROCESSCONFIGURE="Yes"
PERFORMGITPULL="Yes"
PROCESSLIBUSB="Yes"
SHAREDBUILD="No"
STATICBUILD="Yes"

# -- Create Project Directories -----------------------------------------------

mkdir -p $HOME/src/hamlib/{build,src} >/dev/null 2>&1

# -- Tool Chain Paths ---------------------------------------------------------

export PATH="$GCCD_F:$QTD_F:$QTP_F:$LIBUSBINC:$LIBUSBDLL:$PATH"

#-----------------------------------------------------------------------------#
# FUNCTIONS                                                                   #
#-----------------------------------------------------------------------------#

# Function: main script header ------------------------------------------------
Script-Header () {
	echo ''
	echo -e ${C_Y}'---------------------------------------------------------------'
	echo -e ${C_C}"       $SCRIPT_NAME $JTSDK64_VERSION"${C_NC}
	echo -e ${C_Y}'---------------------------------------------------------------'
	echo ''
	echo -e ${C_C}'* This script compiles Hamlib Libraries for the JTSDK build system.'${C_NC}
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
	echo -e ${C_NC}'---------------------------------------------------------------'
	echo -e ${C_G}" COMPILE INFORMATION [ $PKG_NAME ]"${C_NC}
	echo -e ${C_NC}'---------------------------------------------------------------'
	echo ''
	echo -e " Script Option(s) ...: ${C_G}${OPTIONS}"${C_NC}
	echo ''
	echo -e " Date ...............: ${C_G}$TODAY"${C_NC}
	echo -e " Package ............: ${C_G}$PKG_NAME"${C_NC}
	echo -e " User ...............: ${C_G}$BUILDER"${C_NC}
	echo -e " CPU/Job Count ......: ${C_G}$CPUS"${C_NC}
	echo -e " Compiler ...........: ${C_G}$GCCUSED"${C_NC}
	if [ $MSYSTEM == "MINGW32" ] || [ $MSYSTEM == "MINGW64" ];
	then 
		echo -e " Platform ...........: ${C_G}$MSYSTEM"${C_NC}
	else
		echo -e " Platform ...........: ${C_G}Qt MinGW"${C_NC}
		echo -e " Qt Version .........: ${C_G}$QTV"${C_NC}
		echo -e " Qt Tools/Toolchain .: ${C_G}$GCCD_F"${C_NC}
		echo -e " Qt Directory .......: ${C_G}$QTD_F"${C_NC}
		echo -e " Qt Platform ........: ${C_G}$QTP_F"${C_NC}
	
	fi
	echo -e " Source Dir .........: ${C_G}$HOME/${BUILD_BASE_DIR}"${C_NC}	
	echo -e " Build Dir ..........: ${C_G}$BUILDD"${C_NC}
	if [ $PROCESSLIBUSB = "Yes" ];
	then
		echo -e " LibUSB Include .....: ${C_G}$LIBUSBINC"${C_NC}
		echo -e " LibUSB DLL .........: ${C_G}$LIBUSBDLL"${C_NC}
	else
		echo -e " LibUSB DLL .........: ${C_R}Not Used"${C_NC}
	fi
	echo -e " Package Config......: ${C_G}$PREFIX/lib/pkgconfig/hamlib.pc"${C_NC}
	#echo -e " Tool Chain .........: ${C_G}$GCCD_F"${C_NC}
	echo ''
	echo -e " Install Prefix .....: ${C_G}$PREFIX"${C_NC}
	echo ''
}

# Function: tool chain check ---------------------------------------------------
Tool-Check () {
	#echo ''
	echo -e ${C_NC}'---------------------------------------------------------------'
	echo -e ${C_Y}" CHECKING TOOL-CHAIN [ QT $QTV ]"${C_NC}
	echo -e ${C_NC}'---------------------------------------------------------------'

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
			echo -en " $i "
			size=${#i}
			while [ $size -le 10 ] 
			do
					echo -en "."
					size=$(( size + 1 ))
			done	 
			echo -en "........:" && echo -e ${C_G}' OK'${C_NC}
		fi
	done

	# List tools versions
	echo -e ' Compiler ...........: '${C_G}"$(gcc --version |awk 'FNR==1')"${C_NC}
	echo -e ' Bin Utils ..........: '${C_G}"$(ranlib --version |awk 'FNR==1')"${C_NC}
	echo -e ' Libtool ............: '${C_G}"$(libtool --version |awk 'FNR==1')"${C_NC}
	echo -e ' Pkg-Config .........: '${C_G}"$(pkg-config --version)"${C_NC}
	
	if [ "$?" = "0" ];
	then
	echo -en " Tool-Chain .........: "&& echo -e ${C_G}'OK'${C_NC}
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
	echo -e ${C_NC}'---------------------------------------------------------------'
	echo -e ${C_Y}" CLONING GIT REPOSITORY [ $HLREPO ]"${C_NC}
	echo -e ${C_NC}'---------------------------------------------------------------'
	echo ''
	if [ $PERFORMGITPULL = "Yes" ];
	then
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
					echo 'HAMLIB: Cloning from G4WJS(sk) Repository'
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
	else
		echo '* Option -ng set that disables GIT pulls from repositories'
	fi
}

# Function: Perfporm Bootstrap Function ---------------------------------------
function Perform-Bootstrap () {
	cd "$SRCD/src"
	echo ''
	echo -e ${C_NC}'---------------------------------------------------------------'
	echo -e ${C_Y}" PERFORM BOOTSTRAP [ $PKG_NAME ]"${C_NC}
	echo -e ${C_NC}'---------------------------------------------------------------'
	echo ''
	if [ $PROCESSBOOTSTRAP = "Yes" ];
	then
		echo '* Performing bootstrap'
		echo ''
		./bootstrap
	else
		echo '* Option -nb set to disable executing bootstrap script'
	fi

}

# Function: Run configure -----------------------------------------------------
#  --without-libusb added by VK3VM 12-Apr-2020 to to solve wsjtx 2.1.2 Linker error at final stage
#  --without-libusb removed by VK3VM 7-Sept-2021 as Linker error at final stage issue resolved
#  Handler for -nlibusb added VK3VM 8-Sept-2021

function Run-Config () {
	cd "$BUILDD"
	
	SHAREDVAR='--disable-shared'
	STATICVAR='--enable-static'
	LIBUSBVAR='--without-libusb'
	STSHMSG='Static'
		
	echo ''
	echo -e ${C_NC}'---------------------------------------------------------------'
	echo -e ${C_Y}" CONFIGURING [ $PKG_NAME ]"${C_NC}
	echo -e ${C_NC}'---------------------------------------------------------------'
	echo ''
	if [ $PROCESSCONFIGURE = "Yes" ];
	then
		echo '* Running configure script: This may take a several minutes to complete'
		echo ''
		
		if [ $PROCESSLIBUSB = "No" ];
		then
			LIBUSBVAR='--without-libusb'
			LIBUSBMSG='without'
		else
			LIBUSBVAR=''
			LIBUSBMSG='with'
		fi
		
		if [ $SHAREDBUILD = "Yes" ]; 
		then 
				# Matches new default path (i.e. to build Hamlib DLL only) 4/1/2022 SIR
				# SHAREDVAR='--enable-shared'
				# STATICVAR='--disable-static'
				SHAREDVAR=' '
				STATICVAR=' '
				STSHMSG='Shared/Dynamic'
				STATICBUILD="No"
		fi
		
		if [ $STATICBUILD = "Yes" ]; 
		then 
				SHAREDVAR='--disable-shared'
				STATICVAR='--enable-static'
				STSHMSG='Static'
				SHAREDBUILD="No"
		fi
		
		echo -e "  --> Build Type: "${C_G}$STSHMSG${C_NC}' built '${C_G}$LIBUSBMSG${C_NC}${C_NC}' LibUSB'${C_NC}
		echo ''
		
		# New options to match that in (hamlib-src)/scripts/build-w64.sh - creates cleaner configuration results
		# Implemented Steve VK3SIR 9-9-2021
		# Setup so maybe can fully implement -shared / -static command line options	
		
		# ../src/configure --host=${HOST_ARCH} \
		../src/configure  \
		--prefix="$PREFIX" \
		$SHAREDVAR \
		$STATICVAR \
		--without-cxx-binding \
		$LIBUSBVAR \
		CPPFLAGS="-I${libusb_dir_f}/include" \
		LDFLAGS="-L${libusb_dir_f}/MinGW64/dll" 
		# CPPFLAGS="-I${libusb_dir_f}/include -I/usr/include" \
		# LDFLAGS="-L${libusb_dir_f}/MinGW64/dll -L/usr/lib"
	else
		echo '* Option -nc set to disable executing configure script'
	fi
}

# Function: Clean Build -------------------------------------------------------
function Clean-Build {
	echo ''
	echo -e ${C_NC}'---------------------------------------------------------------'
	echo -e ${C_Y}" RUNNING MAKE CLEAN [ $PKG_NAME ]"${C_NC}
	echo -e ${C_NC}'---------------------------------------------------------------'
	echo ''
	# Updated in v3.1.0.2 Release
	if [ -f "${JTSDK_CONFIG_F}/hlclean" ]
	then
		echo '* Performing Clean'
		make clean
	else
		echo "* ${JTSDK_CONFIG_F}/hlclean flag not set"
	fi
}

# Function: Run Make ----------------------------------------------------------
function Run-Make {
	echo ''
	echo -e ${C_NC}'---------------------------------------------------------------'
	echo -e ${C_Y}" RUNNING MAKE ALL [ $PKG_NAME ]"${C_NC}
	echo -e ${C_NC}'---------------------------------------------------------------'
	echo ''
	make -j $CPUS
}

# Function: Make InstallStrip -------------------------------------------------
function Make-InstallStrip {
	echo ''
	echo -e ${C_NC}'---------------------------------------------------------------'
	echo -e ${C_Y}" INSTALLING [ $PKG_NAME ]"${C_NC}
	echo -e ${C_NC}'---------------------------------------------------------------'
	echo ''
	if [ -f "${PREFIX}/bin/rigctl.exe" ]
	then
		echo -n "* Clearing out old ${PREFIX}: "
		# Yes I know this is dangerous !
		rm -rf $PREFIX/* > /dev/null
		# rm -rf $PREFIX/*
		echo "Complete"
		echo ''
	fi

	echo "* Installing Hamlib Headers, Libraries and Utilities to ${PREFIX}"
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
		echo -e ${C_NC}'---------------------------------------------------------------'
		echo -e ${C_Y}" ADDING BUILD INFO [ $PKG_NAME.build.info ] "${C_NC}
		echo -e ${C_NC}'---------------------------------------------------------------'
		echo ''
		echo '* Creating Hamlib Build Info File'
		echo ''

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
--without-cxx-binding \
CPPFLAGS="-I${libusb_dir_f}/include" \
LDFLAGS="-L${libusb_dir_f}/MinGW64/dll"

# Configure Options <for Shared>
--prefix="$PREFIX" \
--without-cxx-binding \
CCPPFLAGS="-I${libusb_dir_f}/include" \
LDFLAGS="-L${libusb_dir_f}/MinGW64/dll"

# Build Commands
make -j$CPUS
make install-strip

EOF
	) > "$PREFIX/$PKG_NAME.build.info"
		echo '  --> Complete'
	fi
}

# Function: Copy DLL ----------------------------------------------------------
function Copy-DLLs {
	echo ''
	echo -e ${C_NC}'---------------------------------------------------------------'
	echo -e ${C_Y}" COPY SUPPORT DLLs TO HAMLIB DESINATION"${C_NC}
	echo -e ${C_NC}'---------------------------------------------------------------'
	echo ''
	echo "* Destination: $PREFIX/bin"
	echo ''
	echo "* DLL Source(s):"
	echo ''
	if [ $PROCESSLIBUSB = "Yes" ];
	then
		echo "  --> $LIBUSBDLL/libusb-1.0.dll"
		cp -u "$LIBUSBDLL/libusb-1.0.dll" "$PREFIX/bin"
	fi
	echo "  --> $GCCD_F/libwinpthread-1.dll"
	cp -u "$GCCD_F/libwinpthread-1.dll" "$PREFIX/bin"
	
	# -- Special Cleanup for Dynamic Builds ---------------------------------------
	# Note: This may NOT be required in the future when configure option --disable-static works
	
	# echo "PREFIX: $PREFIX"
	# read -p "Press any key to resume ..."
	
	if [ $STATICBUILD = "No" ];
	then
		if [ $SHAREDBUILD = "Yes" ];
		then
			echo "  --> Temporary: Removing Static Hamlib libraries that may cause issues with Dynamic Builds"
			if [ -f "$PREFIX/lib/libhamlib.a" ];
			then
				rm -f "$PREFIX/lib/libhamlib.a" > /dev/null
				echo "  --> --> libhamlib.a removed."
			fi
			if [ -f "$PREFIX/lib/libhamlib.la" ];
			then
				rm -f "$PREFIX/lib/libhamlib.la" > /dev/null
				echo "  --> --> libhamlib.la removed."
			fi
		fi
	fi
	
		# -- Special Cleanup for Static Builds -----------------------------------
	# Note: This may NOT be required in the future when configure option --disable-dynamic works
	
	# echo "PREFIX: $PREFIX"
	# read -p "Press any key to resume ..."
	
	if [ $SHAREDBUILD = "No" ];
	then
		if [ $STATICBUILD = "Yes" ];
		then
			echo "  --> Temporary: Removing Dynamic Hamlib libraries that may cause issues with Static Builds"
			if [ -f "$PREFIX/lib/libhamlib.a" ];
			then
				rm -f "$PREFIX/lib/libhamlib.dll.a" > /dev/null
				echo "  --> --> libhamlib.dll.a removed."
			fi
			if [ -f "$PREFIX/lib/libhamlib.la" ];
			then
				rm -f "$PREFIX/lib/libhamlib.la" > /dev/null
				echo "  --> --> libhamlib.la removed."
			fi
		fi
	fi
}

# Function: Fixup Pkgconfig ---------------------------------------------------
function Fixup-PkgConfig {
	echo ''
	echo -e ${C_NC}'---------------------------------------------------------------'
	echo -e ${C_Y}" FIXUP PKGCONFIG "${C_NC}
	echo -e ${C_NC}'---------------------------------------------------------------'
	echo ''
	echo '* Updating hamlib.pc'
	sed -i 's/Requires.private\: libusb-1.0/Requires.private\:/g' "$PREFIX/lib/pkgconfig/hamlib.pc" >/dev/null 2>&1
}

# Function: Test-Binaries -----------------------------------------------------
function Test-Binaries {
	echo ''
	echo -e ${C_NC}'---------------------------------------------------------------'
	echo -e ${C_Y}" TESTING HAMLIB RIGCTL"${C_NC}
	echo -e ${C_NC}'---------------------------------------------------------------'
	echo ''
	# Overcomes a bug encountered when LibUSB support is enabled
	PREFIXB="${JTSDK_TOOLS}\hamlib\qt\\$QTV"
	cmd /C "$PREFIXB\bin\rigctl.exe --version"
		# $PREFIX/bin/rigctl.exe --version
	
	if [ $PROCESSLIBUSB = "Yes" ];
	then
		echo ''
		echo -e ${C_NC}'---------------------------------------------------------------'
		echo -e ${C_Y}" TESTING HAMLIB LIBUSB FUNCTIONALITY"${C_NC}
		echo -e ${C_NC}'---------------------------------------------------------------'
		echo ''
		# Overcomes a bug encountered when LibUSB support is enabled
		PREFIXB="${JTSDK_TOOLS}\hamlib\qt\\$QTV"
		cmd /C "$PREFIXB\bin\rigtestlibusb.exe"
	fi
}

#------------------------------------------------------------------------------#
# HELP MESSAGING AND ERROR HANDLING SCRIPT                                     #
#------------------------------------------------------------------------------#

# Function: Help --------------------------------------------------------------
function Help-Command () {
	echo ''
	echo -e ${C_NC}'---------------------------------------------------------------'
	echo -e ${C_Y}" BUILD-HAMLIB - HELP"${C_NC}
	echo -e ${C_NC}'---------------------------------------------------------------'
	Help-Messages
}

# Function: Error -------------------------------------------------------------
function Error-Message () {
	echo ''
	echo -e ${C_NC}'---------------------------------------------------------------'
	echo -e ${C_Y}" BUILD-HAMLIB - ERROR IN COMMAND "${C_NC}
	echo -e ${C_NC}'---------------------------------------------------------------'
	echo ''
	echo -e ${C_R}" *** ERROR: $1 ***"${C_NC}
	Help-Messages
}

# Function: Help Messages -----------------------------------------------------
function Help-Messages () {
	echo ''
	echo '* Available Command Line Options:'
	echo ''
	echo -e "  --> ${C_G}-h${C_NC} ........: Help"
	echo -e "  --> ${C_G}-b${C_NC}/${C_G}-nb${C_NC} ....: Process / Do not process bootstrap"
	echo -e "  --> ${C_G}-c${C_NC}/${C_G}-nc${C_NC} ....: Process / Do not process configure"
	echo -e "  --> ${C_G}-g${C_NC}/${C_G}-ng${C_NC} ....: Process / Do not pull/check source from GIT repository"
	echo -e "  --> ${C_G}-libusb${C_NC} ...: Configure with LibUSB support"
	echo -e "  --> ${C_G}-nlibusb${C_NC} ..: Do not configure with LibUSB support"
	echo -e "  --> ${C_G}-static${C_NC} ...: Statically Linked Libraries built"
	echo '       or ..' 
	echo -e "  --> ${C_G}-dynamic${C_NC} ..: Shared/Dynamically Linked Libraries built"
	echo ''
	echo -e "${C_R}* Note:${C_NC} You cannot select ${C_R}-static${C_NC} with ${C_R}-dynamic${C_NC}"
	echo ''
	echo '  If using switches you may need to combine options to over-ride default build behaviour:'
	echo ''
	echo -e "  i.e.: ${C_G}build-hamlib -nb${C_NC} reverts to Hamlib default STATIC build behaviour"
	echo -e "        ${C_G}build-hamlib -nb -dynamic${C_NC} over-rides this behaviour"
	echo ''
	exit 1
}

#------------------------------------------------------------------------------#
# START MAIN SCRIPT                                                            #
#------------------------------------------------------------------------------#

cd

# -- Process Command Line Options ---------------------------------------------

SHAREASPARAM="No"
STATICASPARAM="No"
BOOTSTRAPASPARAM="No"
CONFIGASPARAM="No"
GITASPARM="No"
LIBUSBASPARAM="No"

# If no parameters entered 14-1-2022 Steve VK3VM 
if [ $# -eq 0 ];
then
	SHAREDBUILD="Yes"
	SHAREASPARAM="Yes"
	STATICBUILD="No"
	STATICASPARAM="No"
	PROCESSLIBUSB="Yes" # -- JUST TO BE SAFE ---------------
	OPTIONS="None (Default = Dynamic with LibUSB)"
fi

while [ $# -gt 0 ]; do
	case $1 in
	-h|-help|--h|--help)
		Help-Command
		shift
		;;
	-b|--b)
		if [ $BOOTSTRAPASPARAM = "Yes" ];
		then
			Error-Message "Cannot set for both -b and -nb options"
		fi
		PROCESSBOOTSTRAP="Yes"
		BOOTSTRAPASPARAM="Yes"
		shift
		;;
	-nb|--nb)
		if [ $BOOTSTRAPASPARAM = "Yes" ];
		then
			Error-Message "Cannot set for both -b and -nb options"
		fi
		PROCESSBOOTSTRAP="No"
		BOOTSTRAPASPARAM="Yes"
		shift
		;;
	-c|--c)
		if [ $CONFIGASPARAM = "Yes" ];
		then
			Error-Message "Cannot set for both -c and -nc options"
		fi
		PROCESSCONFIGURE="Yes"
		CONFIGASPARAM="Yes"
		shift
		;;
	-nc|--nc)
		if [ $CONFIGASPARAM = "Yes" ];
		then
			Error-Message "Cannot set for both -c and -nc options"
		fi
		PROCESSCONFIGURE="No"
		CONFIGASPARAM="Yes"
		shift
		;;
	-g|--g)
		if [ $GITASPARAM = "Yes" ];
		then
			Error-Message "Cannot set for both -g and -ng options"
		fi
		PERFORMGITPULL="Yes"
		GITASPARAM="Yes"
		shift
		;;		
	-ng|--ng)
		if [ $GITASPARAM = "Yes" ];
		then
			Error-Message "Cannot set for both -g and -ng options"
		fi
		PERFORMGITPULL="No"
		GITASPARAM="Yes"
		shift
		;;
	-libusb|--libusb)
		if [ $LIBUSBASPARAM = "Yes" ];
		then
			Error-Message "Cannot set for both -libusb and -nlibusb options"
		fi
		PROCESSLIBUSB="Yes"
		LIBUSBASPARAM="Yes"
		shift
		;;	
	-nlibusb|--nlibusb)
		if [ $LIBUSBASPARAM = "Yes" ];
		then
			Error-Message "Cannot set for both -libusb and -nlibusb options"
		fi
		PROCESSLIBUSB="No"
		LIBUSBASPARAM="Yes"
		shift
		;;
	-shared|-dynamic|--shared|--dynamic)
		if [ $SHAREASPARAM = "Yes" ];
		then
			Error-Message "Cannot set for both Dynamic and No Dynamic build"
		fi
		SHAREDBUILD="Yes"
		SHAREASPARAM="Yes"
		shift
		;;
	-nshared|-ndynamic|--nshared|--ndynamic)
		if [ $SHAREASPARAM = "Yes" ];
		then
			Error-Message "Cannot set for both Dynamic and No Dynamic build"
		fi
		SHAREDBUILD="No"
		SHAREASPARAM="Yes"
		shift
		;;
	-static|--static)
		if [ $STATICASPARAM = "Yes" ];
		then
			Error-Message "Cannot set for both Static and No Static build"
		fi
		STATICBUILD="Yes"
		STATICASPARAM="Yes"
		SHAREDBUILD="No"
		SHAREASPARAM="No"
		shift
		;;	
	-nstatic|--nstatic)
		if [ $STATICASPARAM = "Yes" ];
		then
			Error-Message "Cannot set for both Static and No Static build"
		fi
		STATICBUILD="No"
		STATICASPARAM="Yes"
		shift
		;;
	*)
		shift
		;;
	esac
done

# -- handle situation where both static and dynamic parameters set ------------

if [ $SHAREASPARAM = "Yes" ];  
then 
	if [ $STATICASPARAM = "Yes" ];
	then
		Error-Message "Cannot set for both Static and Dynamic build yet"
	fi
fi

#clear

# -- run tool check -----------------------------------------------------------

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

# -- test rigctl.exe and libusb.exe binaries ----------------------------------

Test-Binaries

# -- Finished -----------------------------------------------------------------

Package-Data

# exit script
exit 0
