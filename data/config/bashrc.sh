# custom ~/.bashrc

# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

# don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=20000
HISTFILESIZE=20000

# Alias definitions.
if [ -f ~/.bash_aliases ]; then
	. ~/.bash_aliases
fi

# tab completion
if ! shopt -oq posix; then
	if [ -f /usr/share/bash-completion/bash_completion ]; then
		. /usr/share/bash-completion/bash_completion
	elif [ -f /etc/bash_completion ]; then
		. /etc/bash_completion
	fi
fi

if [ -f /usr/share/git/completion/git-completion.bash ]; then
	. /usr/share/git/completion/git-completion.bash
fi

if [ -f /usr/share/git/completion/git-prompt.sh ]; then
	. /usr/share/git/completion/git-prompt.sh
fi

# keep environment pollution down
unset safe_term match_lhs

# use colours in the prompt
[[ -f ~/.dir_colors ]] && match_lhs="${match_lhs}$(<~/.dir_colors)"
[[ -f /etc/DIR_COLORS ]] && match_lhs="${match_lhs}$(</etc/DIR_COLORS)"
[[ -z ${match_lhs} ]] &&
	type -P dircolors >/dev/null &&
	match_lhs=$(dircolors --print-database)

if [[ $'\n'${match_lhs} == *$'\n'"TERM "${safe_term}* ]]; then

	if type -P dircolors >/dev/null; then
		if [[ -f ~/.dir_colors ]]; then
			eval $(dircolors -b ~/.dir_colors)
		elif [[ -f /etc/DIR_COLORS ]]; then
			eval $(dircolors -b /etc/DIR_COLORS)
		fi
	fi

	if [ -f /usr/share/git/completion/git-completion.bash ]; then
		PS1='\[\e[32m\][\[\e[m\]\[\e[32m\]\u\[\e[m\]\[\e[32m\]@\[\e[m\]\[\e[32m\]\h\[\e[m\] \[\e[32m\]-\[\e[m\] \[\e[37m\]\W\[\e[m\]$(__git_ps1 " (%s)")\[\e[32m\]]\[\e[m\] \[\e[32m\]>\[\e[m\]\[\e[32m\]>\[\e[m\] '
	else
		PS1='\[\e[32m\][\[\e[m\]\[\e[32m\]\u\[\e[m\]\[\e[32m\]@\[\e[m\]\[\e[32m\]\h\[\e[m\] \[\e[32m\]-\[\e[m\] \[\e[37m\]\W\[\e[m\]\[\e[32m\]]\[\e[m\] \[\e[32m\]>\[\e[m\]\[\e[32m\]>\[\e[m\] '
	fi

else

	if [ -f /usr/share/git/completion/git-completion.bash ]; then
		PS1='[\u@\h - \W$(__git_ps1 " (%s)")] >> '
	else
		PS1='[\u@\h - \W] >> '
	fi

fi
