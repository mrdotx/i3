#!/bin/sh

# path:       /home/klassiker/.local/share/repos/i3/i3_tiling.sh
# author:     klassiker [mrdotx]
# github:     https://github.com/mrdotx/i3
# date:       2020-05-05T14:41:30+0200

script=$(basename "$0")
help="$script [-h/--help] -- script for optimal tiling i3 focused window
  Usage:
    $script [command]

    without command, the script runs in background and divides the focused
    window automatically

  Settings:
    [command] = open application in new window

  Examples:
    $script
    $script firefox
    $script $TERMINAL"

dim() {
    w_dim=$(xdotool getwindowfocus getwindowgeometry | grep Geometry: | awk -F ': ' '{print $2}')
    x=$(printf "%s" "$w_dim" | awk -F 'x' '{print $1}')
    y=$(printf "%s" "$w_dim" | awk -F 'x' '{print $2}')
}

split() {
    if [ "$x" -gt "$y" ]; then
        i3-msg -q split h
    else
        i3-msg -q split v
    fi
}

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    printf "%s\n" "$help"
    exit 0
elif [ $# -ne 0 ]; then
    dim \
        && split \
        && "$@" &
else
    while true
    do
        dim \
            && split \
            && i3-msg -q -t subscribe '[ "window" ]'
    done
fi
