#############
#  ALIASES  #
#############

# go to parent
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# ls variants
alias ls='exa -l'

# dotfiles manage via git bare repo
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# chromium browser profiles
alias browser='chromium --profile-directory="Default" & disown'
alias browser-office='chromium --profile-directory="pro_office" & disown'
alias browser-dev='chromium --profile-directory="pro_dev" & disown'
alias nanu='gedit'
