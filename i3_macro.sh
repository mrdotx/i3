#!/bin/sh

# path:   /home/klassiker/.local/share/repos/i3/i3_macro.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/i3
# date:   2021-07-24T18:11:32+0200

terminal="i3_tmux.sh -o 1 'shell'"

type_string() {
    $1
    sleep .5

    # workaround for mismatched keyboard layouts
    setxkbmap -synch

    printf "%s" "$2" \
        | xdotool type \
            --delay 1 \
            --clearmodifiers \
            --file -

    [ "$3" != false ] \
        && xdotool key Return
}

title="i3 macro mode"
message="
<i>system</i>
  [<b>k</b>]eyboard setup
  [<b>b</b>]oot next
  [<b>v</b>]entoy

<i>info</i>
  [<b>c</b>]olors
  [<b>n</b>]eofetch
  [<b>w</b>]eather
  covid [<b>s</b>]tats

[<b>q</b>]uit, [<b>return</b>], [<b>escape</b>], [<b>super+print</b>]"

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
    --keyboard)
        setxkbmap \
            -model pc105 \
            -layout us,de \
            -option grp:caps_switch
        xset r rate 200 50
        ;;
    --bootnext)
        type_string \
            "$terminal" \
            " clear; doas efistub.sh -b"
        ;;
    --ventoy)
        type_string \
            "$terminal" \
            " clear; lsblk; ventoy -h"
        type_string \
            "$terminal" \
            "doas ventoy -u /dev/sdb" \
            false
        ;;
    --colors)
        type_string \
            "$terminal" \
            " clear; terminal_colors.sh"
        ;;
    --neofetch)
        type_string \
            "$terminal" \
            " clear; neofetch"
        ;;
    --weather)
        type_string \
            "$terminal" \
            " clear; curl -s 'wttr.in/?AFq2&lang=de'"
        ;;
    --covid)
        type_string \
            "$terminal" \
            " clear; curl -s 'https://corona-stats.online?top=30&source=2&minimal=true' | head -n32"
        ;;
    --kill)
        notification 1
        ;;
    *)
        notification 0
        ;;
esac
