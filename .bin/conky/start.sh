#!/bin/sh
##########################################################
# Script Name   : start.py
# Description   : Check unseen email and show notification
# Date          : 10/09/2020
# Author        : H.R. Shadhin <dev@hrshadhin.me>
# License       : GPL-3.0
##########################################################

# pause 5 sec
sleep 5

# kill all conky process
killall conky

# start multiple scripts
conky -c "$HOME/.bin/conky/conkyrc" &
conky -c "$HOME/.bin/conky/tcp" &
conky -c "$HOME/.bin/conky/net_speed" & 
conky -c "$HOME/.bin/conky/todo" & 
conky -c "$HOME/.bin/conky/news" & 
conky -c "$HOME/.bin/conky/coins" & exit
