#!/bin/sh

# path:   /home/klassiker/.local/share/repos/i3/i3_exit.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/i3
# date:   2025-05-13T05:50:24+0200

# speed up script by using standard c
LC_ALL=C
LANG=C

# source i3 helper
. _i3_helper.sh

title="exit"
table_width=26
message="
$(i3_table "$table_width" "header" "power")
$(i3_table "$table_width" "d" "󰐥" "shutdown")
$(i3_table "$table_width" "r" "󰑐" "reboot")
$(i3_table "$table_width" "s" "󰏦" "suspend")
$(i3_table "$table_width" "l" "󰍁" "lock")
$(i3_table "$table_width" "o" "󰍃" "logout")

[<b>q</b>]uit, [<b>escape</b>], [<b>return</b>]"

simple_lock() {
    # WORKAROUND: https://github.com/i3/i3/issues/3298
    sleep .5 \
        && slock -m "$(cinfo -a)" &
}

case "$1" in
    --shutdown)
        systemctl poweroff --no-wall
        ;;
    --reboot)
        systemctl reboot --no-wall
        ;;
    --suspend)
        i3_mouse_move.sh ne 0 \
            && simple_lock \
            && sleep 1 \
            && systemctl suspend --no-wall
        ;;
    --lock)
        i3_mouse_move.sh ne 0 \
            && simple_lock
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
