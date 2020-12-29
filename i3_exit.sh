#!/bin/sh

# path:       /home/klassiker/.local/share/repos/i3/i3_exit.sh
# author:     klassiker [mrdotx]
# github:     https://github.com/mrdotx/i3
# date:       2020-12-29T20:37:24+0100

# suckless simple lock
lock_simple() {
    slock -m "$(cinfo -a)" &
}

# take screenshot, blur it and lock the screen with i3lock
lock_blur() {
    # take screenshot
    maim -B -u /tmp/screenshot.png

    # blur
    convert -scale 10% -blur 0x2.5 -resize 1000% /tmp/screenshot.png /tmp/screenshot_blur.png

    # lock the screen
    i3lock -i /tmp/screenshot_blur.png
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
                lock_blur && systemctl suspend
                ;;
            simple)
                lock_simple && systemctl suspend
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
