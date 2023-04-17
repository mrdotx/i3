#!/bin/sh

# path:   /home/klassiker/.local/share/repos/i3/i3_macros.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/i3
# date:   2023-04-17T17:50:09+0200

# auth can be something like sudo -A, doas -- or nothing,
# depending on configuration requirements
auth="${EXEC_AS_USER:-sudo}"

basename=${0##*/}
path=${0%"$basename"}
i3_table="${path}helper/i3_table.sh"
i3_notify="${path}helper/i3_notify.sh"

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

window_available() {
    wmctrl -l | grep -iq "$1"
}

wait_for_max() {
    max_ds="$1"
    after_ds="$3"

    while ! window_available "$2" \
        && [ "$max_ds" -ge 1 ]; do
            sleep .1
            max_ds=$((max_ds - 1))
    done

    [ "$max_ds" = 0 ] \
        && return 1

    while [ "$after_ds" -ge 1 ]; do
        sleep .1
        after_ds=$((after_ds - 1))
    done
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

            "$i3_notify" 0 "$title" \
                "$message"

            xdotool mousemove "$x" "$y"
            sleep .5

            "$i3_notify" 2500 "$title" \
                "$message to $(get_mouse_location)"
            ;;
        *)
            xdotool mousemove "$x" "$y"
            ;;
    esac
}

autostart() {
    table_width=28
    success_icon=""

    progress_message() {
        printf "\n%s" \
            "$("$i3_table" "$table_width" "header" "autostart")"
        printf "\n%s" \
            "$("$i3_table" "$table_width" "$icon1" "" "open web browser")"
        printf "\n%s" \
            "$("$i3_table" "$table_width" "$icon2" "" "open file manager")"
        printf "\n%s" \
            "$("$i3_table" "$table_width" "$icon3" "" "open multiplexer")"
        printf "\n%s" \
            "$("$i3_table" "$table_width" "$icon4" "歷" "mount nfs")"
        printf "\n%s" \
            "$("$i3_table" "$table_width" "$icon5" "" "move mouse pointer")"
    }

    progress_bar() {
        "$i3_notify" "${2:-0}" "$title" "$(progress_message)" "$1"
    }

    # open web browser and file manager
    progress_bar 5
    ! window_available "firefox" \
        && firefox-developer-edition &
    progress_bar 10
    ! window_available "ranger" \
        && open_terminal 1 "ranger_cd $HOME/.local/share/repos"
    progress_bar 20
    wait_for_max 35 "ranger" 0 \
        && icon2="$success_icon"
    progress_bar 30
    wait_for_max 45 "firefox" 5 \
        && icon1="$success_icon"

    # open multiplexer
    progress_bar 35
    ! window_available "tmux" \
        && open_tmux 1
    progress_bar 40
    wait_for_max 25 "tmux" 1 \
        && icon3="$success_icon"

    # mount nfs
    progress_bar 50
    i3_nfs.sh --mount Desktop \
        && progress_bar 60 \
        && i3_nfs.sh --mount Music \
        && progress_bar 65 \
        && i3_nfs.sh --mount Public \
        && progress_bar 70 \
        && i3_nfs.sh --mount Videos \
        && progress_bar 75 \
        && icon4="$success_icon"

    # move mouse pointer
    progress_bar 85
    move_mouse "topright" 0 \
        && icon5="$success_icon"
    progress_bar 90

    # completed
    progress_bar 100 2500
}

title="macros"
table_width=41
message="
$("$i3_table" "$table_width" "header" "system")
$("$i3_table" "$table_width" "b" "襤" "boot next")
$("$i3_table" "$table_width" "v" "禍" "ventoy")
$("$i3_table" "$table_width" "t" "" "terminal colors")

$("$i3_table" "$table_width" "header" "info")
$("$i3_table" "$table_width" "w" "" "weather")
$("$i3_table" "$table_width" "c" "" "corona stats")

$("$i3_table" "$table_width" "header" "other")
$("$i3_table" "$table_width" "h" "ﳲ" "telehack")

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
        "$i3_notify" 1 "$title"
        ;;
    *)
        "$i3_notify" 0 "$title" "$message"
        ;;
esac
