#
# ~/.bash_profile
#

# profile
[[ -f ~/.profile ]] && source ~/.profile

# start wm/de
if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
  exec startx
fi

