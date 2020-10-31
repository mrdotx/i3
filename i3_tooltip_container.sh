#!/bin/sh

# path:       /home/klassiker/.local/share/repos/i3/i3_tooltip_container.sh
# author:     klassiker [mrdotx]
# github:     https://github.com/mrdotx/i3
# date:       2020-10-31T23:45:38+0100

title="i3 container mode"
message="\
←,→,↑,↓ - resize container\n\
-,+,=   - resize gaps\n\
s       - toggle sticky\n\
m       - move to scratchpad\n\
c       - cycle scratchpad\n\
h       - tile horizontal\n\
v       - tile vertical\n\
q       - quit"

notification() {
    notify-send \
        -u low  \
        -t "$1" \
        -i "dialog-question" \
        "$title" \
        "$message" \
        -h string:x-canonical-private-synchronous:"$title"
}

# start and kill notification tooltip
case "$1" in
    --kill)
        notification 1
        ;;
    *)
        notification 0
        ;;
esac
