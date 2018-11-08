#!/bin/bash
# -*- Mode: sh; coding: utf-8; indent-tabs-mode: nil; tab-width: 4 -*-
#
# Authors:
#   Original version by: Sam Hewitt <sam@snwh.org>
#   Arch Linux GNOME version by: Renato Neto <rnato.netoo@gmail.com>
#
# Description:
#   A set of post-installation and configuration script for Arch Linux with GNOME as desktop environment
#
# Legal Preamble:
#
# This script is free software; you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation; version 3.
#
# This script is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
# details.
#
# You should have received a copy of the GNU General Public License along with
# this program; if not, see <https://www.gnu.org/licenses/gpl-3.0.txt>

# tab width
tabs 2
clear

TITLE="Arch Linux GNOME Post-Install Script"

function main() {
	echo_message header "Starting 'main' function"
	MAIN=$(eval $(resize) && whiptail \
		--notags \
		--title "$TITLE" \
		--menu "\nWhat would you like to do?" \
		--cancel-button "Quit" \
		$LINES $COLUMNS $(($LINES - 12)) \
		'system_update' 'Perform system updates' \
		'install_favs' 'Install preferred applications' \
		'install_favs_dev' 'Install preferred development tools' \
		'install_favs_utils' 'Install preferred utilities' \
		'install_favs_yaourt' 'Install packaged from yaourt' \
		'install_codecs' 'Install multimedia codecs' \
		'install_gnome' 'Install preferred GNOME software' \
		'install_fonts' 'Install additional fonts' \
		'install_thirdparty' 'Install third-party applications' \
		'setup_dotfiles' 'Configure dotfiles' \
		'system_configure' 'Configure system' \
		'system_cleanup' 'Cleanup the system' \
		'install_base' 'Install Arch Linux Base' \
		3>&1 1>&2 2>&3)
	if [ $? = 0 ]; then
		echo_message header "Starting '$MAIN' function"
		$MAIN
	else
		quit
	fi
}

function quit() {
	echo_message header "Starting 'quit' function"
	echo_message title "Exiting $TITLE..."
	if (whiptail --title "Quit" --yesno "Are you sure you want quit?" 8 56); then
		echo_message welcome 'Thanks for using!'
		exit 99
	else
		main
	fi
}

function import_functions() {
	DIR="functions"
	for FUNCTION in $(dirname "$0")/$DIR/*; do
		if [[ -d $FUNCTION ]]; then
			continue
		elif [[ $FUNCTION == *.md ]]; then
			continue
		elif [[ -f $FUNCTION ]]; then
			. $FUNCTION
		fi
	done
}

import_functions
echo_message welcome "$TITLE"
system_checks
while :; do
	main
done

#END OF SCRIPT
