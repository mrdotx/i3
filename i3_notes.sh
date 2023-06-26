#!/bin/sh

# path:   /home/klassiker/.local/share/repos/i3/i3_notes.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/i3
# date:   2023-06-24T07:24:18+0200

basename=${0##*/}
path=${0%"$basename"}
i3_table="${path}helper/i3_table.sh"
i3_notify="${path}helper/i3_notify.sh"

open() {
    $BROWSER "$HOME/Documents/Notes/html/$1.html"
}

title="notes"
table_width=37
table_width1=$((table_width + 4))
message="
$("$i3_table" "$table_width" "header" "vimwiki")
$("$i3_table" "$table_width" "w" "󰠮" "wiki")
$("$i3_table" "$table_width1" "t" "󰠮" "├─ todos")
$("$i3_table" "$table_width1" "i" "󰠮" "├─ ideas")
$("$i3_table" "$table_width1" "n" "󰠮" "├─ network")
$("$i3_table" "$table_width1" "b" "󰠮" "└─ bash")

[<b>q</b>]uit, [<b>return</b>], [<b>escape</b>], [<b>super+/</b>]"

case "$1" in
    --vimwiki)
        [ -n "$2" ]
        case $? in
            0)
                open "$2"
                ;;
            *)
                open "index"
                ;;
        esac
        ;;
    --kill)
        "$i3_notify" 1 "$title"
        ;;
    *)
        "$i3_notify" 0 "$title" "$message"
        ;;
esac
