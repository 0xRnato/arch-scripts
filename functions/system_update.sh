#!/bin/bash

function update_system() {
	echo_message title "Performing system update..."
	if (whiptail --title "System Update" --yesno "Check for system software updates?" 8 56); then
		echo_message info 'Refreshing repository information...'
		superuser_do 'pacman -Syy'
		echo_message success 'Repository information updated.'
		if [ $(sudo pacman -Qu | wc -l) = 0 ]; then
			echo_message info "System is up to date."
			whiptail --title "Finished" --msgbox "No updates available. System is up to date." 8 56
			system_update
		else
			if (eval $(resize) && whiptail \
				--title "System Upgrade" \
				--yesno "Current list of packages to be updated: \n\n$(sudo pacman -Qu | sed 's/\/.*//;/^Listing.../d') \n\nAre you sure you want proceed?" \
				$LINES $COLUMNS $(($LINES - 12)) \
				--scrolltext); then
				echo_message info 'Upgrading packages...'
				superuser_do "pacman -Suu"
				echo_message success "System update complete."
				whiptail --title "Finished" --msgbox "System update complete." 8 56
				system_update
			else
				echo_message info "System update cancelled."
				system_update
			fi
		fi
	else
		echo_message info "Installation of ${2} cancelled."
		system_update
	fi
}

function update_yaourt_apps() {
	check_package "yaourt" system_update
	echo_message info "Updating installed yaourt packages..."
	yaourt -Syyuua
	if [ $? = 0 ]; then
		echo_message success "All yaourts up to date."
		whiptail --title "Finished" --msgbox "All yaourts up to date." 8 56
		system_update
	else
		echo_message success "yaourt package update complete."
		whiptail --title "Finished" --msgbox "yaourt package update complete." 8 56
		system_update
	fi
}

function system_update() {
	echo_message title "Starting system updates..."
	UPDATE=$(eval $(resize) && whiptail \
		--notags \
		--title "Install $NAME" \
		--menu "\nWhat ${NAME,,} would you like to install?" \
		--ok-button "Install" \
		--cancel-button "Go Back" \
		$LINES $COLUMNS $(($LINES - 12)) \
		'update_system' 'Check for system updates' \
		'update_yaourt_apps' 'Check for yaourt app updates' \
		3>&1 1>&2 2>&3)
	if [ $? = 0 ]; then
		echo_message header "Starting '$UPDATE' function..."
		$UPDATE
	else
		echo_message info "System updates cancelled."
		main
	fi
}
