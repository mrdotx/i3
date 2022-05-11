#!/bin/sh

# path:   /home/klassiker/.local/share/repos/i3/i3_exit.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/i3
# date:   2022-05-11T20:10:12+0200

# speed up script by using standard c
LC_ALL=C
LANG=C

simple_lock() {
    # workaround (sleep -> https://github.com/i3/i3/issues/3298)
    sleep .5 \
    && slock -m "$(cinfo -a)" &
}

title="i3 exit mode"
table_width=41
message="
$(i3_helper_table.sh "header" "$table_width" "power")
$(i3_helper_table.sh "s" "suspend")
$(i3_helper_table.sh "r" "reboot")
$(i3_helper_table.sh "d" "shutdown")

$(i3_helper_table.sh "header" "$table_width" "other")
$(i3_helper_table.sh "l" "lock")
$(i3_helper_table.sh "o" "logout")

[<b>q</b>]uit, [<b>return</b>], [<b>escape</b>], [<b>ctrl+alt+delete</b>]"

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
        i3_helper_notify.sh 1 "$title"
        ;;
    *)
        i3_helper_notify.sh 0 "$title" "$message"
        ;;
esac
