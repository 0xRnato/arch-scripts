#!/bin/bash

function write_bash_aliases() {
	INPUT=$(dirname "$0")'/data/config/bash_aliases.sh'
	if (eval $(resize) && whiptail \
		--title "Preferred Bash Aliases" \
		--yesno "Current list of preferred bash aliases: \n\n$(while read LINE; do echo "  "$LINE; done <$INPUT) \n\nProceed?" \
		$LINES $COLUMNS $(($LINES - 12)) \
		--scrolltext); then
		echo_message info "Setting bash aliases..."
		cp $INPUT ~/.bash_aliases
		echo_message success "Bash aliases set successfully."
		whiptail --title "Finished" --msgbox "Bash aliases set successfully." 8 56
		setup_dotfiles
	else
		setup_dotfiles
	fi
}

function write_bash_profile() {
	INPUT=$(dirname "$0")'/data/config/bash_profile.sh'
	if (eval $(resize) && whiptail \
		--title "Configure Environment Variables" \
		--yesno "Custom config file contains the following: \n\n$(while read LINE; do echo "  "$LINE; done <$INPUT) \n\nOverwrite existing config?" \
		$LINES $COLUMNS $(($LINES - 12)) \
		--scrolltext); then
		echo_message info "Overwriting ~/.bash_profile..."
		cp $INPUT ~/.bash_profile
		echo_message success "Environment variables successfully configured."
		whiptail --title "Finished" --msgbox "Environment variables successfully configured." 8 56
		setup_dotfiles
	else
		setup_dotfiles
	fi
}

function write_bashrc() {
	INPUT=$(dirname "$0")'/data/config/bashrc.sh'
	if (eval $(resize) && whiptail \
		--title "Configure Bash" \
		--yesno "Custom config file contains the following: \n\n$(while read LINE; do echo "  "$LINE; done <$INPUT) \n\nOverwrite existing config?" \
		$LINES $COLUMNS $(($LINES - 12)) \
		--scrolltext); then
		echo_message info "Overwriting ~/.bashrc..."
		cp $INPUT ~/.bashrc
		echo_message success "Bash successfully configured."
		whiptail --title "Finished" --msgbox "Bash successfully configured." 8 56
		setup_dotfiles
	else
		setup_dotfiles
	fi
}

function write_editorconfig() {
	INPUT=$(dirname "$0")'/data/config/.editorconfig'
	if (eval $(resize) && whiptail \
		--title "Configure Text editors" \
		--yesno "Custom config file contains the following: \n\n$(while read LINE; do echo "  "$LINE; done <$INPUT) \n\nOverwrite existing config?" \
		$LINES $COLUMNS $(($LINES - 12)) \
		--scrolltext); then
		echo_message info "Overwriting ~/.editorconfig..."
		cp $INPUT ~/.editorconfig
		echo_message success "Text editors successfully configured."
		whiptail --title "Finished" --msgbox "Text editors successfully configured." 8 56
		setup_dotfiles
	else
		setup_dotfiles
	fi
}

function write_pacman_conf() {
	INPUT=$(dirname "$0")'/data/config/pacman.conf'
	if (eval $(resize) && whiptail \
		--title "Configure Pacman" \
		--yesno "Custom config file contains the following: \n\n$(while read LINE; do echo "  "$LINE; done <$INPUT) \n\nOverwrite existing config?" \
		$LINES $COLUMNS $(($LINES - 12)) \
		--scrolltext); then
		echo_message info "Adding archlinuxcn repository key"
		superuser_do "pacman -Syy"
		superuser_do "pacman -S archlinuxcn-keyring"
		echo_message info "Adding archstrike repository key"
		superuser_do "pacman-key --recv-keys 9D5F1C051D146843CDA4858BDE64825E7CBC0D51"
		superuser_do "pacman-key --finger 9D5F1C051D146843CDA4858BDE64825E7CBC0D51"
		superuser_do "pacman-key --lsign-key 9D5F1C051D146843CDA4858BDE64825E7CBC0D51"
		echo_message info "Adding mobile repository key"
		superuser_do "pacman-key --recv-keys 7943315502A936D7"
		superuser_do "pacman-key --finger 7943315502A936D7"
		superuser_do "pacman-key --lsign-key 7943315502A936D7"
		echo_message info "Adding nexus repository key"
		superuser_do "pacman-key --recv-keys 7448C890582975CD"
		superuser_do "pacman-key --finger 7448C890582975CD"
		superuser_do "pacman-key --lsign-key 7448C890582975CD"
		echo_message info "Saving the new pacman settings"
		superuser_do "cp $INPUT /etc/pacman.conf"
		echo_message success "Pacman successfully configured."
		whiptail --title "Finished" --msgbox "Pacman successfully configured." 8 56
		setup_dotfiles
	else
		setup_dotfiles
	fi
}

function write_pacman_hook() {
	INPUT=$(dirname "$0")'/data/config/pacman.mirrorupgrade.hook'
	if (eval $(resize) && whiptail \
		--title "Configure Pacman Hook" \
		--yesno "Custom config file contains the following: \n\n$(while read LINE; do echo "  "$LINE; done <$INPUT) \n\nOverwrite existing config?" \
		$LINES $COLUMNS $(($LINES - 12)) \
		--scrolltext); then
		echo_message info "Overwriting /etc/pacman.d/hooks/mirrorupgrade.hook..."
		if [ ! -d /etc/pacman.d/hooks ]; then
			superuser_do "mkdir /etc/pacman.d/hooks"
		fi
		superuser_do "cp $INPUT /etc/pacman.d/hooks/mirrorupgrade.hook"
		echo_message success "Pacman hook successfully configured."
		whiptail --title "Finished" --msgbox "Pacman hook successfully configured." 8 56
		setup_dotfiles
	else
		setup_dotfiles
	fi
}

function write_htop_config() {
	INPUT=$(dirname "$0")'/data/config/htoprc'
	if (eval $(resize) && whiptail \
		--title "Configure htop" \
		--yesno "Custom config file contains the following: \n\n$(while read LINE; do echo "  "$LINE; done <$INPUT) \n\nOverwrite existing config?" \
		$LINES $COLUMNS $(($LINES - 12)) \
		--scrolltext); then
		echo_message info "Overwriting ~/.config/htop/htoprc..."
		if [ ! -d ~/.config/htop ]; then
			superuser_do "mkdir ~/.config/htop"
		fi
		superuser_do "cp $INPUT ~/.config/htop/htoprc"
		echo_message success "htop successfully configured."
		whiptail --title "Finished" --msgbox "htop successfully configured." 8 56
		setup_dotfiles
	else
		setup_dotfiles
	fi
}

function write_terminator_config() {
	INPUT=$(dirname "$0")'/data/config/terminator.config'
	if (eval $(resize) && whiptail \
		--title "Configure Terminator" \
		--yesno "Custom config file contains the following: \n\n$(while read LINE; do echo "  "$LINE; done <$INPUT) \n\nOverwrite existing config?" \
		$LINES $COLUMNS $(($LINES - 12)) \
		--scrolltext); then
		echo_message info "Overwriting ~/.config/terminator/config..."
		if [ ! -d ~/.config/terminator ]; then
			superuser_do "mkdir ~/.config/terminator"
		fi
		superuser_do "cp $INPUT ~/.config/terminator/config"
		echo_message success "Terminator successfully configured."
		whiptail --title "Finished" --msgbox "Terminator successfully configured." 8 56
		setup_dotfiles
	else
		setup_dotfiles
	fi
}

function setup_dotfiles() {
	NAME="System Configuration"
	echo_message title "Starting ${NAME,,}..."
	CONFIGURE=$(eval $(resize) && whiptail \
		--notags \
		--title "$NAME" \
		--menu "\nWhat would you like to do?" \
		--cancel-button "Go Back" \
		$LINES $COLUMNS $(($LINES - 12)) \
		'write_bash_profile' 'Configure environment variables' \
		'write_bash_aliases' 'Set custom Bash aliases' \
		'write_bashrc' 'Set custom Bash preferences' \
		'write_editorconfig' 'Set custom editor config' \
		'write_pacman_conf' 'Set custom pacman config' \
		'write_pacman_hook' 'Set pacman hook to update the mirrorlist' \
		'write_htop_config' 'Set htop config' \
		'write_terminator_config' 'Set Terminator config' \
		3>&1 1>&2 2>&3)
	if [ $? = 0 ]; then
		echo_message header "Starting '$CONFIGURE' function"
		$CONFIGURE
	else
		echo_message info "$NAME cancelled."
		main
	fi
}
