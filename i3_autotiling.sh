#!/bin/sh

# path:   /home/klassiker/.local/share/repos/i3/i3_autotiling.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/i3
# date:   2024-01-25T18:06:06+0100

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
    [-w]      = auto tiling only on defined workspaces
    [-t]      = auto tiling once with defined command
    [command] = application to start

  Examples:
    $script
    $script -w 1 4 5 7 8 9
    $script -t $TERMINAL"

split() {
    eval "$(xdotool getwindowfocus getwindowgeometry --shell)" \
        && if [ "$WIDTH" -ge "$HEIGHT" ]; then
            i3-msg -q split h
        else
            i3-msg -q split v
        fi
}

autotiling() {
    active_workspace=$(wmctrl -d \
        | awk '$2=="*" {print $9}' \
    )

    [ -n "$active_workspace" ] \
        && for workspace in "$@"; do
            [ "$active_workspace" -eq "$workspace" ] \
                && break
        done
}

case "$1" in
    -h | --help)
        printf "%s\n" "$help"
        ;;
    -w)
        shift
        while true; do
            autotiling "$@" \
                && split
            i3-msg -q -t subscribe '[ "window" ]' \
                || return
        done
        ;;
    -t)
        shift
        split
        "$@" &
        ;;
    *)
        while true; do
            split
            i3-msg -q -t subscribe '[ "window" ]' \
                || return
        done
        ;;
esac
