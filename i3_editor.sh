#!/bin/sh

# path:   /home/klassiker/.local/share/repos/i3/i3_editor.sh
# author: klassiker [mrdotx]
# url:    https://github.com/mrdotx/i3
# date:   2025-09-01T05:30:30+0200

# source i3 helper
. _i3_helper.sh

open() {
    $TERMINAL -e "$EDITOR" "$1://$2/" -c ":call NetrwToggle()"
}

title="editor"
table_width=26
message="
$(i3_table "$table_width" "header" "local")
$(i3_table "$table_width" "v" "" "neovim")

$(i3_table "$table_width" "header" "remote")
$(i3_table "$table_width" "m" "󰒍" "m625q")
$(i3_table "$table_width" "d" "󰇅" "m75q")
$(i3_table "$table_width" "n" "󰌢" "t14")
$(i3_table "$table_width" "b" "󰌢" "macbook")
$(i3_table "$table_width" "z" "󰖟" "prinzipal")
$(i3_table "$table_width" "c" "󰖟" "marcus")

[<b>q</b>]uit, [<b>escape</b>], [<b>return</b>]"

case "$1" in
    --vim)
        cd Desktop || exit
        $TERMINAL -e "$EDITOR"
        ;;
    --marcus)
        open "ftp" "marcusreith.de"
        ;;
    --kill)
        i3_notify 1 "$title"
        ;;
    --*)
        # scp as default
        open "scp" "${1##*--}"
        ;;
    *)
        i3_notify 0 "$title" "$message"
        ;;
esac
