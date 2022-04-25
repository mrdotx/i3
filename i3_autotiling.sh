#!/bin/sh

# path:   /home/klassiker/.local/share/repos/i3/i3_autotiling.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/i3
# date:   2022-04-25T10:29:20+0200

# speed up script by using standard c
LC_ALL=C
LANG=C

script=$(basename "$0")
help="$script [-h/--help] -- script for optimal tiling focused window
  Usage:
    $script [-w] [-t] [command]

  Settings:
    without given settings, script runs in the background and divides the focused
    window automatically
    [-w]      = auto tiling only defined workspaces
    [-t]      = auto tiling once and execute command
    [command] = application to start

  Examples:
    $script
    $script -w 1 4 5 7 8 9
    $script -t $TERMINAL"

split() {
    window_geometry=$(xdotool getwindowfocus getwindowgeometry \
        | grep -oE '[0-9]{1,4}x[0-9]{1,4}' \
    )

    case $? in
        0)
            window_x=${window_geometry%%x*}
            window_y=${window_geometry##*x}

            if [ "$window_x" -ge "$window_y" ]; then
                i3-msg -q split h
            else
                i3-msg -q split v
            fi
            ;;
    esac
}

autotiling() {
    active_workspace=$(wmctrl -d \
        | awk '$2=="*" {print $9}' \
    )

    case $? in
        0)
            for workspace in "$@"; do
                [ "$active_workspace" -eq "$workspace" ] \
                    && printf 1 \
                    && break
            done
            ;;
    esac
}

case "$1" in
    -h | --help)
        printf "%s\n" "$help"
        ;;
    -w)
        shift
        while true; do
            [ "$(autotiling "$@")" -eq 1 ] \
                && split

            i3-msg -q -t subscribe '[ "window" ]'
        done
        ;;
    -t)
        shift
        split \
            && "$@" &
        ;;
    *)
        while true; do
            split \
                && i3-msg -q -t subscribe '[ "window" ]'
        done
        ;;
esac
