#!/bin/sh

# path:   /home/klassiker/.local/share/repos/i3/i3_container.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/i3
# date:   2022-05-20T12:38:33+0200

# speed up script by using standard c
LC_ALL=C
LANG=C

title="i3 container mode"
table_width=41
table_width1=$((table_width + 2))
message="
$(i3_helper_table.sh "$table_width" "header" "layout")
$(i3_helper_table.sh "$table_width1" "s" "" "stacking")
$(i3_helper_table.sh "$table_width1" "t" "里" "tabbed")
$(i3_helper_table.sh "$table_width1" "p" "侀" "split")

$(i3_helper_table.sh "$table_width" "header" "split")
$(i3_helper_table.sh "$table_width1" "h" "" "horizontal")
$(i3_helper_table.sh "$table_width1" "v" "" "vertical")

$(i3_helper_table.sh "$table_width" "header" "scratchpad")
$(i3_helper_table.sh "$table_width1" "m" "" "move to")
$(i3_helper_table.sh "$table_width1" "c" "" "cycle")

$(i3_helper_table.sh "$table_width" "header" "wallpaper")
$(i3_helper_table.sh "$table_width1" "a" "列" "random")
$(i3_helper_table.sh "$table_width1" "e" "勒" "reset")

[<b>q</b>]uit, [<b>return</b>], [<b>escape</b>], [<b>super+space</b>]"

case "$1" in
    --kill)
        i3_helper_notify.sh 1 "$title"
        ;;
    *)
        i3_helper_notify.sh 0 "$title" "$message"
        ;;
esac
