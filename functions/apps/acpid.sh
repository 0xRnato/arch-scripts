#!/bin/bash

function install_acpid() {
	NAME="acpid"
	echo_message info "Installing $NAME..."
	install_package "acpid" "acpid" thirdparty
  superuser_do "systemctl enable acpid.service"
  superuser_do "systemctl start acpid.service"
	echo_message success "Installation of $NAME complete."
	whiptail --title "Finished" --msgbox "Installation of $NAME complete." 8 56
	thirdparty
}
