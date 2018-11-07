#!/bin/bash

function install_favs_fonts() {
	install_from_list "preferred fonts" "favs-fonts" install_fonts
}

function install_mscorefonts() {
	install_yaourt_package "Microsoft Core Fonts" "ttf-ms-fonts" install_fonts
}

function install_emojione() {
	install_yaourt_package "Emoji One" "ttf-emojione" install_fonts
}

function install_fonts() {
	NAME="Fonts"
	echo_message title "Starting ${NAME,,}..."
	FONTS=$(eval $(resize) && whiptail \
		--notags \
		--title "Install $NAME" \
		--menu "\nWhat would you like to do?" \
		--ok-button "Install" \
		--cancel-button "Go Back" \
		$LINES $COLUMNS $(($LINES - 12)) \
		'install_favs_fonts' 'Install favourite fonts' \
		'install_mscorefonts' 'Install Microsoft core fonts' \
		'install_emojione' 'Install Emoji One colour emoji' \
		3>&1 1>&2 2>&3)
	if [ $? = 0 ]; then
		echo_message header "Starting '$FONTS' function"
		$FONTS
	else
		echo_message info "$NAME installation cancelled."
		main
	fi
}
