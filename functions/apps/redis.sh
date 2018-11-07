#!/bin/bash

function install_redis() {
	NAME="Redis"
	echo_message info "Installing $NAME..."
	install_package "Redis Server" "redis" thirdparty
  superuser_do "systemctl enable redis.service"
  superuser_do "systemctl start redis.service"
  install_yaourt_package "Redis Desktop Manager" "redis-desktop-manager" thirdparty
	echo_message success "Installation of $NAME complete."
	whiptail --title "Finished" --msgbox "Installation of $NAME complete." 8 56
	thirdparty
}
