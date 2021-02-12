# script version
AUTHOR="Greg Beam, KI7MT"
JTSDK64_VER="$JTSDK64_VERSION" # interoperability variable from JTSDK64 env
JTSDK64_NAME="JTSDK64 Tools MSYS2"
# Adjustments: Steve VK3VM 16-4-2020 - 11-2-2021 and other JTSDK Contributors

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
alias build-hamlib="bash /home/$USER/bin/build-hamlib.sh"

# Function: Help Menu ---------------------------------------------------------
function jthelp () {

    clear ||:
    echo ''
    echo -e ${C_C}"$JTSDK64_NAME Help Menu"${C_NC}
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
    echo -e ${C_Y}"INSTALL $JTSDK64_NAME PACKAGE LIST"${C_NC}
    echo '---------------------------------------------------------------------'
    echo ''

    # declare the package array
    declare -a pkg_list=("apr" "apr-util" "autoconf" "automake-wrapper" \
    "doxygen" "gettext-devel" "git" "subversion" "libtool" "swig" "libxml2-devel" \
    "make" "libgdbm-devel" "pkg-config" "texinfo" "base-devel" )

    # loop through the pkg_list array and install as needed
    for i in "${pkg_list[@]}"
    do
        pacman -S --needed --noconfirm --disable-download-timeout "$i"
    done

    echo ''
    echo -e ${C_Y}"Finished Package Installation"${C_NC}
    echo ''

}

# Function: version information ------------------------------------------------
function jtversion () {

    clear ||:
    echo ''
    echo -e ${C_C}"$JTSDK64_NAME "${C_NC}
    echo ''
    echo " JTSDK64 Version .. v$JTSDK64_VER"
    echo " Qt Environment ... $QTV"
    echo ''
    echo " Copyright (C) 2013-2021, GPLv3, $AUTHOR & Contributors"
    echo ' This is free software; There is NO warranty; not even'
    echo ' for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.'
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

	# set JTSDK_CONFIG_F = "${JTSDK_CONFIG//\\//}"
	set $JTSDK_CONFIG_F = $JTSDK_CONFIG
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
		echo ' 2 ... G4WJS'
		echo ' 3 ... M9WDB'
		echo ' 4 ... Custom/Your Own (No Pull)'
		echo ''
        echo " e. Enter 'e' or 'q' to exit"
		echo ''
        echo -n "Enter your selection, then hit <return>: "
        read selection
        case "$selection" in
            1)
                rm ${JTSDK_CONFIG//\\//}/hl* 
				touch $JTSDK_CONFIG/hlmaster
				echo 'Repository set to $JTSDK_CONFIG/hlmaster (preferred)'
				clear-hamlib
				echo "On exiting menu close all MSYS2 and jtsdk64.cmd windows to set changes."
				echo ''
                read -p "Press enter to continue..." ;;
            2)
                rm ${JTSDK_CONFIG//\\//}/hl* 
				touch $JTSDK_CONFIG/hlg4wjs
				clear-hamlib
				echo "On exiting menu close all MSYS2 and jtsdk64.cmd windows to set changes."
				echo ''
                read -p "Press enter to continue..." ;;
            3)
                rm ${JTSDK_CONFIG//\\//}/hl* 
				touch $JTSDK_CONFIG/hlw9mdb
				clear-hamlib
				echo "On exiting menu close all MSYS2 and jtsdk64.cmd windows to set changes."
				echo ''
                read -p "Press enter to continue..." ;;
            4)
                rm ${JTSDK_CONFIG//\\//}/hl*
				clear	
				touch $JTSDK_CONFIG/hlnone
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
        echo " 1. List help commands"
        echo " 2. Install Hamlib dependencies"
        echo " 3. Update MSYS2 Keyring"
        echo " 4. Print version information"
        echo " 5. Build Hamlib"
        echo " 6. Update MSYS2"
		echo " 7. Clear Hamlib Source"
		echo " 8. Select HAMLIB Repository"
		echo ''
        echo " e. Enter 'e' or 'q' to exit"
		echo ''
        echo -n "Enter your selection, then hit <return>: "
        read answer
        case "$answer" in
            1)
                jthelp
                read -p "Press enter to continue..." ;;
            2)
                jtsetup
                read -p "Press enter to continue..." ;;
            3)
                msys-keyring
                read -p "Press enter to continue..." ;;
            4)
                jtversion
                read -p "Press enter to continue..." ;;
            5)
                build-hamlib
                read -p "Press enter to continue..." ;;
            6)
                msys-update
                echo ''
                read -p "Press enter to continue..." ;;
			7)
                clear-hamlib
                echo ''
                read -p "Press enter to continue..." ;;
			8)
                change-repo
                echo ''
                read -p "Press enter to continue..." ;;
            e|E|q|Q)
                greeting_message
                break ;;
            *)
        esac
    done
}

function greeting_message (){
    # Display Main Menu
    printf '\033[8;40;100t'
    clear ||:
    echo ''
    echo -e ${C_C}"$JTSDK64_NAME using QT v$QTV"${C_NC}
    echo ''
    echo -e "For main menu, type ..: ${C_C}menu${C_NC}"
    echo -e "For Help Menu, type ..: ${C_C}jthelp${C_NC}"
    echo ''
    echo "Copyright (C) 2013-2021, GPLv3, $AUTHOR and Contributors."
    echo 'This is free software; There is NO warranty; not even'
    echo 'for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.'
	echo ''
	echo '[ Note: Use Menu Option 3 only if pacman update issues observed ]'   
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