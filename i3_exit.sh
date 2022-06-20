#!/bin/sh

# path:   /home/klassiker/.local/share/repos/i3/i3_exit.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/i3
# date:   2022-06-20T18:14:19+0200

# speed up script by using standard c
LC_ALL=C
LANG=C

basename=${0##*/}
path=${0%"$basename"}

title="exit"
table_width=45
message="
$("$path"helper/i3_table.sh "$table_width" "header" "power")
$("$path"helper/i3_table.sh "$table_width" "s" "鈴" "suspend")
$("$path"helper/i3_table.sh "$table_width" "r" "累" "reboot")
$("$path"helper/i3_table.sh "$table_width" "d" "襤" "shutdown")

$("$path"helper/i3_table.sh "$table_width" "header" "other")
$("$path"helper/i3_table.sh "$table_width" "l" "" "lock")
$("$path"helper/i3_table.sh "$table_width" "o" "" "logout")

[<b>q</b>]uit, [<b>return</b>], [<b>escape</b>], [<b>ctrl+alt+delete</b>]"

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
    --lock)
        # workaround (sleep -> https://github.com/i3/i3/issues/3298)
        sleep .5 \
        && slock -m "$(cinfo -a)" &
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
