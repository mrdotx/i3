#!/bin/sh

# path:   /home/klassiker/.local/share/repos/i3/i3_autotiling.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/i3
# date:   2022-04-10T08:20:37+0200

# speed up script by not using unicode
LC_ALL=C
LANG=C

script=$(basename "$0")
help="$script [-h/--help] -- script for optimal tiling focused window
  Usage:
    $script [--tile] [command]

  Settings:
    without given settings, script runs in background and divides the focused window
    automatically
    [--tile]  = tile once and execute command
    [command] = application to start

  Examples:
    $script
    $script --tile firefox
    $script --tile $TERMINAL"

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

case "$1" in
    -h | --help)
        printf "%s\n" "$help"
        ;;
    --tile)
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
