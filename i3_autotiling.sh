#!/bin/sh

# path:   /home/klassiker/.local/share/repos/i3/i3_autotiling.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/i3
# date:   2024-10-25T05:12:35+0200

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
    tmp_file="/tmp/window_event.i3"

    i3-msg -t subscribe '[ "window" ]' > "$tmp_file"

    change_type=$(cut -d ',' -f1 "$tmp_file" \
        | sed \
            -e 's/{"change":"//' \
            -e 's/"$//' \
    )

    # window event change type (https://i3wm.org/docs/ipc.html#_window_event)
    case "$change_type" in
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
