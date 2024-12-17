#!/bin/sh

# path:   /home/klassiker/.local/share/repos/i3/i3_mouse_move.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/i3
# date:   2024-12-17T08:05:12+0100

# speed up script by using standard c
LC_ALL=C
LANG=C

# source i3 helper
. _i3_helper.sh

script=$(basename "$0")
help="$script [-h/--help] -- move mouse pointer to the edge of the monitor
  Usage:
    $script [nw/ne/se/sw] [notification]

  Settings:
    [nw/ne/se/sw]  = position to move the mouse pointer
    [notification] = if the value is specified, suppress notification

  Examples:
    $script ne
    $script ne 0"

get_mouse_location() {
    eval "$(xdotool getmouselocation --shell)"
    printf "%sx%s" "$X" "$Y"
}

move_mouse() {
    [ -z "$1" ] \
        && printf "%s\n" "$help" \
        && return 1

    resolution=$(xrandr \
            | head -n1 \
            | cut -d" " -f8,10 \
            | tr -d ","
        )

    resolution_x=${resolution%% *}
    resolution_y=${resolution##* }

    case "$1" in
        nw)
            position_icon="󰁛"
            x=0
            y=0
            ;;
        ne)
            position_icon="󰁜"
            x="$resolution_x"
            y=0
            ;;
        se)
            position_icon="󰁃"
            x="$resolution_x"
            y="$resolution_y"
            ;;
        sw)
            position_icon="󰁂"
            x=0
            y="$resolution_y"
            ;;
    esac

    case "$2" in
        "")
            title="mouse"
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

case "$1" in
    -h | --help)
        printf "%s\n" "$help"
        exit
        ;;
    *)
        move_mouse "$1" "$2"
        ;;
esac
