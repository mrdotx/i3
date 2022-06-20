#!/bin/sh

# path:   /home/klassiker/.local/share/repos/i3/i3_container.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/i3
# date:   2022-06-20T18:08:15+0200

# speed up script by using standard c
LC_ALL=C
LANG=C

basename=${0##*/}
path=${0%"$basename"}

title="container"
table_width=41
message="
$("$path"helper/i3_table.sh "$table_width" "header" "layout")
$("$path"helper/i3_table.sh "$table_width" "s" "" "stacking")
$("$path"helper/i3_table.sh "$table_width" "t" "里" "tabbed")
$("$path"helper/i3_table.sh "$table_width" "p" "侀" "split")

$("$path"helper/i3_table.sh "$table_width" "header" "split")
$("$path"helper/i3_table.sh "$table_width" "h" "" "horizontal")
$("$path"helper/i3_table.sh "$table_width" "v" "" "vertical")

$("$path"helper/i3_table.sh "$table_width" "header" "scratchpad")
$("$path"helper/i3_table.sh "$table_width" "m" "" "move to")
$("$path"helper/i3_table.sh "$table_width" "c" "" "cycle")

$("$path"helper/i3_table.sh "$table_width" "header" "wallpaper")
$("$path"helper/i3_table.sh "$table_width" "a" "列" "random")
$("$path"helper/i3_table.sh "$table_width" "e" "勒" "reset")

[<b>q</b>]uit, [<b>return</b>], [<b>escape</b>], [<b>super+space</b>]"

case "$1" in
    --kill)
        "$path"helper/i3_notify.sh 1 "$title"
        ;;
    *)
        "$path"helper/i3_notify.sh 0 "$title" "$message"
        ;;
esac
