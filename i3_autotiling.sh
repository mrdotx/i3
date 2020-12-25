#!/bin/sh

# path:       /home/klassiker/.local/share/repos/i3/i3_autotiling.sh
# author:     klassiker [mrdotx]
# github:     https://github.com/mrdotx/i3
# date:       2020-12-25T09:23:23+0100

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
        | awk -F ': ' 'NR==3 {print $2}' \
    )
    window_x=${window_geometry%%x*}
    window_y=${window_geometry##*x}

    if [ "$window_x" -ge "$window_y" ]; then
        i3-msg -q split h
    else
        i3-msg -q split v
    fi
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
            sleep .1
            split \
                && i3-msg -q -t subscribe '[ "window" ]'
        done
        ;;
esac
