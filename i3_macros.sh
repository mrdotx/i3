#!/bin/sh

# path:   /home/klassiker/.local/share/repos/i3/i3_macros.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/i3
# date:   2022-07-14T13:31:59+0200

# auth can be something like sudo -A, doas -- or nothing,
# depending on configuration requirements
auth="${EXEC_AS_USER:-sudo}"

basename=${0##*/}
path=${0%"$basename"}

press_key() {
    i="$1"
    shift
    while [ "$i" -ge 1 ]; do
        xdotool key --delay 15 "$@"
        i=$((i - 1))
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

    "$path"helper/i3_notify.sh "$1" "$title" "$message" "$3"
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
    progress_notification 0 "" "$((progress - 5))"

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

mouse_move() {
    resolution=$( \
        xrandr \
            | head -n1 \
            | cut -d" " -f8,10 \
            | tr -d ","
    )

    get_mouse_location() {
        eval "$(xdotool getmouselocation --shell)"
        printf "%sx%s" "$X" "$Y"
    }

    case $1 in
        topleft)
            position_icon=""
            x=0
            y=0
            ;;
        topright)
            position_icon=""
            x="${resolution%% *}"
            y=0
            ;;
        bottomleft)
            position_icon=""
            x=0
            y="${resolution##* }"
            ;;
        bottomright)
            position_icon=""
            x="${resolution%% *}"
            y="${resolution##* }"
            ;;
    esac

    xdotool mousemove "$x" "$y"
    [ -z "$2" ] \
        && "$path"helper/i3_notify.sh 2500 "$title" \
            "mouse pointer moved to $(get_mouse_location) [$position_icon]"
}

autostart() {
    table_width=28
    finished_icon=""
    message="\n$("$path"helper/i3_table.sh \
                "$table_width" "header" "autostart")"

    progress_notification 0 \
        "\n$("$path"helper/i3_table.sh \
            "$table_width" "" "" "open web browser")" 10
    firefox-developer-edition &
    wait_for_max 45 "firefox" 5 20

    progress_notification 0 \
        "\n$("$path"helper/i3_table.sh \
            "$table_width" "" "" "open file manager")" 30
    open_terminal 1 "cd $HOME/.local/share/repos; ranger_cd"
    wait_for_max 35 "ranger" 0 40

    progress_notification 0 \
        "\n$("$path"helper/i3_table.sh \
            "$table_width" "" "" "open multiplexer")" 50
    open_tmux 1 "cinfo"
    wait_for_max 25 "tmux" 1 60

    progress_notification 0 \
        "\n$("$path"helper/i3_table.sh \
            "$table_width" "" "" "open system info")" 65
    exec_terminal 2 "btop"
    wait_for_max 25 "btop" 0 70

    progress_notification 0 \
        "\n$("$path"helper/i3_table.sh \
            "$table_width" "" "" "resize multiplexer")" 75
    press_key 3 Super+Ctrl+Down
    press_key 1 Super+Up
    progress_notification 0 "$finished_icon" 80

    progress_notification 0 \
        "\n$("$path"helper/i3_table.sh \
            "$table_width" "" "禍" "unbind usb3 port")" 85
    fzf_usb.sh --unbind "Bus 003 Device 001"
    progress_notification 0 "$finished_icon" 90

    progress_notification 0 \
        "\n$("$path"helper/i3_table.sh \
            "$table_width" "" "" "move mouse pointer")" 95
    mouse_move "topright" 0
    xdotool click 1
    progress_notification 2500 "$finished_icon" 100
}

title="macros"
table_width=41
message="
$("$path"helper/i3_table.sh "$table_width" "header" "info")
$("$path"helper/i3_table.sh "$table_width" "w" "" "weather")
$("$path"helper/i3_table.sh "$table_width" "c" "" "corona stats")

$("$path"helper/i3_table.sh "$table_width" "header" "system")
$("$path"helper/i3_table.sh "$table_width" "r" "" "trash")
$("$path"helper/i3_table.sh "$table_width" "b" "襤" "boot next")
$("$path"helper/i3_table.sh "$table_width" "v" "禍" "ventoy")
$("$path"helper/i3_table.sh "$table_width" "t" "" "terminal colors")

$("$path"helper/i3_table.sh "$table_width" "header" "other")
$("$path"helper/i3_table.sh "$table_width" "s" "" "starwars")

[<b>q</b>]uit, [<b>return</b>], [<b>escape</b>], [<b>super+print</b>]"

case "$1" in
    --weather)
        url="wttr.in/?AFq2&format=v2d&lang=de"
        open_tmux 1 \
            "curl -fsS '$url'"
        ;;
    --coronastats)
        url="https://corona-stats.online?top=30&source=2&minimal=true"
        open_tmux 1 \
            "curl -fsS '$url' | head -n32"
        ;;
    --bootnext)
        open_tmux 1 \
            "$auth efistub.sh -b"
        ;;
    --trash)
        open_tmux 1 \
            "fzf_trash.sh" 1
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
        autostart
        ;;
    --mousemove)
        mouse_move "$2" "$3"
        ;;
    --kill)
        "$path"helper/i3_notify.sh 1 "$title"
        ;;
    *)
        "$path"helper/i3_notify.sh 0 "$title" "$message"
        ;;
esac
