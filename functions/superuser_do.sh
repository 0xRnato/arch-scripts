#!/bin/bash

function superuser_do() {
	echo_message header "Starting 'superuser_do' function"
	if [[ $EUID == 0 ]]; then
		echo_message warning "You are logged in as the root user. Again, this is not recommended. :/"
		$@
	else
		if [ $(sudo -n uptime 2>&1 | grep 'a password is required' | wc -l) != 0 ]; then
			echo_message warning 'Admin privileges required.'
			PASSWORD=$(whiptail --title "Password Required" --passwordbox "\nRequires admin privileges to continue. \n\nPlease enter your password:\n" 12 48 3>&1 1>&2 2>&3)
			if [ $? = 0 ]; then
				COUNT=0
				MAXCOUNT=3
				while [ $COUNT -lt $MAXCOUNT ]; do
					if [[ $(sudo -S echo <<<"$PASSWORD") -ne 0 ]]; then
						echo_message warning "Incorrect password."
						PASSWORD=$(whiptail --title "Password Error" --passwordbox "\nThe password you provided was not correct.\n\nPlease enter your password again:\n" 12 48 3>&1 1>&2 2>&3)
						if [ $? = 1 ]; then
							echo_message error "Password prompt cancelled. Aborting..."
							main
						fi
						let COUNT=COUNT+1
						if [[ "$COUNT" -eq "$MAXCOUNT" ]]; then
							echo_message error "Too many failed password attempts. Aborting..."
							whiptail --msgbox "Too many failed password attempts. Please try again." --title "Oops" 8 56
							main
						fi
					else
						sudo ${@}
						break
					fi
				done
			else
				echo_message error "Password prompt cancelled. Aborting..."
				whiptail --msgbox "Password is required to proceed. Please try again." --title "Oops" 8 56
				main
			fi
		else
			echo_message info "Admin privileges not required at this time."
			sudo $@
		fi
	fi
}
