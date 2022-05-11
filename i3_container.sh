#!/bin/sh

# path:   /home/klassiker/.local/share/repos/i3/i3_container.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/i3
# date:   2022-05-11T15:54:19+0200

# speed up script by using standard c
LC_ALL=C
LANG=C

table_line() {
    divider=" │ "

    case "$1" in
        header)
            printf "<i>%s</i>\n" "$2"
            printf "───┬─────────────────────────────────────"
            ;;
        *)
            printf " <b>%s</b>%s%s %s" \
                "$1" \
                "$divider" \
                "$2" \
                "$3"
            ;;
    esac
}

title="i3 container mode"
message="
$(table_line "header" "layout")
$(table_line "s" "stacking")
$(table_line "t" "tabbed")
$(table_line "p" "split")

$(table_line "header" "split")
$(table_line "h" "horizontal")
$(table_line "v" "vertical")

$(table_line "header" "scratchpad")
$(table_line "m" "move to")
$(table_line "c" "cycle")

$(table_line "header" "wallpaper")
$(table_line "a" "random")
$(table_line "e" "reset")

[<b>q</b>]uit, [<b>return</b>], [<b>escape</b>], [<b>super+space</b>]"

notification() {
    notify-send \
        -u low  \
        -t "$1" \
        -i "dialog-information" \
        "$title" \
        "$message" \
        -h string:x-canonical-private-synchronous:"$title"
}

# start and kill notification tooltip
case "$1" in
    --kill)
        notification 1
        ;;
    *)
        notification 0
        ;;
esac
