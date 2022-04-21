#!/bin/sh

# path:   /home/klassiker/.local/share/repos/i3/i3_container.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/i3
# date:   2022-04-21T12:39:29+0200

# speed up script by using posix
LC_ALL=C
LANG=C

title="i3 container mode"
message="
<i>scratchpad</i>
  [<b>m</b>]ove to
  [<b>c</b>]ycle

<i>tile</i>
  [<b>h</b>]orizontal
  [<b>v</b>]ertical

[<b>q</b>]uit, [<b>return</b>], [<b>escape</b>], [<b>super+space</b>]"

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
