#!/bin/sh

# path:   /home/klassiker/.local/share/repos/i3/i3_autotiling.sh
# author: klassiker [mrdotx]
# url:    https://github.com/mrdotx/i3
# date:   2025-08-07T05:32:04+0200

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
    [-w]      = auto tiling only on defined workspaces
    [command] = application to start

  Examples:
    $script
    $script -w 1 4 5 7 8 9
    $script -t $TERMINAL"

autotiling() {
    active_workspace=$(wmctrl -d \
        | awk '$2=="*" {print $9}' \
    )

    for workspace in "$@"; do
        [ "$active_workspace" -eq "$workspace" ] \
            && break
    done
}

set_orientation() {
    i3_window_event=$(i3-msg -t subscribe '[ "window" ]')

    # window event change type (https://i3wm.org/docs/ipc.html#_window_event)
    case "$(printf "%s" "$i3_window_event" \
                | sed -e 's/",.*//' -e 's/{"change":"//')" in
        new | close | focus)
            eval "$(xdotool getwindowfocus getwindowgeometry --shell)" \
                && if [ "$WIDTH" -ge "$HEIGHT" ]; then
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
    -t)
        shift
        set_orientation
        "$@" &
        ;;
    -w)
        shift
        while true; do
            autotiling "$@" \
                && set_orientation
        done
        ;;
    *)
        while true; do
            set_orientation
        done
        ;;
esac
