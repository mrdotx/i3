#!/bin/sh

# path:   /home/klassiker/.local/share/repos/i3/i3_exit.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/i3
# date:   2021-11-20T20:23:24+0100

# speed up script by not using unicode
LC_ALL=C
LANG=C

# suckless simple lock
simple_lock() {
    # workaround (sleep -> https://github.com/i3/i3/issues/3298)
    sleep .5

    # lock the screen
    slock -m "$(cinfo -a)" &
}

title="i3 exit mode"
message="
  [<b>l</b>]ock
  [<b>s</b>]uspend
  log[<b>o</b>]ut
  [<b>r</b>]eboot
  shut[<b>d</b>]own

[<b>q</b>]uit, [<b>return</b>], [<b>escape</b>], [<b>ctrl+alt+delete</b>]"

notification() {
    notify-send \
        -u low  \
        -t "$1" \
        -i "dialog-question" \
        "$title" \
        "$message" \
        -h string:x-canonical-private-synchronous:"$title"
}

case "$1" in
    --lock)
        simple_lock
        ;;
    --suspend)
        simple_lock \
            && systemctl suspend
        ;;
    --logout)
        i3-msg exit
        ;;
    --reboot)
        systemctl reboot
        ;;
    --shutdown)
        systemctl poweroff
        ;;
    --kill)
        notification 1
        ;;
    *)
        notification 0
        ;;
esac
