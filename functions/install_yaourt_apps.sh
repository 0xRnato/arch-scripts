#!/bin/bash

# Install Yaourt Applications
function install_yaourt_apps() {
	NAME="Yaourt Applications"
	echo_message title "Starting installation of ${NAME,,}..."
	status="0"
	while [ "$status" -eq 0 ]; do
		# Draw window
		YAOURT=$(eval $(resize) && whiptail \
			--notags \
			--title "Install $NAME" \
			--menu "\nWhat ${NAME,,} would you like to install?" \
			--ok-button "Install" \
			--cancel-button "Go Back" \
			$LINES $COLUMNS $(($LINES - 12)) \
			'install_yaourt_slack' 'Slack' \
			'install_yaourt_spotify' 'Spotify' \
			'install_yaourt_vscode' 'Visual Studio Code' \
			'install_yaourt_chromium_widevine' 'Chromium Widevine' \
			'install_yaourt_skypeforlinux' 'Skype for Linux' \
			'install_yaourt_stremio' 'Stremio Beta' \
      'install_yaourt_postman' 'Postman' \
			3>&1 1>&2 2>&3)

		case "${YAOURT}" in
		install_yaourt_slack)
			# install Slack
			install_yaourt_package "Slack" "slack-desktop" install_yaourt_apps
			;;
		install_yaourt_spotify)
			# install Spotify
			install_yaourt_package "Spotify" "spotify" install_yaourt_apps
			;;
		install_yaourt_vscode)
			# install VSCode
			install_yaourt_package "Visual Studio Code" "visual-studio-code-bin" install_yaourt_apps
			;;
		install_yaourt_chromium_widevine)
			# install Chromium Widevine
			install_yaourt_package "Chromium Widevine" "chromium-widevine" install_yaourt_apps
			;;
		install_yaourt_skypeforlinux)
			# install Skype for Linux
			install_yaourt_package "Skype for Linux" "skypeforlinux-stable-bin" install_yaourt_apps
			;;
		install_yaourt_stremio)
			# install Stremio
			install_yaourt_package "Stremio Beta" "stremio-beta" install_yaourt_apps
			;;
		install_yaourt_postman)
			# install Postman
			install_yaourt_package "Postman" "postman-bin" install_yaourt_apps
			;;
		*)
			# cancel
			echo_message info "Returning..."
			status=1
			main
			;;
		esac
	done
}
