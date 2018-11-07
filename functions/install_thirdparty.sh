#!/bin/bash

function import_apps_functions() {
	DIR="functions/apps"
	for FUNCTION in $(dirname "$0")/$DIR/*; do
		if [[ -d $FUNCTION ]]; then
			continue
		elif [[ -f $FUNCTION ]]; then
			. $FUNCTION
		fi
	done
}

function install_thirdparty() {
	NAME="Third-Party Software"
	echo_message title "Starting installation of ${NAME,,}..."
	import_apps_functions
	THIRDPARTY=$(eval $(resize) && whiptail \
		--notags \
		--title "Install $NAME" \
		--menu "\nWhat ${NAME,,} would you like to install?" \
		--ok-button "Install" \
		--cancel-button "Go Back" \
		$LINES $COLUMNS $(($LINES - 12)) \
		'install_wakatime' 'Wakatime' \
		'install_mariadb' 'MariaDB + MySQL Workbench' \
		'install_nvm' 'Node Version Manager' \
		'install_mongodb' 'MongoDB + MongoDB Compass' \
		'install_bluetooth' 'Bluetooth' \
		'install_acpid' 'acpid' \
		'install_firmware' 'Firmwares' \
		'install_cronie' 'Cron' \
		'install_redis' 'Redis Server + ' \
		3>&1 1>&2 2>&3)
	if [ $? = 0 ]; then
		echo_message header "Starting '$THIRDPARTY' function..."
		$THIRDPARTY
	else
		echo_message info "Installation of ${NAME,,} cancelled."
		main
	fi
}
