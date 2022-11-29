# custom ~/.bash_aliases

alias ls="ls --color=auto"
alias dir="dir --color=auto"
alias grep="grep --color=auto"
alias dmesg='dmesg --color'

alias ll='ls -l'
alias la='ls -la'
alias l='ls -CF'

alias rm='rm -i'

alias df='df -h'

alias logerrors='sudo journalctl -p 3 -xb'
alias code="code --disable-gpu"
alias git=hub
alias reflector='sudo reflector --verbose -l 5 --sort rate --save /etc/pacman.d/mirrorlist'
