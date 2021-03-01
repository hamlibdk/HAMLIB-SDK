#!/usr/bin/bash
#
# Title ........: build-hamlib-dll.sh
# Version ......: 3.2.0 Beta
# Description ..: Build Hamlib from GIT-distributed Hamlib Integration Branches
# Project URL ..: https://github.com/KI7MT/jtsdk64-tools-scripts.git
# Hamlib Repo ..: https://github.com/Hamlib/Hamlib.git
#
# Based on script in Hamlib ./scripts/build_x64-jtsdk.sh
#                  Work commenced 20-2-2020 once build_x64-jtsdk.sh available
#
# Concept ......: (c) Greg, Beam, KI7MT, <ki7mt@yahoo.com>
# Author .......: Base (c) 2013 - 2021 Greg, Beam, KI7MT, <ki7mt@yahoo.com>
#				  Enhancements (c) 2021 JTSDK & Hamlib Development Contributors
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

export PACKVER='hamlib-w64-4.2~git'
PKG_NAME=Hamlib
TODAY=$(date +"%d-%m-%Y")
TIMESTAMP=$(date +"%d-%m-%Y at %R")
BUILDER=$(whoami)
# CPUS=$((`nproc --all`))
DRIVE=`cygpath -w ~ | head -c 1 | tr '[:upper:]' '[:lower:]'`
SRCD="$HOME/builds"
BUILDD="$SRCD/$PACKVER"
PREFIX="/$DRIVE/JTSDK64-Tools/tools/hamlib/qt/$QTV"
LIBUSBINC="${libusb_dir_f/:}/include"
LIBUSBD="${libusb_dir_f/:}/MinGW64/dll"
mkdir -p $HOME/src/hamlib/{build,src} >/dev/null 2>&1

CPUREC=$(sed -n 's/.*cpuusage *= *\([^ ]*.*\)/\1/p' < "/$DRIVE/JTSDK64-Tools/config/Versions.ini")
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

# -- QT Tool Chain Paths ------------------------------------------------------
# QTV="$QTV"

export PATH=$PATH:$GCCD_F:.


#-----------------------------------------------------------------------------#
# FUNCTIONS                                                                   #
#-----------------------------------------------------------------------------#

# Function: main script header ------------------------------------------------
Script-Header () {
	echo ''
	echo '---------------------------------------------------------------'
	echo -e ${C_C}" $SCRIPT_NAME $JTSDK64_VERSION"${C_NC}
	echo '---------------------------------------------------------------'
	echo ''
}

# Function: package data ------------------------------------------------------
Package-Data () {
	JTSDK_TOOLS_F=${JTSDK_TOOLS//'\'/'/'}
	PACKVER_F=${JTSDK_TOOLS_F}/msys64${HOME}/builds/$PACKVER/${PACKVER}.zip
	PACKVER_B=${PACKVER_F//'/'/'\'}
	echo " Date .................. $TODAY"
	echo " Package ............... $PKG_NAME"
	echo " User .................. $BUILDER"
	echo " CPU Count ............. 4 [Fixed]"
	echo " QT Version ............ $QTV"
	echo " QT Tools/Toolchain .... $GCCD_F"
	echo " QT Directory .......... $QTD_F"
	echo " QT Platform ........... $QTP_F"
	echo " SRC Dir ............... $HOME/builds"
	echo " Build Dir ............. $HOME/builds/$PACKVER/$PACKVER"
	echo " LibUSB DLL ............ $LIBUSBD"
	echo ""
	echo " Hamlib Package MSYS2 .. $HOME/builds/$PACKVER/$PACKVER.zip"
	echo ""
	echo " Windows Path (for copy-and-paste) "
	echo ""
	echo -n "   "
	echo $PACKVER_B
}

# Function: tool chain check ---------------------------------------------------
Tool-Check () {
	echo ''
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
	echo -e ' Compiler ...... '${C_G}"$(gcc --version |awk 'FNR==1')"${C_NC}
	echo -e ' Bin Utils ..... '${C_G}"$(ranlib --version |awk 'FNR==1')"${C_NC}
	echo -e ' Libtool ....... '${C_G}"$(libtool --version |awk 'FNR==1')"${C_NC}
	echo -e ' Pkg-Config  ... '${C_G}"$(pkg-config --version)"${C_NC}
}

#------------------------------------------------------------------------------#
# START MAIN SCRIPT                                                            #
#------------------------------------------------------------------------------#
#: <<'END'
#END
# -- run tool check -----------------------------------------------------------
cd
clear
Script-Header
Package-Data
Tool-Check

if [ "$?" = "0" ];
then
echo -en " Tool-Chain .... "&& echo -e ${C_G}'OK'${C_NC}
	echo ''
else
	echo ''
	echo -e ${C_R}"TOOL-CHAIN WARNING"${C_NC}
	echo 'There was a problem with the Tool-Chain.'
	echo "$0 Will now exit .."
	exit ''
	exit 1
fi

# -- Create Basic Environment -------------------------------------------------
#

echo '---------------------------------------------------------------'
echo -e ${C_Y} " ESTABLISHING ENVIRONMENT "${C_NC}
echo '---------------------------------------------------------------'
echo ''
echo '* Establishing base build environment directory: '$HOME
echo -n '* Removing any pre-existing structures under '$HOME': ' 
cd ~
rm -rf $SRCD
echo 'Done'
echo -n '* Creating required directory structure under '$HOME': '
mkdir ./builds
cd ./builds
echo 'Done'
echo ''

# -- Start Git clone ----------------------------------------------------------
# As long as HLREPO does not = NONE (First added Steve I VK3VM 11-30/5/2020)
#
# Default (no valid entry of hlnone or hlg4wjs or in C:\JTSDK64-Tools\ )
# is the master HAMLIB repository

echo '---------------------------------------------------------------'
echo -e ${C_Y} " CLONING GIT REPOSITORY [ $HLREPO ]"${C_NC}
echo '---------------------------------------------------------------'
echo ''
if [ "$HLREPO" = "NONE" ];
then 
	echo 'HAMLIB: Use existing: No GIT pull (hlnone} unless no source present'
	echo ''
	cd "$SRCD"
	
	if [[ -f $SRCD/$PACKVER/bootstrap ]];
	then
		echo 'HAMLIB: Static Source detected : GIT pull not attempted.'
		echo ''
	else	 	
		echo 'HAMLIB: Static Source selected : No source detected so MASTER repo pull attempted.'
		echo ''
		# ensure the directory is removed first
		if [[ -d $SRCD/src ]];
		then
			rm -rf "$SRCD/src"
		fi

		# clone the DEFAULT repository
		git clone https://github.com/Hamlib/Hamlib.git $PACKVER
		
		cd "$SRCD/src"

		# checkout the master branch
		git checkout master
	fi
else
	mkdir -p "$BUILDD"
	if [[ -f $SRCD/$PACKVER/bootstrap ]];
	then
		cd "$SRCD/src"
		# git config pull.rebase false   # Merge from Repos
		# git config pull.rebase true	 # Rebase from Repos	
		git config pull.ff only 		 # Base off "fast-forwards" 
		git pull
	else
		cd "$SRCD"

		# ensure the directory is removed first
		if [[ -d $SRCD/$PACKVER ]];
		then
			rm -rf "$SRCD/$PACKVER"
		fi

		# clone the repository
		if [ "$HLREPO" = "G4WJS" ];
		then 
			echo 'HAMLIB: Cloning from G4WJS Repository'
			echo ''
			git clone https://git.code.sf.net/u/bsomervi/hamlib $PACKVER
		else 
			if [ "$HLREPO" = "W9MDB" ];
			then
				echo 'HAMLIB: Cloning from W9MDB Repository'
				echo ''
				git clone https://github.com/mdblack98/Hamlib $PACKVER
			else
				echo 'HAMLIB: Cloning from MASTER Repository'
				echo ''
				git clone https://github.com/Hamlib/Hamlib.git $PACKVER
			fi
		fi 
		
		cd "$SRCD/$PACKVER"

		# checkout the master branch
		git checkout master
	fi
fi

# -- run hamlib bootstrap -----------------------------------------------------
cd "$SRCD/$PACKVER"
echo ''
echo '---------------------------------------------------------------'
echo -e ${C_Y} " RUN BOOTSTRAP [ $PKG_NAME ]"${C_NC}
echo '---------------------------------------------------------------'
echo ''
echo 'Running bootstrap'
./bootstrap

# -- Execute ./scripts/build-w64-jtsdk.sh -------------------------------------
echo ''
echo '---------------------------------------------------------------'
echo -e ${C_Y} " EXECUTING ./scripts/build-w64-jtsdk.sh "${C_NC}
echo '---------------------------------------------------------------'
echo ''
echo '.. This may take a several minutes to complete'
sh $HOME/builds/$PACKVER/scripts/build-w64-jtsdk.sh $PACKVER

# -- test rigctl.exe binary ---------------------------------------------------
echo ''
echo '---------------------------------------------------------------'
echo -e ${C_Y} " TESTING RIGCTL"${C_NC}
echo '---------------------------------------------------------------'
echo ''
echo '* Note: This needs to be checked in a non-MSYS2 environment'
echo ''
echo '  --> rigctl.exe executed within a command CMD shell'
echo ''
JTSDK_TOOLS_F=${JTSDK_TOOLS//'\'/'/'}
PACKVER_F=${JTSDK_TOOLS_F}/msys64/${HOME}/builds/$PACKVER/$PACKVER/bin/rigctl.exe
PACKVER_B=${PACKVER_F//'/'/'\'}
export CMDSTRING=$PACKVER_F
export PARAM=" --version"

cmd //c $CMDSTRING $PARAM

# -- finished -----------------------------------------------------------------
echo ''
echo '----------------------------------------------------------------'
echo -e ${C_G} " FINISHED COMPILATION"${C_NC}
echo '----------------------------------------------------------------'
echo ''
Package-Data
echo ''

# exit script
exit 0