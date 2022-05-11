#!/bin/sh

# path:   /home/klassiker/.local/share/repos/i3/i3_container.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/i3
# date:   2022-05-11T20:17:23+0200

# speed up script by using standard c
LC_ALL=C
LANG=C

title="i3 container mode"
table_width=37
message="
$(i3_helper_table.sh "header" "$table_width" "layout")
$(i3_helper_table.sh "s" "stacking")
$(i3_helper_table.sh "t" "tabbed")
$(i3_helper_table.sh "p" "split")

$(i3_helper_table.sh "header" "$table_width" "split")
$(i3_helper_table.sh "h" "horizontal")
$(i3_helper_table.sh "v" "vertical")

$(i3_helper_table.sh "header" "$table_width" "scratchpad")
$(i3_helper_table.sh "m" "move to")
$(i3_helper_table.sh "c" "cycle")

$(i3_helper_table.sh "header" "$table_width" "wallpaper")
$(i3_helper_table.sh "a" "random")
$(i3_helper_table.sh "e" "reset")

[<b>q</b>]uit, [<b>return</b>], [<b>escape</b>], [<b>super+space</b>]"

case "$1" in
    --kill)
        i3_helper_notify.sh 1 "$title"
        ;;
    *)
        i3_helper_notify.sh 0 "$title" "$message"
        ;;
esac
