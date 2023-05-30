#!/bin/sh

# path:   /home/klassiker/.local/share/repos/i3/i3_macros.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/i3
# date:   2023-05-30T08:41:03+0200

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
            position_icon="󰁛"
            x=0
            y=0
            ;;
        topright)
            position_icon="󰁜"
            x="${resolution%% *}"
            y=0
            ;;
        bottomleft)
            position_icon="󰁂"
            x=0
            y="${resolution##* }"
            ;;
        bottomright)
            position_icon="󰁃"
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

move_window() {
    [ -z "$1" ] \
        && return 1

    margin_x=${2:-0}
    margin_y=${3:-0}

    resolution=$( \
        xrandr \
            | head -n1 \
            | cut -d" " -f8,10 \
            | tr -d ","
    )

    eval "$(xdotool getwindowfocus getwindowgeometry --shell)" \
        && case $1 in
            topleft)
                x="$margin_x"
                y="$margin_y"
                ;;
            topright)
                x="$((${resolution%% *} - WIDTH - margin_x))"
                y="$margin_y"
                ;;
            bottomleft)
                x="$margin_x"
                y="$((${resolution##* } - HEIGHT - margin_y))"
                ;;
            bottomright)
                x="$((${resolution%% *} - WIDTH - margin_x))"
                y="$((${resolution##* } - HEIGHT - margin_y))"
                ;;
        esac \
        && xdotool getactivewindow windowmove "$x" "$y"
}

autostart() {
    table_width=32
    icon_blank="󰄱"
    icon_marked="󰄵"

    progress_message() {
        printf "\n%s" \
            "$("$i3_table" "$table_width" "header" "autostart")"
        printf "\n%s" \
            "$("$i3_table" "$table_width" \
            "${icon_wb:-$icon_blank}" "󰈹" "open web browser")"
        printf "\n%s" \
            "$("$i3_table" "$table_width" \
            "${icon_fm:-$icon_blank}" "󰆍" "open file manager")"
        printf "\n%s" \
            "$("$i3_table" "$table_width" \
            "${icon_m:-$icon_blank}" "󰆍" "open multiplexer")"
        printf "\n%s" \
            "$("$i3_table" "$table_width" \
            "${icon_fd:-$icon_blank}" "󰒍" "mount folder \"Desktop\"")"
        printf "\n%s" \
            "$("$i3_table" "$table_width" \
            "${icon_fm:-$icon_blank}" "󰒍" "mount folder \"Music\"")"
        printf "\n%s" \
            "$("$i3_table" "$table_width" \
            "${icon_fp:-$icon_blank}" "󰒍" "mount folder \"Public\"")"
        printf "\n%s" \
            "$("$i3_table" "$table_width" \
            "${icon_fv:-$icon_blank}" "󰒍" "mount folder \"Videos\"")"
        printf "\n%s" \
            "$("$i3_table" "$table_width" \
            "${icon_mp:-$icon_blank}" "󰆽" "move mouse pointer")"
    }

    progress_bar() {
        "$i3_notify" "${2:-0}" "$title" "$(progress_message)" "$1"
    }

    # open web browser
    progress_bar 10 \
        && ! window_available "firefox" \
        && firefox-developer-edition &

    # open file manager
    progress_bar 20 \
        && ! window_available "ranger" \
        && open_terminal 1 "ranger_cd $HOME/.local/share/repos"

    # mount folder "Desktop"
    progress_bar 30 \
        && i3_nfs.sh --mount "Desktop" \
        && icon_fd="$icon_marked"

    # mount folder "Music"
    progress_bar 35 \
        && i3_nfs.sh --mount "Music" \
        && icon_fm="$icon_marked"

    # mount folder "Public"
    progress_bar 40 \
        && i3_nfs.sh --mount "Public" \
        && icon_fp="$icon_marked"

    # mount folder "Videos"
    progress_bar 45 \
        && i3_nfs.sh --mount "Videos" \
        && icon_fv="$icon_marked"

    # move mouse pointer
    progress_bar 50 \
        && move_mouse "topright" 0 \
        && icon_mp="$icon_marked"

    # wait for file manager
    progress_bar 60 \
        && wait_for_max 35 "ranger" 0 \
        && icon_fm="$icon_marked"

    # wait for web browser
    progress_bar 70 \
        && wait_for_max 45 "firefox" 5 \
        && icon_wb="$icon_marked"

    # open multiplexer
    progress_bar 80 \
        && ! window_available "tmux" \
        && open_tmux 1

    # wait for multiplexer
    progress_bar 90 \
        && wait_for_max 25 "tmux" 0 \
        && icon_m="$icon_marked"

    # completed
    progress_bar 100 2500
}

title="macros"
table_width=41
message="
$("$i3_table" "$table_width" "header" "system")
$("$i3_table" "$table_width" "b" "󰐥" "boot next")
$("$i3_table" "$table_width" "v" "󰕓" "ventoy")
$("$i3_table" "$table_width" "t" "󰂶" "terminal colors")

$("$i3_table" "$table_width" "header" "info")
$("$i3_table" "$table_width" "w" "" "weather")
$("$i3_table" "$table_width" "c" "" "corona stats")

$("$i3_table" "$table_width" "header" "other")
$("$i3_table" "$table_width" "h" "󰟴" "telehack")

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
    --movewindow)
        move_window "$2" "$3" "$4"
        ;;
    --kill)
        "$i3_notify" 1 "$title"
        ;;
    *)
        "$i3_notify" 0 "$title" "$message"
        ;;
esac
