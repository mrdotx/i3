#!/bin/sh

# path:   /home/klassiker/.local/share/repos/i3/i3_exit.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/i3
# date:   2022-05-20T19:35:24+0200

# speed up script by using standard c
LC_ALL=C
LANG=C

simple_lock() {
    # workaround (sleep -> https://github.com/i3/i3/issues/3298)
    sleep .5 \
    && slock -m "$(cinfo -a)" &
}

title="i3 exit mode"
table_width=45
message="
$(i3_helper_table.sh "$table_width" "header" "power")
$(i3_helper_table.sh "$table_width" "s" "鈴" "suspend")
$(i3_helper_table.sh "$table_width" "r" "累" "reboot")
$(i3_helper_table.sh "$table_width" "d" "襤" "shutdown")

$(i3_helper_table.sh "$table_width" "header" "other")
$(i3_helper_table.sh "$table_width" "l" "" "lock")
$(i3_helper_table.sh "$table_width" "o" "" "logout")

[<b>q</b>]uit, [<b>return</b>], [<b>escape</b>], [<b>ctrl+alt+delete</b>]"

case "$1" in
    --suspend)
        systemctl suspend
        ;;
    --reboot)
        systemctl reboot
        ;;
    --shutdown)
        systemctl poweroff
        ;;
    --lock)
        simple_lock
        ;;
    --logout)
        i3-msg exit
        ;;
    --kill)
        i3_helper_notify.sh 1 "$title"
        ;;
    *)
        i3_helper_notify.sh 0 "$title" "$message"
        ;;
esac
