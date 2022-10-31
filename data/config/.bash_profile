#
# ~/.bash_profile
#

if [ -d "$HOME/.local/bin" ]; then
	PATH="$HOME/.local/bin:$PATH"
fi

if [ -d "$HOME/.bin" ]; then
	PATH="$HOME/.bin:$PATH"
fi

if [ -d "$HOME/go/bin" ]; then
	PATH="$HOME/go/bin:$PATH"
fi

if [ -f "$HOME/workspace/bash-wakatime/bash-wakatime.sh" ]; then
	source $HOME/workspace/bash-wakatime/bash-wakatime.sh
fi

[[ -f ~/.bashrc ]] && . ~/.bashrc

GPG_TTY=$(tty)
VISUAL="nano"
