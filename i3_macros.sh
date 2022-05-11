#!/bin/sh

# path:   /home/klassiker/.local/share/repos/i3/i3_macros.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/i3
# date:   2022-05-11T20:14:01+0200

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
        i3_helper_notify.sh 0 "$title" "$message"
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
table_width=37
message="
$(i3_helper_table.sh "header" "$table_width" "info")
$(i3_helper_table.sh "w" "weather")
$(i3_helper_table.sh "c" "corona stats")

$(i3_helper_table.sh "header" "$table_width" "system")
$(i3_helper_table.sh "r" "trash")
$(i3_helper_table.sh "b" "boot next")
$(i3_helper_table.sh "v" "ventoy")
$(i3_helper_table.sh "t" "terminal colors")

$(i3_helper_table.sh "header" "$table_width" "other")
$(i3_helper_table.sh "s" "starwars")

[<b>q</b>]uit, [<b>return</b>], [<b>escape</b>], [<b>super+print</b>]"

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
            && i3_helper_notify.sh 0 "$title" "$message"
        firefox-developer-edition &
        wait_for_max 45 "firefox"

        message="$message\nopen file manager..." \
            && i3_helper_notify.sh 0 "$title" "$message"
        open_terminal "1" "cd $HOME/.local/share/repos; ranger_cd"
        wait_for_max 35 "ranger"

        message="$message\nopen btop..." \
            && i3_helper_notify.sh 0 "$title" "$message"
        exec_terminal "2" "btop"
        wait_for_max 25 "btop"

        message="$message\nopen multiplexer..." \
            && i3_helper_notify.sh 0 "$title" "$message"
        open_tmux "1" "cinfo"
        wait_for_max 25 "tmux"
        press_key 3 Super+Ctrl+Up

        i3_helper_notify.sh 2500 "$title" "$message"
        ;;
    --kill)
        i3_helper_notify.sh 1 "$title"
        ;;
    *)
        i3_helper_notify.sh 0 "$title" "$message"
        ;;
esac
