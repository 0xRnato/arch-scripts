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

function keys_settings() {
	echo_message info "Starting SSH Configuration..."
	if [ -d "$HOME/.ssh" ]; then
		echo_message info "SSH already configured."
	else
		mkdir ~/.ssh
		SSHCONFIG_INPUT=$(dirname "$0")'/data/config/keys/ssh.config'
		SSHPUBLIC_INPUT=$(dirname "$0")'/data/config/keys/ssh.public.key'
		SSHPRIVATE_INPUT=$(dirname "$0")'/data/config/keys/ssh.private.key'
		cp $SSHCONFIG_INPUT ~/.ssh/config
		cp $SSHPUBLIC_INPUT ~/.ssh/id_rsa.pub
		cp $SSHPRIVATE_INPUT ~/.ssh/id_rsa
		echo_message info "SSH successfully configured."
	fi
	echo_message info "Starting GPG Configuration..."
	if [ -d "$HOME/.gnupg" ]; then
		echo_message info "GPG already configured."
	else
		gpg --import $(dirname "$0")'/data/config/keys/ssh.private.key'
		echo_message info "GPG successfully configured."
	fi
	echo_message info "Keys successfully configured."
	whiptail --title "Finished" --msgbox "Keys successfully configured." 8 56
	system_configure
}

function git_config() {
	echo_message info "Starting Git Configuration..."
	echo_message question "Enter your GitHub email:" && read GIT_EMAIL
	echo_message question "Enter your GitHub name:" && read GIT_NAME
	echo_message question "Enter your GitHub GPG key ID:" && read GIT_GPG_ID
	git config --global user.email $GIT_EMAIL
	git config --global user.name $GIT_NAME
	git config --global user.signingkey $GIT_GPG_ID
	git config --global commit.gpgsign true
	echo_message info "Testing SSH Connection ..."
	ssh -T git@github.com
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
		'keys_settings' 'SSH and GPG Keys settings' \
		'git_config' 'Configure Git' \
		'make_workspace' 'Create worokspace folder' \
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
