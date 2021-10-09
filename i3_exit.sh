#!/bin/sh

# path:   /home/klassiker/.local/share/repos/i3/i3_exit.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/i3
# date:   2021-10-09T11:43:33+0200

# suckless simple lock
lock_simple() {
    # workaround (sleep -> https://github.com/i3/i3/issues/3298)
    sleep .5

    # lock the screen
    slock -m "$(cinfo -a)" &
}

# take screenshot, blur it and lock the screen with i3lock
lock_blur() {
    # take screenshot
    sleep .1
    maim -B -u /tmp/screenshot.png

    # blur
    convert /tmp/screenshot.png -scale 10% -blur 0x1.5 -resize 1000% /tmp/screenshot.png

    # lock the screen
    i3lock -i /tmp/screenshot.png
}

title="i3 exit mode"
message="
<i>simple</i>
  l[<b>o</b>]ck
  s[<b>u</b>]spend

<i>blur</i>
  lo[<b>c</b>]k
  sus[<b>p</b>]end

<i>general</i>
  [<b>s</b>]uspend
  [<b>l</b>]ogout
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

# exit or start and kill notification tooltip
case "$1" in
    --lock)
        case "$2" in
            blur)
                lock_blur
                ;;
            simple)
                lock_simple
                ;;
        esac
        ;;
    --suspend)
        case "$2" in
            blur)
                lock_blur \
                    && systemctl suspend
                ;;
            simple)
                lock_simple \
                    && systemctl suspend
                ;;
            *)
                systemctl suspend
                ;;
        esac
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
