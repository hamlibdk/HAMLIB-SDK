#!/usr/bin/bash
################################################################################
#
# Title ........: jtsdk_setup.sh
# Version ......: 3.2.2.6
# Description ..: Setup the MSYS2 Environ for the JTSDK64
# Project URL ..: https://sourceforge.net/projects/hamlib-sdk/files/Windows/JTSDK-3.2-Stream
#
# Updates.......:  20-2-2021 - 15-1-2022 Steve VK3VM / VK3SIR 
#
# Concept ......: (c) Greg, Beam, KI7MT, <ki7mt@yahoo.com>
# Author .......: Base (c) 2013 - 2021 Greg, Beam, KI7MT, <ki7mt@yahoo.com>
#				  Enhancements (c) 2021 - 2022 JTSDK & Hamlib Development Contributors
#
################################################################################

# script version
AUTHOR="Greg Beam, KI7MT and JTSDK Contributors"
JTSDK64_VER="$JTSDK64_VERSION" # interoperability variable from JTSDK64 env
JTSDK64_NAME="JTSDK64 Tools MSYS2"

# foreground colors ------------------------------------------------------------
C_R='\033[01;31m'	# red
C_G='\033[01;32m'	# green
C_Y='\033[01;33m'	# yellow
C_C='\033[01;36m'	# cyan
C_NC='\033[01;37m'	# no color

# Bash Custom Alias Commands ---------------------------------------------------
alias df='df -h'
alias du='du -h'
alias less='less -r'                          # raw control characters
alias whence='type -a'                        # where, of a sort
alias grep='grep --color'                     # show differences in colour
alias egrep='egrep --color=auto'              # show differences in colour
alias fgrep='fgrep --color=auto'              # show differences in colour
alias ls='ls -hF --color=tty'                 # classify files in colour
alias dir='ls --color=auto --format=vertical'
alias vdir='ls --color=auto --format=long'
alias l='ls -CF'                              #
alias ll='ls -l'                              # long list
alias la='ls -A'                              # all but . and ..
alias build-hamlib='bash "build-hamlib.sh"'   # edited to remove -dynamic option 15-1-2022 Steve VK3VM
alias build-hamlib-dll='bash "build-hamlib.sh" -dynamic'
alias build-hamlib-static='bash "build-hamlib.sh" -static'

# Function: Help Menu ---------------------------------------------------------
function jthelp () {

    clear ||:
    echo ''
	echo -e ${C_C}"$JTSDK64_NAME ($MSYSTEM) Help Menu"${C_NC}
    echo ''
    echo 'The following alias commands are available for direct entry'
    echo 'via the MSYS2 Console:'
    echo ''
    echo 'Command              Description'
    echo '-----------------------------------------------------------'
    echo -e ${C_C}"jthelp${C_NC}          Show this help Menu"
    echo -e ${C_C}"jtsetup${C_NC}         Install Hamlib Build Dependencies"
    echo -e ${C_C}"jtversion${C_NC}       Show JTSDK64 MSYS2 Version Information"
    echo -e ${C_C}"build-hamlib${C_NC}    Build Hamlib Libraries and Binaries"
    echo -e ${C_C}"msys-update${C_NC}     Upgrade MSYS2 packages"
    echo -e ${C_C}"menu${C_NC}            Use menu for commands"
    echo ''

}

# Function: install hamlib build dependencies ----------------------------------
function jtsetup () {

    # make directories
    mkdir -p $HOME/src > /dev/null 2>&1

    # start installation
    clear ||:
    echo ''
    echo '---------------------------------------------------------------------'
    echo -e ${C_Y}"INSTALL MSYS2 HAMLIB PACKAGES"${C_NC}
    echo '---------------------------------------------------------------------'
    echo ''

    # declare the package array
    declare -a pkg_list=("apr" "apr-util" "autoconf" "automake-wrapper" "groff" \
    "doxygen" "gettext-devel" "git" "subversion" "libtool" "swig" "libxml2-devel" "bison" \
    "make" "libgdbm-devel" "pkg-config" "texinfo" "base-devel" "zip" "gzip" )

    # loop through the pkg_list array and install as needed
    for i in "${pkg_list[@]}"
    do
        pacman -S --needed --noconfirm --disable-download-timeout "$i"
    done

    echo ''
    echo -e ${C_Y}"Finished Package Installation"${C_NC}
    echo ''

}

# Function: install GNU Compiler build dependencies ---------------------------
function gnusetup () {

    # make directories
    mkdir -p $HOME/src > /dev/null 2>&1

    # start installation
    clear ||:
    echo ''
    echo '---------------------------------------------------------------------'
    echo -e ${C_Y}"INSTALL mingw64 GNU COMPILERS AND COMMON TOOLS"${C_NC}
    echo '---------------------------------------------------------------------'
    echo ''

    # declare the package array
	
	declare -a pkg_list=("mingw-w64-x86_64-toolchain" "mingw-w64-x86_64-cmake" "msys2-w32api-runtime" \
	"mingw-w64-x86_64-extra-cmake-modules" "make" "pkg-config" "openssh" "mingw-w64-x86_64-libnova" )

    # loop through the pkg_list array and install as needed
    for i in "${pkg_list[@]}"
    do
        pacman -S --overwrite "*" --needed --noconfirm --disable-download-timeout "$i"
    done

    echo ''
    echo -e ${C_Y}"Finished Package Installation"${C_NC}
    echo ''

}

# Function: Update JTSDK64 Tools MSYS2 Scripts ---------------------------------
function msys-keyring () {

    clear ||:
    echo ''
    echo '---------------------------------------------------------------------'
    echo -e ${C_Y}"UPGRADE MSYS2 KEYRING"${C_NC}
    echo '---------------------------------------------------------------------'
    echo ''
	curl -O http://repo.msys2.org/msys/x86_64/msys2-keyring-r21.b39fb11-1-any.pkg.tar.xz
	curl -O http://repo.msys2.org/msys/x86_64/msys2-keyring-r21.b39fb11-1-any.pkg.tar.xz.sig
	pacman -U --noconfirm --config <(echo) msys2-keyring-r21.b39fb11-1-any.pkg.tar.xz
	echo '*********************************************************************'
    echo -e ${C_Y}"IF FIRST RUN CLOSE MSYS2 and JTSDK-Setup shells."${C_NC}
	echo -e ${C_Y}"Reopen JTSDK-Tools and then MSYS2 shell."${C_NC}
	echo -e ${C_Y}"You may need to Log-Out and Log-In again to set changes."${C_NC}
	echo '*********************************************************************'
    echo ''
}

# Function: Update all MSYS2 Packages including runtimes -----------------------
function msys-update () {

    clear ||:
    echo ''
    echo '---------------------------------------------------------------------'
    echo -e ${C_Y}"UPGRADE ALL MSYS2 PACKAGES"${C_NC}
    echo '---------------------------------------------------------------------'
    echo ''
    pacman -Syuu --needed --noconfirm --disable-download-timeout
	echo '*********************************************************************'
    echo -e ${C_Y}"IF FIRST RUN CLOSE MSYS2 and JTSDK-Setup shells."${C_NC}
	echo -e ${C_Y}"Reopen JTSDK-Tools and then MSYS2 shell."${C_NC}
	echo -e ${C_Y}"You may need to Log-Out and Log-In again to set changes."${C_NC}
	echo '*********************************************************************'
    echo ''

}

# Function: Clear any pre-existing Hamlib Source -------------------------------
function clear-hamlib () {

    clear ||:
    echo ''
    echo '---------------------------------------------------------------------'
    echo -e ${C_Y}"CLEAR EXISTING HAMLIB SOURCE"${C_NC}
    echo '---------------------------------------------------------------------'
    echo ''
	echo -n 'Clearing ~/src/hamlib: '
    cd ~
	cd ~/src
	rm -rf ~/src/hamlib
	echo 'Done'
    echo ''

}

function change-repo () {

    trap '' 2  # ignore control + c
    while true
    do
		clear ||:
		echo ''
		echo -e ${C_C}"$JTSDK64_NAME "${C_NC}
		echo ''
		echo " JTSDK64 Version ........... $JTSDK64_VER"
		echo " Qt Environment ............ $QTV"
		echo " Current Hamlib Repository.. $HLREPO"	
		echo " JTSDK Output Directory..... $JTSDK_CONFIG"
		echo ''
		echo " Available Repositories:"
		echo ''
		echo ' 1 ... Master (preferred)'
		echo ' 2 ... G4WJS (Now SK so may not be maintained)'
		echo ' 3 ... M9WDB (Bleeding edge - contact Mike W9MDB before use)'
		echo ' 4 ... Custom/Your Own (No Pull)'
		echo ''
        echo " e. Enter 'e' or 'q' to exit"
		echo ''
        echo -n "Enter your selection, then hit <return>: "
        read selection
        case "$selection" in
            1)
                rm ${JTSDK_CONFIG_F}/hl* 
				touch $JTSDK_CONFIG_F/hlmaster
				echo 'Repository set to $JTSDK_CONFIG/hlmaster (preferred)'
				clear-hamlib
				echo "On exiting menu close all MSYS2 and jtsdk64.cmd windows to set changes."
				echo ''
                read -p "Press enter to continue..." ;;
            2)
                rm ${JTSDK_CONFIG_F}/hl* 
				touch $JTSDK_CONFIG_F/hlg4wjs
				clear-hamlib
				echo "On exiting menu close all MSYS2 and jtsdk64.cmd windows to set changes."
				echo ''
                read -p "Press enter to continue..." ;;
            3)
                rm ${JTSDK_CONFIG_F}/hl* 
				touch $JTSDK_CONFIG_F/hlw9mdb
				clear-hamlib
				echo "On exiting menu close all MSYS2 and jtsdk64.cmd windows to set changes."
				echo ''
                read -p "Press enter to continue..." ;;
            4)
                rm ${JTSDK_CONFIG_F}/hl*
				clear	
				touch $JTSDK_CONFIG_F/hlnone
				echo ''
				echo '---------------------------------------------------------------------'
				echo -e ${C_Y}"REPOSITORY SET"${C_NC}
				echo '---------------------------------------------------------------------'
				echo ''
				echo 'Repository set to hlnone (no GIT pull)'
				echo ''
				echo "Previous repository not cleared."
				echo ''
				echo "On exiting menu close all MSYS2 and jtsdk64.cmd windows to set changes."
				echo ''
                read -p "Press enter to continue..." ;;
            e|E|q|Q)
                greeting_message
                break ;;
            *)
        esac
    done

}

# menu for all commands --------------------------------------------------------
function menu () {
    trap '' 2  # ignore control + c
    while true
    do
        clear ||:
        echo "-------------------------------------"
        echo -e ${C_C}"JTSKD64 Tools Main Menu"${C_NC}
        echo  "------------------------------------"
		echo ''
		echo " 1. Set MSYS2 path to find Qt compilers"
		echo " 2. Update MSYS2"
        echo " 3. Install Hamlib dependencies"
		echo " 4. Install msys64 GNU Compilers"
        echo " 5. Update MSYS2 Keyring"
		echo " 6. Build Hamlib - Static Libraries"
        echo " 7. Build Hamlib - Dynamic Package"
		echo " 8. Clear Hamlib Source"
		echo " 9. Select HAMLIB Repository"
		echo " h. List help commands"
		echo " v. List version information"
		echo ''
        echo " e. Enter 'e' or 'q' to exit"
		echo ''
        echo -n "Enter your selection, then hit <return>: "
        read answer
        case "$answer" in
            h|H)
                jthelp
                read -p "Press enter to continue..." ;;
			1)
				export PATH="$GCCD_F:$QTD_F:$QTP_F:$LIBUSBINC:$LIBUSBD:$PATH"
				echo ""
				echo -e ${C_Y}"Added and exported Qt Compilers to Path"${C_NC}
				echo ""
                read -p "Press enter to continue..." ;;
            2)
			    msys-update
                echo ''
                read -p "Press enter to continue..." ;;
            3)
                jtsetup
                read -p "Press enter to continue..." ;;
			4)
                gnusetup
                read -p "Press enter to continue..." ;;
            5)
                msys-keyring
                read -p "Press enter to continue..." ;;
            6)
                build-hamlib-static
				echo ""
				echo -e ${C_R}"CLEAR SOURCE then CLOSE and RESTART MSYS2 IF YOU INTEND TO BUILD DYNAMIC LIBRARIES"${C_NC}
				echo ""
                read -p "Press enter to continue..." ;;
			7)
                build-hamlib-dll
				echo ""
				echo -e ${C_R}"CLEAR SOURCE then CLOSE and RESTART MSYS2 IF YOU INTEND TO BUILD STATIC LIBRARIES"${C_NC}
				echo ""
                read -p "Press enter to continue..." ;;
			8)
                clear-hamlib
                echo ''
                read -p "Press enter to continue..." ;;
			9)
                change-repo
                echo ''
                read -p "Press enter to continue..." ;;
			v|V)
                #jtversion
				greeting_message
                read -p "Press enter to continue..." ;;
            e|E|q|Q)
                greeting_message
                break ;;
            *)
        esac
    done
}

# Display Main Menu
function greeting_message (){
    printf '\033[8;40;100t'
    clear ||:
    echo ''
	echo -ne ${C_C}"$JTSDK64_NAME (${C_Y}$MSYSTEM${C_C})"
	if [ -z "$UNIXTOOLS" ]; then
		echo -ne " "
	else
		if [ $UNIXTOOLS != "Disabled" ]; then
			echo -ne " adding ${C_Y}Qt v$QTV"
		fi
	fi 
	echo -e ${C_NC}
    echo ''
    echo -e "For main menu, type ..: ${C_C}menu${C_NC}"
    echo -e "For Help Menu, type ..: ${C_C}jthelp${C_NC}"
    echo ''
    echo "Copyright (C) 2013-2022, GPLv3, $AUTHOR."
    echo 'This is free software; There is NO warranty; not even'
    echo 'for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.'   
    echo ''
}

# set title function
# Credit: https://superuser.com/questions/362227/how-to-change-the-title-of-the-mintty-window
function settitle() {
      export PS1="\[\e[32m\]\u@\h \[\e[33m\]\w\[\e[0m\]\n$ "
      echo -ne "\e]0;$1\a"
}

# set title path function
# Credit: https://superuser.com/questions/362227/how-to-change-the-title-of-the-mintty-window
function settitlepath() {
      export PS1="\[\e]0;\w\a\]\n\[\e[32m\]\u@\h \[\e[33m\]\w\[\e[0m\]\n$ "
}

# set custom title
settitle "$JTSDK64_NAME"

# print the greeting message
greeting_message