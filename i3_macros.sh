#!/bin/sh

# path:   /home/klassiker/.local/share/repos/i3/i3_macros.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/i3
# date:   2023-02-28T12:44:48+0100

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

exec_terminal() {
    i3-msg workspace "$1"
    $TERMINAL -e "$2"
}

open_terminal() {
    exec_terminal "$1" "$SHELL"

    sleep .5
    type_string " $2"
    press_key 1 Return
}

open_tmux() {
    i3_tmux.sh -o "$1" 'shell'
    i3-msg workspace 2
}

exec_tmux() {
    open_tmux "$1"

    sleep .5
    press_key 1 Ctrl+c
    type_string " tput reset; $2"
    press_key 1 Return
}

move_mouse() {
    [ -z "$1" ] \
        && return 1

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

    case "$1" in
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

    case "$2" in
        "")
            message="mouse pointer moved [$position_icon]"
            message="$message\nfrom $(get_mouse_location)"

            "$path"helper/i3_notify.sh 0 "$title" \
                "$message"

            xdotool mousemove "$x" "$y"
            sleep .5

            "$path"helper/i3_notify.sh 2500 "$title" \
                "$message to $(get_mouse_location)"
            ;;
        *)
            xdotool mousemove "$x" "$y"
            ;;
    esac
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
    wait_for_max 45 "firefox" 5 25

    progress_notification 0 \
        "\n$("$path"helper/i3_table.sh \
            "$table_width" "" "" "open file manager")" 35
    open_terminal 1 "ranger_cd $HOME/.local/share/repos"
    wait_for_max 35 "ranger" 0 50

    progress_notification 0 \
        "\n$("$path"helper/i3_table.sh \
            "$table_width" "" "" "open multiplexer")" 55
    open_tmux 1
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
            "$table_width" "" "歷" "nfs mount")" 85
    i3_nfs.sh --autostart
    progress_notification 0 "$finished_icon" 90

    progress_notification 0 \
        "\n$("$path"helper/i3_table.sh \
            "$table_width" "" "" "move mouse pointer")" 95
    move_mouse "topright" 0
    xdotool click 1
    progress_notification 2500 "$finished_icon" 100
}

title="macros"
table_width=41
message="
$("$path"helper/i3_table.sh "$table_width" "header" "system")
$("$path"helper/i3_table.sh "$table_width" "b" "襤" "boot next")
$("$path"helper/i3_table.sh "$table_width" "v" "禍" "ventoy")
$("$path"helper/i3_table.sh "$table_width" "t" "" "terminal colors")

$("$path"helper/i3_table.sh "$table_width" "header" "info")
$("$path"helper/i3_table.sh "$table_width" "w" "" "weather")
$("$path"helper/i3_table.sh "$table_width" "c" "" "corona stats")

$("$path"helper/i3_table.sh "$table_width" "header" "other")
$("$path"helper/i3_table.sh "$table_width" "h" "ﳲ" "telehack")

[<b>q</b>]uit, [<b>return</b>], [<b>escape</b>], [<b>super+print</b>]"

case "$1" in
    --bootnext)
        exec_tmux 1 \
            "$auth efistub.sh -b"
        ;;
    --ventoy)
        exec_tmux 1 \
            "lsblk; ventoy -h"
        type_string \
            "$auth ventoy -u /dev/sd"
        ;;
    --terminalcolors)
        exec_tmux 1 \
            "terminal_colors.sh"
        ;;
    --weather)
        url="wttr.in/?AFq2&format=v2d&lang=de"
        exec_tmux 1 \
            "curl -fsS '$url'"
        ;;
    --coronastats)
        url="https://corona-stats.online?top=30&source=2&minimal=true"
        exec_tmux 1 \
            "curl -fsS '$url' | head -n32"
        ;;
    --telehack)
        url="telehack.com"
        exec_tmux 1 \
            "telnet '$url'"
        ;;
    --autostart)
        autostart
        ;;
    --movemouse)
        move_mouse "$2" "$3"
        ;;
    --kill)
        "$path"helper/i3_notify.sh 1 "$title"
        ;;
    *)
        "$path"helper/i3_notify.sh 0 "$title" "$message"
        ;;
esac
