#!/bin/bash

# Perform system upgrade via pacman
function update_system() {
	echo_message title "Performing system update..."
	# Draw window
	if (whiptail --title "System Update" --yesno "Check for system software updates?" 8 56); then
		# Update repository information
		echo_message info 'Refreshing repository information...'
		# Admin privileges
		superuser_do 'pacman -Syy'
		echo_message success 'Repository information updated.'
		# List upgrades
		if [ $(sudo pacman -Qu | wc -l) = 0 ]; then
			# Cancelled
			echo_message info "System is up to date."
			whiptail --title "Finished" --msgbox "No updates available. System is up to date." 8 56
			system_update
		else
			# Move on to package upgrade
			if (eval $(resize) && whiptail \
				--title "System Upgrade" \
				--yesno "Current list of packages to be updated: \n\n$(sudo pacman -Qu | sed 's/\/.*//;/^Listing.../d') \n\nAre you sure you want proceed?" \
				$LINES $COLUMNS $(($LINES - 12)) \
				--scrolltext); then
				# Upgrade
				echo_message info 'Upgrading packages...'
				superuser_do "pacman -Suu"
				# Finished
				echo_message success "System update complete."
				whiptail --title "Finished" --msgbox "System update complete." 8 56
				system_update
			else
				# Cancelled
				echo_message info "System update cancelled."
				system_update
			fi
		fi
	else
		# Cancelled
		echo_message info "Installation of ${2} cancelled."
		system_update
	fi
}

# Check for yaourt updates
function update_yaourt_apps() {
	# check if yaourt is installed
	check_package "yaourt" system_update
	# continue
	echo_message info "Updating installed yaourt packages..."
	yaourt -Syyuua
	if [ $? = 0 ]; then
		# Finished
		echo_message success "All yaourts up to date."
		whiptail --title "Finished" --msgbox "All yaourts up to date." 8 56
		system_update
	else
		# Finished
		echo_message success "yaourt package update complete."
		whiptail --title "Finished" --msgbox "yaourt package update complete." 8 56
		system_update
	fi
}

# Perform system updates
function system_update() {
	# install
	echo_message title "Starting system updates..."
	# Draw window
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

	# check exit status
	if [ $? = 0 ]; then
		echo_message header "Starting '$UPDATE' function..."
		$UPDATE
	else
		# Cancelled
		echo_message info "System updates cancelled."
		main
	fi
}
