#!/bin/sh

# path:       /home/klassiker/.local/share/repos/i3/i3_tooltip_services.sh
# author:     klassiker [mrdotx]
# github:     https://github.com/mrdotx/i3
# date:       2020-11-01T16:39:41+0100

title="i3 services mode"
message="
<i>restart</i>
  <b>d</b> - dunst
<i>enable/disable</i>
  <b>a</b> - autolock
  <b>b</b> - bluetooth
  <b>c</b> - compositor
  <b>f</b> - firewall
  <b>g</b> - gestures
  <b>l</b> - authentication
  <b>m</b> - mousepointer
  <b>n</b> - resolver
  <b>p</b> - printer
  <b>r</b> - rss
  <b>t</b> - tiling
  <b>v</b> - vpn
  <b>y</b> - timesync

<b>q, return, escape, alt+space</b> - quit"

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
