#!/bin/sh

# path:   /home/klassiker/.local/share/repos/i3/i3_container.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/i3
# date:   2023-03-01T16:27:21+0100

# speed up script by using standard c
LC_ALL=C
LANG=C

basename=${0##*/}
path=${0%"$basename"}
i3_table="${path}helper/i3_table.sh"
i3_notify="${path}helper/i3_notify.sh"

title="container"
table_width=41
message="
$("$i3_table" "$table_width" "header" "layout")
$("$i3_table" "$table_width" "s" "" "stacking")
$("$i3_table" "$table_width" "t" "里" "tabbed")
$("$i3_table" "$table_width" "p" "侀" "split")

$("$i3_table" "$table_width" "header" "split")
$("$i3_table" "$table_width" "h" "" "horizontal")
$("$i3_table" "$table_width" "v" "" "vertical")

$("$i3_table" "$table_width" "header" "scratchpad")
$("$i3_table" "$table_width" "m" "" "move to")
$("$i3_table" "$table_width" "c" "" "cycle")

$("$i3_table" "$table_width" "header" "wallpaper")
$("$i3_table" "$table_width" "a" "列" "random")
$("$i3_table" "$table_width" "e" "勒" "reset")

[<b>q</b>]uit, [<b>return</b>], [<b>escape</b>], [<b>super+space</b>]"

case "$1" in
    --kill)
        "$i3_notify" 1 "$title"
        ;;
    *)
        "$i3_notify" 0 "$title" "$message"
        ;;
esac
