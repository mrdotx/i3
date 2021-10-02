#!/bin/sh

# path:   /home/klassiker/.local/share/repos/i3/i3_macros.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/i3
# date:   2021-10-02T15:10:29+0200

press_key() {
    i="$1"
    shift
    while [ "$i" -ge 1 ]; do
        xdotool key --delay 15 "$@"
        i=$((i-1))
    done
}

type_string() {
    # workaround for mismatched keyboard layouts
    setxkbmap -synch

    printf "%s" "$1" \
        | xdotool type \
            --delay 1 \
            --clearmodifiers \
            --file -
}

change_workspace() {
    i3-msg workspace "$1"
}

open_tmux() {
    i3_tmux.sh -o 1 'shell'
    change_workspace 2

    # increase font size
    [ "$2" = "true" ] \
        && press_key 8 ctrl+plus

    # clear prompt
    sleep .1
    press_key 1 ctrl+c
    type_string " clear; $1"
    press_key 1 return
}

open_autostart() {
    change_workspace 1
    # start web browser
    firefox-developer-edition &

    # start ranger
    $TERMINAL -e "$SHELL"
    type_string " clear; ranger_cd"
    press_key 1 return

    # wait for web browser window
    while ! wmctrl -l | grep -q "Mozilla Firefox"; do
        sleep .1
    done
    sleep .3

    # start tmux
    open_tmux "cinfo" "true"

    change_workspace 1
    # change folder to repos in ranger
    press_key 1 apostrophe r
    change_workspace 2
}

title="i3 macros mode"
message="
<i>info</i>
  [<b>w</b>]eather
  [<b>c</b>]orona stats

<i>system</i>
  [<b>b</b>]oot next
  [<b>v</b>]entoy
  [<b>t</b>]erminal colors
  [<b>n</b>]eofetch

<i>others</i>
  [<b>s</b>]tarwars

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
case "$1" in
    --weather)
        open_tmux \
            "curl -s 'wttr.in/?AFq2&lang=de'"
        ;;
    --coronastats)
        open_tmux \
            "curl -s \
                'https://corona-stats.online?top=30&source=2&minimal=true' \
                | head -n32"
        ;;
    --bootnext)
        open_tmux \
            "doas efistub.sh -b"
        ;;
    --ventoy)
        open_tmux \
            "lsblk; ventoy -h"
        type_string \
            "doas ventoy -u /dev/sdb"
        ;;
    --terminalcolors)
        open_tmux \
            "terminal_colors.sh"
        ;;
    --neofetch)
        open_tmux \
            "neofetch"
        ;;
    --starwars)
        open_tmux \
            "telnet towel.blinkenlights.nl"
        ;;
    --autostart)
        open_autostart
        ;;
    --kill)
        notification 1
        ;;
    *)
        notification 0
        ;;
esac
