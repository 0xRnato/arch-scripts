#!/bin/bash

function check_package_installed() {
	pacman -Qi $@ | grep "Name" &>/dev/null
	echo $?
}

# ${1} = package, ${2} = return_function
function check_package() {
	if [ $(check_package_installed ${1}) != 0 ]; then
		if (whiptail \
			--title "Install ${1}" \
			--yesno "This function requires '${1}' but it is not present on your system. \n\nWould you like to install it to continue? " 10 64); then
			echo_message info "Installing '${3}'..."
			superuser_do "pacman -S ${1}"
			echo_message success "${1} is installation complete."
			whiptail --title "Finished" --msgbox "Installation of ${1} Flatpak complete." 8 56
			${2}
		else
			echo_message info "Installation of ${1} cancelled."
			${2}
		fi
	else
		echo_message info "Function dependency '${1}' is installed."
	fi
}

function check_os() {
	echo_message header "Starting 'check_os' function"
	echo_message title "Checking which OS you are using..."
	OS_NAME="Linux"
	echo_message info "Current OS is: "$(uname)
	if [[ $(uname) != "$OS_NAME" ]]; then
		echo_message error "You don't appear to be using $OS_NAME! Aborting. :("
		exit 99
	else
		echo_message success "You are using '$OS_NAME'. :D"
	fi
}

function check_distribution() {
	if [[ $(
		which lsb_release &>/dev/null
		echo $?
	) != 0 ]]; then
		echo_message error "\aCan't check which distribution you are using! Aborting."
		echo_message error " Aborting..." && sleep 3 && exit 99
	else
		if lsb_release -ds | grep -qE '(Arch linux)'; then
			echo 'Current distribution is: '$(lsb_release -ds)
			echo_message success "You are using Arch Linux. :D"
			echo "Proceeding."
		else
			echo_message warning "You are using a distribution that may not be compatible with this script set."
			echo_message warning "Proceeding may break your system."
			echo_message question "Are you sure you want to continue? (Y)es, (N)o : " && read REPLY
			case $REPLY in
			[Yy]*)
				echo_message warning "You have been warned."
				;;
			[Nn]*)
				echo_message info "Exiting..."
				exit 99
				;;
			*)
				echo_message error 'Sorry, try again.' && check_distribution
				;;
			esac
		fi
	fi
}

function check_dependencies() {
	echo_message header "Starting 'check_dependencies' function"
	echo_message title "Checking if necessary dependencies are installed..."
	LIST=$(dirname "$0")'/data/dependencies.list'
	for PACKAGE in $(cat $LIST); do
		if [ $(check_package_installed $PACKAGE) != 0 ]; then
			echo_message info "This script requires '$PACKAGE' and it is not present on your system."
			echo_message question 'Would you like to install it to continue? (Y)es, (N)o : ' && read REPLY
			case $REPLY in
			[Yy]*)
				echo_message warning "Requires root privileges"
				sudo pacman -S $PACKAGE
				echo_message success "Package '$PACKAGE' installed."
				;;
			[Nn]*)
				echo_message info "Exiting..."
				exit 99
				;;
			*)
				echo_message error 'Sorry, try again.' && check_dependencies
				;;
			esac
		else
			echo_message info "Dependency '$PACKAGE' is installed."
		fi
	done
	echo_message success "All dependencies are installed. :)"
}

function check_privileges() {
	echo_message header "Starting 'check_privileges' function"
	echo_message title "Checking administrative privileges of current user..."
	if [[ $EUID != 0 ]]; then
		if [[ $(
			groups $USER | grep -q 'sudo'
			echo $?
		) != 0 ]]; then
			echo_message error "This user account doesn't have admin privileges."
			echo_message info "Log in as a user with admin privileges to be able to much of these scripts.."
			echo_message info "Exiting..."
			sleep 5 && exit 99
		else
			echo_message success "Current user has sudo privileges. :)"
		fi
	else
		if command -v whiptail 2>&1 >/dev/null; then
			if (whiptail --title "Root User" --yesno "You are logged in as the root user. This is not recommended.\n\nAre you sure you want to proceed?" 12 56); then
				echo_message warning "You are logged in as the root user. This is not recommended. :/"
			else
				echo_message info "Exiting..."
				exit 99
			fi
		else
			echo_message warning "You are logged in as the root user. This is not recommended. :/"
			read -p "Are you sure you want to proceed? [y/N] " REPLY
			REPLY=${REPLY:-n}
			case $REPLY in
			[Yy]*)
				echo_message info "Proceeding..."
				;;
			[Nn]*)
				echo_message info "Exiting..."
				exit 99
				;;
			*)
				echo_message error 'Sorry, try again.' && check_privileges
				;;
			esac
		fi
	fi
}

function system_checks() {
	check_os
	check_distribution
	check_privileges
	check_dependencies
}
