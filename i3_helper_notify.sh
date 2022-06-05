#!/bin/sh

# path:   /home/klassiker/.local/share/repos/i3/i3_helper_notify.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/i3
# date:   2022-06-05T18:03:16+0200

notify-send \
    -t "$1" \
    -u low  \
    "$2" \
    "$3" \
    -h string:x-canonical-private-synchronous:"$2"
