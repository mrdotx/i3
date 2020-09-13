#!/bin/sh

# path:       /home/klassiker/.local/share/repos/i3/i3_tiling.sh
# author:     klassiker [mrdotx]
# github:     https://github.com/mrdotx/i3
# date:       2020-09-13T12:03:23+0200

script=$(basename "$0")
help="$script [-h/--help] -- script for optimal tiling i3 focused window
  Usage:
    $script [--auto/--tile] [command]

  Settings:
    [--auto]  = script runs in background and divides the focuses window
                automatically
    [--tile]  = tile once and execute command
    [command] = application to start

  Examples:
    $script --auto
    $script --tile firefox
    $script --tile $TERMINAL"

split() {
    sleep .1

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
    --auto)
        while true; do
            split \
                && i3-msg -q -t subscribe '[ "window" ]'
        done
        ;;
    --tile)
        shift
        split \
            && "$@" &
        ;;
    *)
        printf "%s\n" "$help"
        exit 1
        ;;
esac
