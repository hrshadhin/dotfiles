#!/usr/bin/env bash

function run() {
  if ! pgrep -f $1; then
    $@ &
  fi
}

run picom --config $HOME/.config/picom/picom.conf
run rm ~/.fehbg
run feh --randomize --bg-fill $HOME/.backgrounds/*
# run ffplay -nodisp -autoexit /opt/psounds/startup-01.mp3
run /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1
run numlockx
run copyq
run workrave
run redshift-gtk -l manual
run $HOME/.bin/quotes.sh
