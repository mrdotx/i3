#!/bin/sh

# path:       /home/klassiker/.local/share/repos/i3/i3_tooltip_container.sh
# author:     klassiker [mrdotx]
# github:     https://github.com/mrdotx/i3
# date:       2020-11-01T16:39:50+0100

title="i3 container mode"
message="
<i>resize</i>
  <b>←,→,↑,↓</b> - container
  <b>-,+,=</b>   - gaps
<i>scratchpad</i>
  <b>m</b>       - move to
  <b>c</b>       - cycle
<i>tile</i>
  <b>h</b>       - horizontal
  <b>v</b>       - vertical
<i>sticky</i>
  <b>s</b>       - toggle

<b>q, return, escape, super+space</b> - quit"

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
