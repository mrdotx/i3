#!/bin/sh

# path:   /home/klassiker/.local/share/repos/i3/i3_exit.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/i3
# date:   2022-05-11T15:52:19+0200

# speed up script by using standard c
LC_ALL=C
LANG=C

simple_lock() {
    # workaround (sleep -> https://github.com/i3/i3/issues/3298)
    sleep .5 \
    && slock -m "$(cinfo -a)" &
}

table_line() {
    divider=" │ "

    case "$1" in
        header)
            printf "<i>%s</i>\n" "$2"
            printf "───┬─────────────────────────────────────────"
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

title="i3 exit mode"
message="
$(table_line "header" "power")
$(table_line "s" "suspend")
$(table_line "r" "reboot")
$(table_line "d" "shutdown")

$(table_line "header" "other")
$(table_line "l" "lock")
$(table_line "o" "logout")

[<b>q</b>]uit, [<b>return</b>], [<b>escape</b>], [<b>ctrl+alt+delete</b>]"

notification() {
    notify-send \
        -u low  \
        -t "$1" \
        -i "dialog-information" \
        "$title" \
        "$message" \
        -h string:x-canonical-private-synchronous:"$title"
}

case "$1" in
    --lock)
        simple_lock
        ;;
    --suspend)
        simple_lock \
            && systemctl suspend
        ;;
    --logout)
        i3-msg exit
        ;;
    --reboot)
        systemctl reboot
        ;;
    --shutdown)
        systemctl poweroff
        ;;
    --kill)
        notification 1
        ;;
    *)
        notification 0
        ;;
esac
