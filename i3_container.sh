#!/bin/sh

# path:   /home/klassiker/.local/share/repos/i3/i3_container.sh
# author: klassiker [mrdotx]
# url:    https://github.com/mrdotx/i3
# date:   2025-10-30T05:35:12+0100

# speed up script by using standard c
LC_ALL=C
LANG=C

# source i3 helper
. _i3_helper.sh

service_name="i3_autotiling.service"
icon_active="󰨚"
icon_inactive="󰨙"

title="container"
table_width=26
table_width1=$((table_width + 3))
message="
$(i3_table "$table_width" "header" "service")
$(i3_table "$table_width1" "a" "󰕴" "$( \
    if systemctl --user -q is-active "$service_name"; then
        printf "%s" "$icon_active"
    else
        printf "%s" "$icon_inactive"
    fi) autotiling")

$(i3_table "$table_width" "header" "layout")
$(i3_table "$table_width" "p" "󰕴" "split")
$(i3_table "$table_width" "t" "󰓪" "tabbed")
$(i3_table "$table_width" "s" "󰌨" "stacking")

$(i3_table "$table_width" "header" "split")
$(i3_table "$table_width" "h" "󰁕" "horizontal")
$(i3_table "$table_width" "v" "󰁆" "vertical")

$(i3_table "$table_width" "header" "scratchpad")
$(i3_table "$table_width" "m" "󰀿" "move to")
$(i3_table "$table_width" "c" "󰀾" "cycle")

$(i3_table "$table_width" "header" "wallpaper")
$(i3_table "$table_width" "d" "󰒝" "random")
$(i3_table "$table_width" "b" "󰌁" "black")
$(i3_table "$table_width" "w" "󰌁" "white")
$(i3_table "$table_width" "e" "󰑓" "reset")

[<b>q</b>]uit, [<b>escape</b>], [<b>return</b>]"

case "$1" in
    --kill)
        i3_notify 1 "$title"
        ;;
    --tiling)
        if systemctl --user -q is-active "$service_name"; then
            systemctl --user disable "$service_name" --now
        else
            systemctl --user enable "$service_name" --now
        fi \
            && "$0" \
            && polybar_services.sh --update
        ;;
    *)
        i3_notify 0 "$title" "$message"
        ;;
esac
