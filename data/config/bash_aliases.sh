# custom ~/.bash_aliases

# use color
alias ls="ls --color=auto"
alias dir="dir --color=auto"
alias grep="grep --color=auto"
alias dmesg='dmesg --color'

# extended listing
alias ll='ls -l'
alias la='ls -la'
alias l='ls -CF'

# ensure remove confirmations
alias rm='rm -i'

# human readable df
alias df='df -h'

# ignore common typos
alias naon='nano'

alias logerrors='sudo journalctl -p 3 -xb'
alias code="code --disable-gpu"
alias git=hub
