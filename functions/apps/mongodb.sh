#!/bin/bash

# MongoDB
function install_mongodb() {
	# Variables
	NAME="MongoDB"
	# Install
	echo_message info "Installing $NAME..."
	install_package "MongoDB" "	mongodb" thirdparty
  install_package "MongoDB Tools" "mongodb-tools" thirdparty
	install_yaourt_package "MongoDB Compass" "mongodb-compass" thirdparty
	superuser_do "systemctl enable mongod.service"
	superuser_do "systemctl start mongod.service"
	# Done
	echo_message success "Installation of $NAME complete."
	whiptail --title "Finished" --msgbox "Installation of $NAME complete." 8 56
	thirdparty
	# Already installed
	echo_message info "$NAME already installed."
	whiptail --title "Finished" --msgbox "$NAME is already installed." 8 56
	thirdparty
}
