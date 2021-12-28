#!/bin/sh

# path:   /home/klassiker/.local/share/repos/i3/i3_macros.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/i3
# date:   2021-12-28T18:57:39+0100

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

wait_for() {
    after_wait="$2"

    progress_bar() {
        sleep .1
        message="$message\█"
        notification 0
    }

    while ! wmctrl -l | grep -q "$1"; do
        progress_bar
    done
    while [ "$after_wait" -ge 1 ]; do
        progress_bar
        after_wait=$((after_wait - 1))
    done
}

open_terminal() {
    i3-msg workspace "$1"
    $TERMINAL -e "$SHELL"
    type_string " tput reset; $2"
    press_key 1 return
}

open_tmux() {
    i3_tmux.sh -o 1 'shell'
    i3-msg workspace 2

    # increase font size
    [ "$2" = "true" ] \
        && press_key 8 ctrl+plus

    # clear prompt
    sleep .1
    press_key 1 ctrl+c
    type_string " tput reset; $1"
    press_key 1 return
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
            "curl -s 'https://corona-stats.online?top=30&source=2&minimal=true' | head -n32"
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
        message="\open web browser..." \
            && notification 0
        firefox-developer-edition &
        message="$message\n"
        wait_for "Mozilla Firefox" 5

        message="$message\nopen file manager..." \
            && notification 0
        open_terminal "1" "cd $HOME/.local/share/repos; ranger_cd"

        message="$message\nopen multiplexer..." \
            && notification 0
        open_tmux "cinfo" "true"

        notification 1
        ;;
    --kill)
        notification 1
        ;;
    *)
        notification 0
        ;;
esac
