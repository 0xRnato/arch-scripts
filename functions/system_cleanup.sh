#!/bin/bash

function purge_unused() {
	NAME="Unused Pre-installed Applications"
	echo_message title "Removing ${NAME,,}..."
	LIST=$(dirname "$0")'/data/purge.list'
	if (eval $(resize) && whiptail \
		--title "Remove $NAME" \
		--yesno "Current list of ${NAME,,} to remove: \n\n$(cat $LIST) \n\nAre you sure you want proceed?" \
		$LINES $COLUMNS $(($LINES - 12)) \
		--scrolltext); then
		for PACKAGE in $(cat $LIST); do
			if [ $(check_package_installed $PACKAGE) != 0 ]; then
				echo_message info "Package '$PACKAGE' already removed."
			else
				echo_message info "'$PACKAGE' is installed. Removing..."
				superuser_do "pacman -Rsn $PACKAGE"
				echo_message success "'$PACKAGE' removal is complete."
			fi
		done
		echo_message success "Removal of ${NAME,,} complete."
		whiptail --title "Finished" --msgbox "Unwanted ${NAME,,} have been removed." 8 56
		system_cleanup
	else
		echo_message success "Removal of ${NAME,,} cancelled."
		system_cleanup
	fi
}

function remove_orphans() {
	echo_message info "Removing orphaned packages..."
	superuser_do "pacman -Rns $(pacman -Qtdq)"
	echo_message success "Removal of orphaned packages complete."
	whiptail --title "Finished" --msgbox "Orphaned packages have been successfully removed." 8 56
	system_cleanup
}

function remove_leftovers() {
	echo_message info "Removing leftover configuration files..."
	superuser_do "pacman -Sc"
	echo_message success "Removal of leftover configuration files complete."
	whiptail --title "Finished" --msgbox "Leftover configuration files have been removed." 8 56
	system_cleanup
}

function clean_pacman_cache() {
	echo_message info "Cleaning package cache..."
	superuser_do "pacman -Scc"
	echo_message success "Package cache cleaned."
	whiptail --title "Finished" --msgbox "Package cache has been cleaned." 8 56
	system_cleanup
}

function system_cleanup() {
	NAME="System Cleanup"
	echo_message title "Starting ${NAME,,}..."
	CLEANUP=$(eval $(resize) && whiptail \
		--notags \
		--title "$NAME" \
		--menu "\nWhat would you like to do?" \
		--cancel-button "Go Back" \
		$LINES $COLUMNS $(($LINES - 12)) \
		clean_pacman_cache 'Clean package cache' \
		remove_orphans 'Remove orphaned packages' \
		remove_leftovers 'Remove leftover configuration files' \
		purge_unused 'Remove unused pre-installed packages' \
		3>&1 1>&2 2>&3)
	if [ $? = 0 ]; then
		echo_message header "Starting '$CLEANUP' function"
		$CLEANUP
	else
		echo_message info "$NAME cancelled."
		main
	fi
}
