#!/usr/bin/bash
################################################################################
#
# Title ........: build-hamlib-dll.sh
# Version ......: 3.2.1 
# Description ..: Build Hamlib from GIT-distributed Hamlib Integration Branches
# Project URL ..: https://sourceforge.net/projects/hamlib-sdk/files/Windows/JTSDK-3.2.0-x64-Stream
#
# Based on script in Hamlib ./scripts/build_x64-jtsdk.sh - 
#                 Adjustments Steve I VK3VM 20-2-2021 - 6-9-2021 
#                 Ability to set nbr CPUs Steve I VK3VM 7-4-2021 
#                 Additrion of runtime switches Steve I 8-9-2021
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

# -- Colour Variables ---------------------------------------------------------

# Foreground colors
C_R='\033[01;31m'		# red
C_G='\033[01;32m'		# green
C_Y='\033[01;33m'		# yellow
C_C='\033[01;36m'		# cyan
C_NC='\033[01;37m'		# no color

# -- Process Variables --------------------------------------------------------

export HL_FILENAME='hamlib'
export PACKVER='src'
export BUILD_BASE_DIR='src/hamlib'
PKG_NAME=Hamlib
TODAY=$(date +"%d-%m-%Y")
TIMESTAMP=$(date +"%d-%m-%Y at %R")
BUILDER=$(whoami)
# CPUS=$((`nproc --all`))
DRIVE=`cygpath -w ~ | head -c 1 | tr '[:upper:]' '[:lower:]'`
SRCD="$HOME/${BUILD_BASE_DIR}"
BUILDD="${SRCD}/${PACKVER}"
PREFIX="${JTSDK_TOOLS_F}/hamlib/qt/$QTV"
LIBUSBINC="${libusb_dir_f/:}/include"
LIBUSBD="${libusb_dir_f/:}/MinGW64/dll"
mkdir -p $HOME/src/hamlib/{build,src} >/dev/null 2>&1
PROCESSBOOTSTRAP="Yes"
# PROCESSCONFIGURE="Yes"
PERFORMGITPULL="Yes"

# -- Paths --------------------------------------------------------------------

export PATH=$PATH:$GCCD_F:.

#-----------------------------------------------------------------------------#
# FUNCTIONS                                                                   #
#-----------------------------------------------------------------------------#

# Function: Determine Nbr CPUs to allocate ------------------------------------
Determine-CPUs () {
	CPUREC=$(sed -n 's/.*cpuusage *= *\([^ ]*.*\)/\1/p' < "${JTSDK_CONFIG_F}/Versions.ini")
	export CPUS=$((`nproc --all`))
	if [ "$CPUREC" = "All" ]; 
	then 
		export CPUS=$((`nproc --all`))
	fi
	if [ "$CPUREC" = "Half" ]; 
	then 
		echo "Half"
		NONO=`nproc --all`
		export CPUS=$(($NONO / 2))
		echo $CPUS
	fi
	if [ "$CPUREC" = "Solo" ]; 
	then 
		export CPUS=1
	fi
}

# Function: main script header ------------------------------------------------
Script-Header () {
	echo ''
	echo -e ${C_Y}'---------------------------------------------------------------'
	echo -e ${C_C}"       $SCRIPT_NAME $JTSDK64_VERSION"${C_NC}
	echo -e ${C_Y}'---------------------------------------------------------------'
	echo ''
	echo -e ${C_C}'* This script compiles Dynamic Hamlib Libraries (DLL) for the JTSDK'${C_NC}
	echo ''
	echo -e ${C_R}'* Note:'${C_C}' This script does not deliver DLLs for the JTSDK'${C_NC}
	echo -e ${C_C}'        This script creates a package of usable dyamically linked tools'${C_NC}
	echo ''
	echo -e " SRC Dir ............: ${C_G}$HOME/${BUILD_BASE_DIR}${C_NC}" 
	echo -e " Build Dir ..........: ${C_G}$HOME/${BUILD_BASE_DIR}/$PACKVER/$PACKVER${C_NC}" 
	#echo ''
}

# Function: package data ------------------------------------------------------
Package-Data () {
	PACKVER_TMP="/msys64${HOME}/${BUILD_BASE_DIR}/$PACKVER/${HL_FILENAME}.zip"
	PACKVER_F=${JTSDK_TOOLS_F}${PACKVER_TMP}
	PACKVER_B=${JTSDK_TOOLS}${PACKVER_TMP//'/'/'\'}
	echo ''
	echo -e ${C_NC}'---------------------------------------------------------------'
	echo -e ${C_G}" FINISHED COMPILATION"${C_NC}
	echo -e ${C_NC}'---------------------------------------------------------------'
	echo ''
	echo -e ${C_Y}"Base Information:"${C_NC} 
	echo "" 
	echo -e " Release...............: ${C_G}$RELEASE"${C_NC}
	echo -e " Date .................: ${C_G}$TODAY"${C_NC}
	echo -e " Package ..............: ${C_G}$PKG_NAME"${C_NC}
	echo -e " User .................: ${C_G}$BUILDER"${C_NC}
	echo -e " CPU/Job Count ........: ${C_G}$CPUS"${C_NC}
	echo -e " QT Version ...........: ${C_G}$QTV"${C_NC}
	echo -e " QT Tools/Toolchain ...: ${C_G}$GCCD_F"${C_NC}
	echo -e " QT Directory .........: ${C_G}$QTD_F"${C_NC}
	echo -e " QT Platform ..........: ${C_G}$QTP_F"${C_NC}
	echo -e " SRC Dir ..............: ${C_G}$HOME/${BUILD_BASE_DIR}"${C_NC}
	echo -e " Build Dir ............: ${C_G}$HOME/${BUILD_BASE_DIR}/$PACKVER/$PACKVER"${C_NC}
	echo -e " LibUSB DLL ...........: ${C_G}$LIBUSBD"${C_NC}
	echo ""
	echo -e ${C_Y}"Hamlib Package MSYS2:"${C_NC} 
	echo "" 
	echo " $HOME/${BUILD_BASE_DIR}/$PACKVER/${HL_FILENAME}.zip"
	echo ""
	echo -e ${C_Y}"Windows Path (for copy-and-paste):"${C_NC}
	echo ""
	echo -n " "
	echo $PACKVER_B
	echo ""
}

# Function: tool chain check ---------------------------------------------------
Tool-Check () {
	echo ''
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

# Function: Establish Environment ---------------------------------------------
Establish-Environment () {
	echo -e ${C_NC}'---------------------------------------------------------------'
	echo -e ${C_Y}" ESTABLISHING ENVIRONMENT "${C_NC}
	echo -e ${C_NC}'---------------------------------------------------------------'
	echo ''
	if [ -d "./${BUILD_BASE_DIR}" ]; then
		echo -e '* Base build environment directory exists: '${C_G}${HOME}'/'${BUILD_BASE_DIR} ${C_NC}
		echo ''
	else
		echo '* Establishing base build environment directory: '$HOME
		echo -n '* Removing any pre-existing structures under '$HOME': ' 
		cd ~
		# rm -rf $SRCD
		echo 'Done'
		echo -n '* Creating required directory structure under '$HOME': '
		mkdir ./${BUILD_BASE_DIR}
		cd ./${BUILD_BASE_DIR}
		echo 'Done'
		echo ''
	fi
}

# Function: test rigctl.exe binary --------------------------------------------
Test-RIGCTL () {
	echo ''
	echo -e ${C_NC}'---------------------------------------------------------------'
	echo -e ${C_Y}" TESTING RIGCTL"${C_NC}
	echo -e ${C_NC}'---------------------------------------------------------------'
	echo ''
	echo '* Note: This needs to be checked in a non-MSYS2 environment'
	echo ''
	echo '  --> rigctl.exe executed within a command CMD shell'
	# PACKVER_TMP="/msys64/${HOME}/${BUILD_BASE_DIR}/$PACKVER/$PACKVER/bin/rigctl.exe"
	PACKVER_TMP="/msys64${HOME}/${BUILD_BASE_DIR}/$PACKVER/${HL_FILENAME}/bin/rigctl.exe"
	PACKVER_F=${JTSDK_TOOLS_F}${PACKVER_TMP}
	PACKVER_B=${JTSDK_TOOLS}${PACKVER_TMP//'/'/'\'}
	echo "  --> ${PACKVER_B}"
	echo ''
	export CMDSTRING=$PACKVER_F
	export PARAM=" --version"

	cmd //c $CMDSTRING $PARAM
}

#Function: Perfporm Bootstrap Function ----------------------------------------
function Perform-Bootstrap () {
	# -- run hamlib bootstrap -----------------------------------------------------
	cd "$SRCD/$PACKVER"
	echo ''
	echo -e ${C_NC}'---------------------------------------------------------------'
	echo -e ${C_Y}" RUN BOOTSTRAP [ $PKG_NAME ]"${C_NC}
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

#Function: Clone Repository ---------------------------------------------------
# As long as HLREPO does not = NONE (First added Steve I VK3VM 11-30/5/2020)
#
# Default (no valid entry of hlnone or hlg4wjs or in C:\JTSDK64-Tools\ )
# is the master HAMLIB repository

Clone-Repo () {
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
			
			if [[ -f $SRCD/$PACKVER/bootstrap ]];
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
				git clone https://github.com/Hamlib/Hamlib.git $PACKVER
				
				cd "$SRCD/src"

				# checkout the master branch
				git checkout master
			fi
		else
			# mkdir -p "${BUILDD}"
			if [[ -f ${BUILDD}/bootstrap ]];
			then
				cd "${BUILDD}"
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
	else
		echo '* Option -ng set to disable GIT pulls from repositories'
	fi
}


# Function: Execute ./scripts/build-w64-jtsdk.sh ------------------------------
function Execute-Hamlib-Supplied-Binary () {
	echo ''
	echo -e ${C_NC}'---------------------------------------------------------------'
	echo -e ${C_Y}" TESTING HAMLIB RIGCTL$"{C_NC}
	echo -e ${C_NC}'---------------------------------------------------------------'
	echo ''
	echo '* This may take a several minutes to complete'
	sh $HOME/${BUILD_BASE_DIR}/$PACKVER/scripts/build-w64-jtsdk.sh $PACKVER
}


# Function: Help --------------------------------------------------------------
function Help-Command () {
	echo ''
	echo -e ${C_NC}'---------------------------------------------------------------'
	echo -e ${C_Y}" BUILD-HAMLIB - HELP"${C_NC}
	echo -e ${C_NC}'---------------------------------------------------------------'
	echo ''
	echo '* Command Line Options:'
	echo ''
	echo '  --> -h ........: Help'
	echo '  --> -b / -nb ..: Process / Do Not Process Bootstrap'
	# echo '  --> -nc ......: Do Not Process Configure'
	echo '  --> -g / -ng ..: Do Not Pull/Check Source from GIT Repositories'
	echo ''
	exit 1
}

#------------------------------------------------------------------------------#
# START MAIN SCRIPT                                                            #
#------------------------------------------------------------------------------#

#cd

# -- Process Command Line Options ---------------------------------------------

while [ $# -gt 0 ]; do
    case $1 in
    -h)
        Help-Command
        shift
        ;;
	-b)
		PROCESSBOOTSTRAP="Yes"
        shift
        ;;
	-nb)
		PROCESSBOOTSTRAP="No"
        shift
        ;;
#	-c)
#		PROCESSCONFIGURE="Yes"
#        shift
#        ;;
#	-nc)
#		PROCESSCONFIGURE="No"
#        shift
#        ;;
	-g)
		PERFORMGITPULL="Yes"
        shift
        ;;	
	-ng)
		PERFORMGITPULL="No"
        shift
        ;;
    *)
        shift
        ;;
    esac
done

clear
Determine-CPUs
Script-Header
Tool-Check
Establish-Environment 

# -- Clone the Repositories (if needed) ---------------------------------------

Clone-Repo

# -- Set Release Info ---------------------------------------------------------
# Note: This WILL ONLY WORK ONCE HAMLIB SOURCE IS DOWNLOADED
RELEASE=$(/usr/bin/awk 'BEGIN{FS="["; RS="]"} /\[4\./ {print $2;exit}' $SRCD/$PACKVER/configure.ac)
export HL_FILENAME=hamlib-w64-${RELEASE}

Perform-Bootstrap

# -- Execute ./scripts/build-w64-jtsdk.sh -------------------------------------

Execute-Hamlib-Supplied-Binary

# -- Test rigctl.exe binary ---------------------------------------------------

Test-RIGCTL

# -- Finished -----------------------------------------------------------------

Package-Data

# exit script
exit 0