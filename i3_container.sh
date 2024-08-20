#!/bin/sh

# path:   /home/klassiker/.local/share/repos/i3/i3_container.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/i3
# date:   2024-08-19T15:22:14+0200

# speed up script by using standard c
LC_ALL=C
LANG=C

# i3 helper
. i3_helper.sh

title="container"
table_width=26
message="
$(i3_table "$table_width" "header" "layout")
$(i3_table "$table_width" "s" "󰌨" "stacking")
$(i3_table "$table_width" "t" "󰓪" "tabbed")
$(i3_table "$table_width" "p" "󰕴" "split")

$(i3_table "$table_width" "header" "split")
$(i3_table "$table_width" "h" "󰁕" "horizontal")
$(i3_table "$table_width" "v" "󰁆" "vertical")

$(i3_table "$table_width" "header" "scratchpad")
$(i3_table "$table_width" "m" "󰀿" "move to")
$(i3_table "$table_width" "c" "󰀾" "cycle")

$(i3_table "$table_width" "header" "wallpaper")
$(i3_table "$table_width" "a" "󰒝" "random")
$(i3_table "$table_width" "e" "󰑓" "reset")

[<b>q</b>]uit, [<b>return</b>], [<b>escape</b>]"

case "$1" in
    --kill)
        i3_notify 1 "$title"
        ;;
    *)
        i3_notify 0 "$title" "$message"
        ;;
esac
