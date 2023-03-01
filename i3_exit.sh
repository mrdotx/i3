#!/bin/sh

# path:   /home/klassiker/.local/share/repos/i3/i3_exit.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/i3
# date:   2023-03-01T16:28:58+0100

# speed up script by using standard c
LC_ALL=C
LANG=C

basename=${0##*/}
path=${0%"$basename"}
i3_table="${path}helper/i3_table.sh"
i3_notify="${path}helper/i3_notify.sh"

title="exit"
table_width=45
message="
$("$i3_table" "$table_width" "header" "power")
$("$i3_table" "$table_width" "d" "襤" "shutdown")
$("$i3_table" "$table_width" "r" "累" "reboot")
$("$i3_table" "$table_width" "s" "" "suspend")

$("$i3_table" "$table_width" "header" "other")
$("$i3_table" "$table_width" "z" "鈴" "sleep (lock + suspend)")
$("$i3_table" "$table_width" "l" "" "lock")
$("$i3_table" "$table_width" "o" "" "logout")

$("$i3_table" "$table_width" "header" "restart")
$("$i3_table" "$table_width" "n" "" "notification daemon")

$("$i3_table" "$table_width" "header" "kill")
$("$i3_table" "$table_width" "x" "类" "select window")

[<b>q</b>]uit, [<b>return</b>], [<b>escape</b>], [<b>ctrl+alt+delete</b>]"

simple_lock() {
    # workaround (sleep -> https://github.com/i3/i3/issues/3298)
    sleep .5 \
        && slock -m "$(cinfo -a)"
}

case "$1" in
    --suspend)
        systemctl suspend --no-wall
        ;;
    --reboot)
        systemctl reboot --no-wall
        ;;
    --shutdown)
        systemctl poweroff --no-wall
        ;;
    --sleep)
        simple_lock &
        sleep .5 \
            && systemctl suspend --no-wall
        ;;
    --lock)
        simple_lock
        ;;
    --logout)
        i3-msg exit
        ;;
    --kill)
        "$i3_notify" 1 "$title"
        ;;
    *)
        "$i3_notify" 0 "$title" "$message"
        ;;
esac
