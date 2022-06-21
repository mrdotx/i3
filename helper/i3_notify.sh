#!/bin/sh

# path:   /home/klassiker/.local/share/repos/i3/helper/i3_notify.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/i3
# date:   2022-06-21T20:20:28+0200

timer="$1"
title="$2 [i3 mode]"
message="$3"
progress="$4"

if [ -z "$progress" ]; then
    notify-send \
        -t "$timer" \
        -u normal \
        "$title" \
        "$message" \
        -h string:x-canonical-private-synchronous:"$title"
else
    notify-send \
        -t "$timer" \
        -u normal \
        "$title" \
        "$message" \
        -h string:x-canonical-private-synchronous:"$title" \
        -h int:value:"$progress"
fi
