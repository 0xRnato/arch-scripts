#!/bin/bash

function install_gnome_apps() {
	install_from_list "preferred GNOME apps" "gnome-apps" install_gnome
}

function install_shell_extensions() {
	install_from_list "preferred GNOME Shell extensions" "gnome-shell-extensions" install_gnome
}

function install_gnome() {
	NAME="GNOME Software"
	echo_message title "Starting $NAME installation..."
	GNOME=$(eval $(resize) && whiptail \
		--notags \
		--title "Install $NAME" \
		--menu "\nWhich $NAME would you like to install?" \
		--ok-button "Install" \
		--cancel-button "Go Back" \
		$LINES $COLUMNS $(($LINES - 12)) \
		'install_gnome_apps' 'GNOME Core Apps' \
		'install_shell_extensions' 'GNOME Shell Extensions' \
		3>&1 1>&2 2>&3)
	if [ $? = 0 ]; then
		echo_message header "Starting '$GNOME' function"
		$GNOME
	else
		echo_message info "$NAME installation cancelled."
		main
	fi
}
