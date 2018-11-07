#!/bin/bash

function install_nvm() {
	NAME="Node Version Manager"
	echo_message info "Checking if $NAME already installed..."
	if [ ! -f /usr/share/nvm/init-nvm.sh ]; then
		echo_message info "$NAME is not installed."
		echo 'Proceeding'
		curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
		nvm install --lts
		echo_message success "Installation of $NAME complete."
		whiptail --title "Finished" --msgbox "Installation of $NAME complete." 8 56
		thirdparty
	else
		echo_message info "$NAME already installed."
		whiptail --title "Finished" --msgbox "$NAME is already installed." 8 56
		thirdparty
	fi
}
