#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# prompt
PS1='[\u@\h \W]\$ '

# path
export PATH=$HOME/.bin:$HOME/.local/bin:/usr/local/bin:$PATH

# aliases
alias ls='ls --color=auto'
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

