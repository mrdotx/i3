#!/bin/sh

# path:   /home/klassiker/.local/share/repos/i3/i3_macros.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/i3
# date:   2023-11-30T07:42:54+0100

# auth can be something like sudo -A, doas -- or nothing,
# depending on configuration requirements
auth="${EXEC_AS_USER:-sudo}"

# i3 helper
. i3_helper.sh

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

    eval "$TERMINAL -T \"$2\" -e $3"
}

open_terminal() {
    exec_terminal "$1" "$2" "$SHELL"

    sleep .5
    type_string " $3"
    press_key 1 Return
}

open_tmux() {
    i3_tmux.sh -o "$1" 'shell'
    i3-msg workspace 2
}

exec_tmux() {
    open_tmux "$2"

    sleep .5
    press_key 1 Ctrl+c
    type_string " tput reset; $1"
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

            i3_notify 0 "$title" "$message"

            xdotool mousemove "$x" "$y"
            sleep .5

            i3_notify 2500 "$title" "$message to $(get_mouse_location)"
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
    table_width=27
    icon_blank="󰄱"
    icon_marked="󰄵"

    progress_message() {
        printf "\n%s" \
            "$(i3_table "$table_width" "header" "mount")"
        printf "\n%s" \
            "$(i3_table "$table_width" \
            "${icon_mfc:-$icon_blank}" "󰒍" "nfs \"Cloud\"")"
        printf "\n%s" \
            "$(i3_table "$table_width" \
            "${icon_mfd:-$icon_blank}" "󰒍" "nfs \"Desktop\"")"
        printf "\n%s" \
            "$(i3_table "$table_width" \
            "${icon_mfm:-$icon_blank}" "󰒍" "nfs \"Music\"")"
        printf "\n%s" \
            "$(i3_table "$table_width" \
            "${icon_mfp:-$icon_blank}" "󰒍" "nfs \"Public\"")"
        printf "\n%s" \
            "$(i3_table "$table_width" \
            "${icon_mfv:-$icon_blank}" "󰒍" "nfs \"Videos\"")"
        printf "\n\n%s" \
            "$(i3_table "$table_width" "header" "open")"
        printf "\n%s" \
            "$(i3_table "$table_width" \
            "${icon_ofm:-$icon_blank}" "󰆍" "file manager")"
        printf "\n%s" \
            "$(i3_table "$table_width" \
            "${icon_om:-$icon_blank}" "󰆍" "multiplexer")"
        printf "\n\n%s" \
            "$(i3_table "$table_width" "header" "move")"
        printf "\n%s" \
            "$(i3_table "$table_width" \
            "${icon_mmp:-$icon_blank}" "󰆽" "mouse pointer")"
    }

    progress_bar() {
        i3_notify_progress "${2:-0}" "$title" "$(progress_message)" "$1"
    }

    # mount folder "Cloud"
    progress_bar 10 \
        && i3_nfs.sh --mount "Cloud" \
        && icon_mfc="$icon_marked"

    # mount folder "Desktop"
    progress_bar 15 \
        && i3_nfs.sh --mount "Desktop" \
        && icon_mfd="$icon_marked"

    # mount folder "Music"
    progress_bar 20 \
        && i3_nfs.sh --mount "Music" \
        && icon_mfm="$icon_marked"

    # mount folder "Public"
    progress_bar 25 \
        && i3_nfs.sh --mount "Public" \
        && icon_mfp="$icon_marked"

    # mount folder "Videos"
    progress_bar 30 \
        && i3_nfs.sh --mount "Videos" \
        && icon_mfv="$icon_marked"

    # open file manager
    progress_bar 50 \
        && ! window_available "ranger" \
        && open_terminal 1 "" "ranger_cd $HOME/.local/share/repos"

    # wait for file manager
    progress_bar 60 \
        && wait_for_max 35 "ranger" 0 \
        && icon_ofm="$icon_marked"

    # open multiplexer
    progress_bar 70 \
        && ! window_available "tmux" \
        && open_tmux 1

    # wait for multiplexer
    progress_bar 80 \
        && wait_for_max 25 "tmux" 0 \
        && icon_om="$icon_marked"

    # move mouse pointer
    progress_bar 90 \
        && move_mouse "topright" 0 \
        && icon_mmp="$icon_marked"

    # completed
    progress_bar 100 2500
}

title="macros"
table_width=41
message="
$(i3_table "$table_width" "header" "system")
$(i3_table "$table_width" "b" "󰐥" "boot next")
$(i3_table "$table_width" "v" "󰕓" "ventoy")

$(i3_table "$table_width" "header" "info")
$(i3_table "$table_width" "w" "" "weather")

$(i3_table "$table_width" "header" "other")
$(i3_table "$table_width" "h" "󰟴" "telehack")

[<b>q</b>]uit, [<b>return</b>], [<b>escape</b>], [<b>super+print</b>]"

case "$1" in
    --bootnext)
        exec_tmux "$auth efistub.sh -b"
        ;;
    --ventoy)
        exec_tmux "lsblk; ventoy -h"
        type_string "$auth ventoy -u /dev/sd"
        ;;
    --weather)
        location_file="/tmp/weather.location"

        grep -q -s '[^[:space:]]' $location_file \
            || curl -fsS 'https://ipinfo.io/city' > $location_file

        url="wttr.in/$(sed 's/ /%20/g' "$location_file")?AFq2&format=v2d"

        exec_tmux "curl -fsS '$url'; printf '\n'; polybar_openweather.sh --terminal"
        ;;
    --telehack)
        url="telehack.com"
        exec_tmux "telnet '$url'"
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
        i3_notify 1 "$title"
        ;;
    *)
        i3_notify 0 "$title" "$message"
        ;;
esac
