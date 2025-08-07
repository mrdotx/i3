#!/bin/sh

# path:   /home/klassiker/.local/share/repos/i3/i3_notes.sh
# author: klassiker [mrdotx]
# url:    https://github.com/mrdotx/i3
# date:   2025-08-07T05:32:39+0200

# source i3 helper
. _i3_helper.sh

open() {
    w3m.sh "http://m625q/wiki/$1.html"
}

title="notes"
table_width=26
table_width1=$((table_width + 4))
message="
$(i3_table "$table_width" "header" "wiki")
$(i3_table "$table_width" "w" "󰠮" "vimwiki")
$(i3_table "$table_width1" "t" "󰠮" "├─ todos")
$(i3_table "$table_width1" "i" "󰠮" "├─ ideas")
$(i3_table "$table_width1" "n" "󰠮" "├─ network")
$(i3_table "$table_width1" "b" "󰠮" "└─ bash")

[<b>q</b>]uit, [<b>escape</b>], [<b>return</b>]"

case "$1" in
    --vimwiki)
        [ -n "$2" ] \
            && open "$2" \
            && return

        open "index"
        ;;
    --kill)
        i3_notify 1 "$title"
        ;;
    *)
        i3_notify 0 "$title" "$message"
        ;;
esac
