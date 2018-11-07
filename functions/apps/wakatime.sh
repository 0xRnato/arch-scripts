#!/bin/bash

# Wakatime
function install_wakatime() {
	# Variables
	NAME="Wakatime"
	# Check if already installed
	echo_message info "Checking if $NAME already installed..."
	if [ ! -f ~/workspace/bash-wakatime/bash-wakatime.sh ]; then
		echo_message info "$NAME is not installed."
		echo_message info "Checking if pip and git is already installed..."
		# Checking if pip and git is already installed
		check_package "pip" thirdparty
		check_package "git" thirdparty
		# Install
		echo_message info "Installing $NAME..."
		superuser_do "pip install wakatime"
		git clone https://github.com/gjsheep/bash-wakatime.git ~/workspace/bash-wakatime
		echo_message question "Enter your API key:" && read API_KEY
		echo -e "\n[settings]\napi_key = $API_KEY\nstatus_bar_icon = true" >~/.wakatime.cfg
		# Done
		echo_message success "Installation of $NAME complete."
		whiptail --title "Finished" --msgbox "Installation of $NAME complete." 8 56
		thirdparty
	else
		# Already installed
		echo_message info "$NAME already installed."
		whiptail --title "Finished" --msgbox "$NAME is already installed." 8 56
		thirdparty
	fi
}
