#!/bin/sh

# path:   /home/klassiker/.local/share/repos/i3/i3_editor.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/i3
# date:   2025-06-02T05:10:44+0200

# source i3 helper
. _i3_helper.sh

open() {
    $TERMINAL -e "$EDITOR" "$1://$2/" -c ":call NetrwToggle()"
}

title="editor"
table_width=26
table_width1=$((table_width + 4))
message="
$(i3_table "$table_width" "header" "local")
$(i3_table "$table_width" "v" "" "neovim")
$(i3_table "$table_width" "w" "󰠮" "vimwiki")
$(i3_table "$table_width1" "t" "󰠮" "├─ todos")
$(i3_table "$table_width1" "i" "󰠮" "└─ ideas")

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
        cd Desktop || exit 1
        $TERMINAL -e "$EDITOR"
        ;;
    --vimwiki)
        [ -n "$2" ] \
            && $TERMINAL -e "$EDITOR" -c ":VimwikiIndex" -c ":VimwikiGoto $2" \
            && return

        $TERMINAL -e "$EDITOR" -c ":VimwikiIndex"
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
