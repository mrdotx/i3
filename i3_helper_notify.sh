#!/bin/sh

# path:   /home/klassiker/.local/share/repos/i3/i3_helper_notify.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/i3
# date:   2022-06-07T20:04:01+0200

timer="$1"
title="$2 [i3 mode]"
message="$3"
progress="$4"

if [ -z "$progress" ]; then
    notify-send \
        -t "$timer" \
        -u low  \
        "$title" \
        "$message" \
        -h string:x-canonical-private-synchronous:"$title"
else
    notify-send \
        -t "$timer" \
        -u low  \
        "$title" \
        "$message" \
        -h string:x-canonical-private-synchronous:"$title" \
        -h int:value:"$progress"
fi
