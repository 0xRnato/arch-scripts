#!/bin/bash

function install_firmware() {
	NAME="Firmwares"
	echo_message info "Installing $NAME..."
	install_yaourt_package "aic94xx-firmware" "aic94xx-firmware" thirdparty
  install_yaourt_package "wd719x-firmware" "wd719x-firmware" thirdparty
  superuser_do "mkinitcpio -p linux"
	echo_message success "Installation of $NAME complete."
	whiptail --title "Finished" --msgbox "Installation of $NAME complete." 8 56
	thirdparty
}
