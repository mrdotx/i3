#!/bin/sh

# path:   /home/klassiker/.local/share/repos/i3/i3_container.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/i3
# date:   2022-06-07T16:30:55+0200

# speed up script by using standard c
LC_ALL=C
LANG=C

title="container"
table_width=41
message="
$(i3_helper_table.sh "$table_width" "header" "layout")
$(i3_helper_table.sh "$table_width" "s" "" "stacking")
$(i3_helper_table.sh "$table_width" "t" "里" "tabbed")
$(i3_helper_table.sh "$table_width" "p" "侀" "split")

$(i3_helper_table.sh "$table_width" "header" "split")
$(i3_helper_table.sh "$table_width" "h" "" "horizontal")
$(i3_helper_table.sh "$table_width" "v" "" "vertical")

$(i3_helper_table.sh "$table_width" "header" "scratchpad")
$(i3_helper_table.sh "$table_width" "m" "" "move to")
$(i3_helper_table.sh "$table_width" "c" "" "cycle")

$(i3_helper_table.sh "$table_width" "header" "wallpaper")
$(i3_helper_table.sh "$table_width" "a" "列" "random")
$(i3_helper_table.sh "$table_width" "e" "勒" "reset")

[<b>q</b>]uit, [<b>return</b>], [<b>escape</b>], [<b>super+space</b>]"

case "$1" in
    --kill)
        i3_helper_notify.sh 1 "$title"
        ;;
    *)
        i3_helper_notify.sh 0 "$title" "$message"
        ;;
esac
