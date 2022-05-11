#!/bin/sh

# path:   /home/klassiker/.local/share/repos/i3/i3_helper_notify.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/i3
# date:   2022-05-11T20:02:08+0200

notify-send \
    -u low  \
    -t "$1" \
    -i "dialog-information" \
    "$2" \
    "$3" \
    -h string:x-canonical-private-synchronous:"$2"
