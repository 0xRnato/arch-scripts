# custom ~/.bash_profile

if [ -d "$HOME/.local/bin" ]; then
	PATH="$HOME/.local/bin:$PATH"
fi

if [ -d "$HOME/.bin" ]; then
	PATH="$HOME/.bin:$PATH"
fi

if [ -f /usr/share/nvm/init-nvm.sh ]; then
	. /usr/share/nvm/init-nvm.sh
fi

if [ -d "$HOME/go/bin" ]; then
	PATH="$HOME/go/bin:$PATH"
fi

if [ -f ~/workspace/bash-wakatime/bash-wakatime.sh ]; then
	. ~/workspace/bash-wakatime/bash-wakatime.sh
fi

GPG_TTY=$(tty)
VISUAL="nano"
