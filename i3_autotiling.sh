#!/bin/sh

# path:   /home/klassiker/.local/share/repos/i3/i3_autotiling.sh
# author: klassiker [mrdotx]
# url:    https://github.com/mrdotx/i3
# date:   2025-10-26T05:39:30+0100

# speed up script by using standard c
LC_ALL=C
LANG=C

script=$(basename "$0")
help="$script [-h/--help] -- script for optimal tiling of focused windows
  Usage:
    $script [-w/-t] [command]

  Settings:
    without options, the script runs in the background and divides the focused
    window automatically
    [-t]      = auto tiling once with defined command
    [-w]      = auto tiling only on defined workspaces by names
    [command] = application to start

  Examples:
    $script
    $script -w 1|2|3|6|7|8|9|0
    $script -t $TERMINAL"

split() {
    i3_window_event=$(i3-msg -t subscribe '[ "window" ]')

    # window event change type (https://i3wm.org/docs/ipc.html#_window_event)
    case "$(printf "%s" "$i3_window_event" \
                | sed -e 's/",.*//' -e 's/{"change":"//')" in
        new | close | focus)
            eval "$(xdotool getwindowfocus getwindowgeometry --shell)" \
                && if [ "$WIDTH" -ge "$HEIGHT" ]; then
                    i3-msg -q "[tiling$1] split h"
                else
                    i3-msg -q "[tiling$1] split v"
                fi
            ;;
    esac
}

case "$1" in
    -h | --help)
        printf "%s\n" "$help"
        ;;
    -t)
        shift
        split
        "$@" &
        ;;
    -w)
        shift
        while true; do
            split " workspace=($1)"
        done
        ;;
    *)
        while true; do
            split
        done
        ;;
esac
