# .bashrc

# User specific aliases and functions

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias sc='systemctl'
alias ww='watch -n1'
alias gvs='gluster volume status'
alias gv='gluster volume'

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi
export TERM='xterm-256color'
export TERM='linux'
