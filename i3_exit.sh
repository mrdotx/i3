#!/bin/sh

# path:   /home/klassiker/.local/share/repos/i3/i3_exit.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/i3
# date:   2024-03-13T17:24:43+0100

# speed up script by using standard c
LC_ALL=C
LANG=C

# i3 helper
. i3_helper.sh

title="exit"
table_width=45
message="
$(i3_table "$table_width" "header" "power")
$(i3_table "$table_width" "d" "󰐥" "shutdown")
$(i3_table "$table_width" "r" "󰑐" "reboot")
$(i3_table "$table_width" "s" "󰏦" "suspend")

$(i3_table "$table_width" "header" "other")
$(i3_table "$table_width" "z" "󰒲" "sleep (lock + suspend)")
$(i3_table "$table_width" "l" "󰍁" "lock")
$(i3_table "$table_width" "o" "󰍃" "logout")

$(i3_table "$table_width" "header" "restart")
$(i3_table "$table_width" "n" "󰂚" "notification daemon")

$(i3_table "$table_width" "header" "kill")
$(i3_table "$table_width" "x" "󰖯" "select window")

[<b>q</b>]uit, [<b>return</b>], [<b>escape</b>], [<b>ctrl+alt+delete</b>]"

simple_lock() {
    # WORKAROUND: https://github.com/i3/i3/issues/3298
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
        i3_notify 1 "$title"
        ;;
    *)
        i3_notify 0 "$title" "$message"
        ;;
esac
