#!/bin/sh

# path:       /home/klassiker/.local/share/repos/i3/i3_tooltip_services.sh
# author:     klassiker [mrdotx]
# github:     https://github.com/mrdotx/i3
# date:       2020-10-31T23:45:45+0100

title="i3 services mode"
message="\
a - autolock enable/disable\n\
b - bluetooth enable/disable\n\
c - compositor enable/disable\n\
d - dunst restart\n\
f - firewall enable/disable\n\
g - gestures enable/disable\n\
l - authentication enable/disable\n\
m - mousepointer enable/disable\n\
n - resolver enable/disable\n\
p - printer enable/disable\n\
r - rss enable/disable\n\
t - tiling enable/disable\n\
v - vpn enable/disable\n\
y - timesync enable/disable\n\
q - quit"

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
