#!/bin/bash

function install_mariadb() {
	NAME="MariaDB"
	echo_message info "Installing $NAME..."
	install_package "MariaDB" "mariadb" thirdparty
	install_package "MySQL Workbench" "mysql-workbench" thirdparty
	superuser_do "mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql"
	superuser_do "systemctl enable mariadb.service"
	superuser_do "systemctl start mariadb.service"
	mysql_secure_installation
	echo_message success "Installation of $NAME complete."
	whiptail --title "Finished" --msgbox "Installation of $NAME complete." 8 56
	thirdparty
}
