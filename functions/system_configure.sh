#!/bin/bash

# Automatically set preferred gsettings keys as outlined in the 'gsettings.list' file
# 'gsettings' can be obtained by executing "dconf watch /" and then manually changing settings
function gsettings_config() {
	echo_message info "Setting preferred application-specific & desktop settings..."
	# Variables
	LIST=$(dirname "$0")'/data/gsettings.list'
	while IFS= read line; do
		gsettings set $line
	done <"$LIST"
	# Finished
	echo_message success "Settings changed successfully."
	whiptail --title "Finished" --msgbox "Settings changed successfully." 8 56
	system_configure
}

function make_workspace() {
	echo_message info "Creating workspace folder..."
	mkdir ~/workspace
	echo_message success "Workspace folder created successfully."
	whiptail --title "Finished" --msgbox "Workspace folder created successfully." 8 56
	system_configure
}

# Configure System
function system_configure() {
	NAME="System Configuration"
	echo_message title "Starting ${NAME,,}..."
	# Draw window
	CONFIGURE=$(eval $(resize) && whiptail \
		--notags \
		--title "$NAME" \
		--menu "\nWhat would you like to do?" \
		--cancel-button "Go Back" \
		$LINES $COLUMNS $(($LINES - 12)) \
		'gsettings_config' 'Set preferred application & desktop settings' \
    'make_workspace'   'Create worokspace folder' \
		3>&1 1>&2 2>&3)
	# check exit status
	if [ $? = 0 ]; then
		echo_message header "Starting '$CONFIGURE' function"
		$CONFIGURE
	else
		# Cancelled
		echo_message info "$NAME cancelled."
		main
	fi
}
