#!/bin/sh

# path:   /home/klassiker/.local/share/repos/i3/i3_exit.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/i3
# date:   2022-11-01T09:10:54+0100

# speed up script by using standard c
LC_ALL=C
LANG=C

basename=${0##*/}
path=${0%"$basename"}

title="exit"
table_width=45
message="
$("$path"helper/i3_table.sh "$table_width" "header" "power")
$("$path"helper/i3_table.sh "$table_width" "d" "襤" "shutdown")
$("$path"helper/i3_table.sh "$table_width" "r" "累" "reboot")
$("$path"helper/i3_table.sh "$table_width" "s" "" "suspend")

$("$path"helper/i3_table.sh "$table_width" "header" "other")
$("$path"helper/i3_table.sh "$table_width" "z" "鈴" "sleep (lock + suspend)")
$("$path"helper/i3_table.sh "$table_width" "l" "" "lock")
$("$path"helper/i3_table.sh "$table_width" "o" "" "logout")

$("$path"helper/i3_table.sh "$table_width" "header" "restart")
$("$path"helper/i3_table.sh "$table_width" "n" "" "notification daemon")

$("$path"helper/i3_table.sh "$table_width" "header" "kill")
$("$path"helper/i3_table.sh "$table_width" "x" "类" "select window")

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
        "$path"helper/i3_notify.sh 1 "$title"
        ;;
    *)
        "$path"helper/i3_notify.sh 0 "$title" "$message"
        ;;
esac
