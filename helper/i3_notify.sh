#!/bin/sh

# path:   /home/klassiker/.local/share/repos/i3/helper/i3_notify.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/i3
# date:   2022-06-24T13:14:00+0200

timer="$1"
title="$2 [i3 mode]"
message="$3"
progress="$4"

notification() {
    urgency="$1"
    shift

    notify-send \
        -t "$timer" \
        -u "$urgency" \
        "$title" \
        "$message" \
        -h string:x-canonical-private-synchronous:"$title" \
        "$@"
}

case "$message" in
    "mouse pointer moved to"*)
        notification low
        ;;
    *)
        [ -z "$progress" ] \
            && notification normal \
            && exit 0

        notification low \
            -h int:value:"$progress"
        ;;
esac
