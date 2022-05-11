#!/bin/sh

# path:   /home/klassiker/.local/share/repos/i3/i3_macros.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/i3
# date:   2022-05-11T08:06:29+0200

# auth can be something like sudo -A, doas -- or nothing,
# depending on configuration requirements
auth="${EXEC_AS_USER:-sudo}"

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

wait_for_max() {
    max_ds="$1"
    after_ds="5"
    message_tmp="$message"
    message="$message\n"

    progress_bar() {
        sleep .1
        message="$message█"
        notification 0
    }

    while ! wmctrl -l | grep -iq "$2" \
        && [ "$max_ds" -ge 1 ]; do
            progress_bar
            max_ds=$((max_ds - 1))
    done
    while [ "$after_ds" -ge 1 ]; do
        progress_bar
        after_ds=$((after_ds - 1))
    done

    message="$message_tmp"
}

open_terminal() {
    i3-msg workspace "$1"
    $TERMINAL -e "$SHELL"
    type_string " tput reset; $2"
    press_key 1 Return
}

exec_terminal() {
    i3-msg workspace "$1"
    $TERMINAL -e "$2"
}

open_tmux() {
    i3_tmux.sh -o "$1" 'shell'
    i3-msg workspace 2

    # clear prompt
    sleep .5
    press_key 1 Ctrl+c
    case "$3" in
        1)
            type_string "$2"
            ;;
        *)
            type_string " tput reset; $2"
            ;;
    esac
    press_key 1 Return
}

title="i3 macros mode"
message="
<i>info</i>
  [<b>w</b>]eather
  [<b>c</b>]orona stats

<i>system</i>
  t[<b>r</b>]ash
  [<b>b</b>]oot next
  [<b>v</b>]entoy
  [<b>t</b>]erminal colors

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
        open_tmux 1 \
            "curl -fsS 'wttr.in/?AFq2&format=v2d&lang=de'"
        ;;
    --coronastats)
        open_tmux 1 \
            "curl -fsS 'https://corona-stats.online?top=30&source=2&minimal=true' | head -n32"
        ;;
    --bootnext)
        open_tmux 1 \
            "$auth efistub.sh -b"
        ;;
    --trash)
        open_tmux 1 \
            "fzf_trash.sh" \
            1
            ;;
    --ventoy)
        open_tmux 1 \
            "lsblk; ventoy -h"
        type_string \
            "$auth ventoy -u /dev/sd"
        ;;
    --terminalcolors)
        open_tmux 1 \
            "terminal_colors.sh"
        ;;
    --starwars)
        open_tmux 1 \
            "telnet towel.blinkenlights.nl"
        ;;
    --autostart)
        message="open web browser..." \
            && notification 0
        firefox-developer-edition &
        wait_for_max 45 "firefox"

        message="$message\nopen file manager..." \
            && notification 0
        open_terminal "1" "cd $HOME/.local/share/repos; ranger_cd"
        wait_for_max 35 "ranger"

        message="$message\nopen btop..." \
            && notification 0
        exec_terminal "2" "btop"
        wait_for_max 25 "btop"

        message="$message\nopen multiplexer..." \
            && notification 0
        open_tmux "1" "cinfo"
        press_key 3 Super+Ctrl+Up
        wait_for_max 25 "tmux"

        notification 2000
        ;;
    --kill)
        notification 1
        ;;
    *)
        notification 0
        ;;
esac
