#!/bin/sh

# path:   /home/klassiker/.local/share/repos/i3/i3_window_move.sh
# author: klassiker [mrdotx]
# url:    https://github.com/mrdotx/i3
# date:   2025-08-07T05:32:56+0200

# speed up script by using standard c
LC_ALL=C
LANG=C

script=$(basename "$0")
help="$script [-h/--help] -- move floating window to the edge of the monitor
  Usage:
    $script [nw/n/ne/e/se/s/sw/w] [monitor] [margin x] [margin y]

  Settings:
    [nw/n/ne/e/se/s/sw/w] = position to move the window
    [monitor]             = monitor to move the window (default 0)
    [margin x]            = +/- margin x for the window (default 0)
    [margin y]            = +/- margin y for the window (default 0)

  Examples:
    $script n
    $script s 1
    $script se 1 -1 -25"

move_window() {
    [ -z "$1" ] \
        && printf "%s\n" "$help" \
        && return 1

    margin_x=${3:-0}
    margin_y=${4:-0}

    connected=$(xrandr \
        | grep -c " connected .*[0-9]x" \
    )

    [ "$connected" -le 1 ] \
        && monitor=1 \
        || monitor=$((${2:-0} + 1))


    output=$(xrandr \
        | grep " connected .*[0-9]x" \
        | sed "${monitor}q;d" \
    )

    case $output in
        *primary*)
            dimension=$(printf "%s" "$output" \
                | cut -d' ' -f4 \
            )
            ;;
        *)
            dimension=$(printf "%s" "$output" \
                | cut -d' ' -f3 \
            )
            ;;
    esac

    values=$(printf "%s" "$dimension" \
        | sed "s/\(x\|+\|-\)/ /g" \
    )
    operators=$(printf "%s" "$dimension" \
        | sed "s/[0-9]//g" \
    )

    resolution_x=$(printf "%s" "$values" \
        | cut -d' ' -f1 \
    )
    resolution_y=$(printf "%s" "$values" \
        | cut -d' ' -f2 \
    )
    position_x="$(printf "%s" "$operators" \
        | cut -c2)$(printf "%s" "$values" \
        | cut -d' ' -f3 \
    )"
    position_y="$(printf "%s" "$operators" \
        | cut -c3)$(printf "%s" "$values" \
        | cut -d' ' -f4 \
    )"

    eval "$(xdotool getwindowfocus getwindowgeometry --shell)" \
        && case $1 in
            nw)
                x=0
                y=0
                ;;
            n)
                x="$((resolution_x / 2 - WIDTH / 2))"
                y=0
                ;;
            ne)
                x="$((resolution_x - WIDTH))"
                y=0
                ;;
            e)
                x="$((resolution_x - WIDTH))"
                y="$((resolution_y / 2 - HEIGHT / 2))"
                ;;
            se)
                x="$((resolution_x - WIDTH))"
                y="$((resolution_y - HEIGHT))"
                ;;
            s)
                x="$((resolution_x / 2 - WIDTH / 2))"
                y="$((resolution_y - HEIGHT))"
                ;;
            sw)
                x=0
                y="$((resolution_y - HEIGHT))"
                ;;
            w)
                x=0
                y="$((resolution_y / 2 - HEIGHT / 2))"
                ;;
        esac \
        && xdotool getactivewindow windowmove \
            "$((x + position_x + margin_x))" \
            "$((y + position_y + margin_y))"
}

case "$1" in
    -h | --help)
        printf "%s\n" "$help"
        exit
        ;;
    *)
        move_window "$1" "$2" "$3" "$4"
        ;;
esac
