# custom ~/.bash_profile

# if running bash
if [ -n "$BASH_VERSION" ]; then
	# include .bashrc if it exists
	if [ -f "$HOME/.bashrc" ]; then
		. "$HOME/.bashrc"
	fi
fi

# include .local/bin
if [ -d "$HOME/.local/bin" ]; then
	PATH="$HOME/.local/bin:$PATH"
fi

# include .bin
if [ -d "$HOME/.bin" ]; then
	PATH="$HOME/.bin:$PATH"
fi

# include Node Version Manager
if [ -f /usr/share/nvm/init-nvm.sh ]; then
	. /usr/share/nvm/init-nvm.sh
fi

# include go/bin
if [ -d "$HOME/go/bin" ]; then
	PATH="$HOME/go/bin:$PATH"
fi

# include Wakatime
if [ -f ~/workspace/bash-wakatime/bash-wakatime.sh ]; then
	. ~/workspace/bash-wakatime/bash-wakatime.sh
fi

GPG_TTY=$(tty)
VISUAL="nano"
