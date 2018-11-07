#!/bin/bash

function install_mongodb() {
	NAME="MongoDB"
	echo_message info "Installing $NAME..."
	install_package "MongoDB" "	mongodb" thirdparty
  install_package "MongoDB Tools" "mongodb-tools" thirdparty
	install_yaourt_package "MongoDB Compass" "mongodb-compass" thirdparty
	superuser_do "systemctl enable mongod.service"
	superuser_do "systemctl start mongod.service"
	echo_message success "Installation of $NAME complete."
	whiptail --title "Finished" --msgbox "Installation of $NAME complete." 8 56
	thirdparty
}
