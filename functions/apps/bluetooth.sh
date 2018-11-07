#!/bin/bash

function install_bluetooth() {
	NAME="Bluetooth"
	echo_message info "Installing $NAME..."
	install_package "Bluez" "bluez" thirdparty
	install_package "Bluez Utils" "bluez-utils" thirdparty
  install_package "Bluez Qt" "bluez-qt" thirdparty
  install_package "Bluez Tools" "bluez-tools" thirdparty
	superuser_do "systemctl enable bluetooth.service"
	superuser_do "systemctl start bluetooth.service"
	echo_message success "Installation of $NAME complete."
	whiptail --title "Finished" --msgbox "Installation of $NAME complete." 8 56
	thirdparty
}
