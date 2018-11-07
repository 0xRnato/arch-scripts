#!/bin/bash

function install_acpid() {
	NAME="Cron"
	echo_message info "Installing $NAME..."
	install_package "Cronie" "cronie" thirdparty
  superuser_do "systemctl enable cronie.service"
  superuser_do "systemctl start cronie.service"
	echo_message success "Installation of $NAME complete."
	whiptail --title "Finished" --msgbox "Installation of $NAME complete." 8 56
	thirdparty
}
