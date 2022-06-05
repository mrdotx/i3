#!/bin/sh

# path:   /home/klassiker/.local/share/repos/i3/i3_macros.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/i3
# date:   2022-06-05T18:02:19+0200

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

progress_notification() {
    message="$message$2"

    notify-send \
        -t "$1" \
        -u low  \
        "$title" \
        "$message" \
        -h string:x-canonical-private-synchronous:"$title" \
        -h int:value:"$3"
}

wait_for_max() {
    max_ds="$1"
    after_ds="$3"
    progress="$4"

    while ! wmctrl -l | grep -iq "$2" \
        && [ "$max_ds" -ge 1 ]; do
            sleep .1
            max_ds=$((max_ds - 1))
    done
    progress_notification 0 "" "$((progress-5))"

    while [ "$after_ds" -ge 1 ]; do
        sleep .1
        after_ds=$((after_ds - 1))
    done
    progress_notification 0 "$finished_icon" "$progress"
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
table_width=41
message="
$(i3_helper_table.sh "$table_width" "header" "info")
$(i3_helper_table.sh "$table_width" "w" "" "weather")
$(i3_helper_table.sh "$table_width" "c" "" "corona stats")

$(i3_helper_table.sh "$table_width" "header" "system")
$(i3_helper_table.sh "$table_width" "r" "" "trash")
$(i3_helper_table.sh "$table_width" "b" "襤" "boot next")
$(i3_helper_table.sh "$table_width" "v" "禍" "ventoy")
$(i3_helper_table.sh "$table_width" "t" "" "terminal colors")

$(i3_helper_table.sh "$table_width" "header" "other")
$(i3_helper_table.sh "$table_width" "s" "" "starwars")

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
        table_width=28
        finished_icon=""
        message="\n$(i3_helper_table.sh "$table_width" "header" "autostart")"

        progress_notification 0 \
            "\n$(i3_helper_table.sh "$table_width" "" "" "open web browser")" 10
        firefox-developer-edition &
        wait_for_max 45 "firefox" 5 20

        progress_notification 0 \
            "\n$(i3_helper_table.sh "$table_width" "" "" "open file manager")" 30
        open_terminal 1 "cd $HOME/.local/share/repos; ranger_cd"
        wait_for_max 35 "ranger" 0 40

        progress_notification 0 \
            "\n$(i3_helper_table.sh "$table_width" "" "" "open system info")" 50
        exec_terminal 2 "btop"
        wait_for_max 25 "btop" 0 60

        progress_notification 0 \
            "\n$(i3_helper_table.sh "$table_width" "" "" "open multiplexer")" 70
        open_tmux 1 "cinfo"
        wait_for_max 25 "tmux" 1 80

        progress_notification 0 \
            "\n$(i3_helper_table.sh "$table_width" "" "" "resize multiplexer")" 90
        press_key 3 Super+Ctrl+Up
        progress_notification 2500 "$finished_icon" 100
        ;;
    --mouseaway)
        resolution=$( \
            xrandr \
                | head -n1 \
                | cut -d" " -f8,10 \
                | tr -d ","
        )
        x="${resolution%% *}"
        y="${resolution##* }"

        xdotool mousemove "$x" "$y"
        i3_helper_notify.sh 2500 "$title" "mouse pointer moved to ${x}x${y}"
        ;;
    --kill)
        i3_helper_notify.sh 1 "$title"
        ;;
    *)
        i3_helper_notify.sh 0 "$title" "$message"
        ;;
esac
