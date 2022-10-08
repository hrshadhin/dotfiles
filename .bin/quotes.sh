#!/bin/bash
##
# Name: quotes.sh
# Description: show desktop notification of inspiring quotes in time interval
# Date: 07-04-2017 03:00PM
# Author: <H.R.Shadhin>root@hrshadhin.me
##

INTERVAL_IN_MINUTES=30

show_quote() {
    randomId=$(shuf -i 1-30 -n 1)
    message=$(sqlite3 /home/hbot/.bin/things.db "select title,body from message where id=$randomId;")
    IFS='|' read -r -a columns <<<$message
    title=${columns[0]}
    body=${columns[1]}
    /usr/bin/notify-send "$title" "$body" -t 5000
}

iis=$(($INTERVAL_IN_MINUTES * 60))
while true; do
    sleep 5
    show_quote
    sleep $iis
done
