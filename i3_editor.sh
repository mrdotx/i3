#!/bin/sh

# path:   /home/klassiker/.local/share/repos/i3/i3_editor.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/i3
# date:   2023-01-22T20:15:57+0100

basename=${0##*/}
path=${0%"$basename"}

open() {
    $TERMINAL -e "$EDITOR" "$1://$2/" -c ":call NetrwToggle()"
}

title="editor"
table_width=37
message="
$("$path"helper/i3_table.sh "$table_width" "header" "local")
$("$path"helper/i3_table.sh "$table_width" "v" "" "vim")
$("$path"helper/i3_table.sh "$table_width" "w" "ﴬ" "vimwiki")

$("$path"helper/i3_table.sh "$table_width" "header" "remote")
$("$path"helper/i3_table.sh "$table_width" "m" "菉" "m625q")
$("$path"helper/i3_table.sh "$table_width" "n" "" "mi")
$("$path"helper/i3_table.sh "$table_width" "b" "" "macbook")
$("$path"helper/i3_table.sh "$table_width" "f" "力" "middlefinger")
$("$path"helper/i3_table.sh "$table_width" "z" "力" "prinzipal")
$("$path"helper/i3_table.sh "$table_width" "k" "力" "klassiker")
$("$path"helper/i3_table.sh "$table_width" "c" "力" "marcus")

[<b>q</b>]uit, [<b>return</b>], [<b>escape</b>], [<b>super+e</b>]"

case "$1" in
    --vim)
        cd Desktop || exit 1
        $TERMINAL -e "$EDITOR"
        ;;
    --vimwiki)
        $TERMINAL -e "$EDITOR" -c ":VimwikiIndex"
        ;;
    --klassiker)
        open "ftp" "klassiker.online.de"
        ;;
    --marcus)
        open "ftp" "marcusreith.de"
        ;;
    --kill)
        "$path"helper/i3_notify.sh 1 "$title"
        ;;
    --*)
        # scp as default
        open "scp" "${1##*--}"
        ;;
    *)
        "$path"helper/i3_notify.sh 0 "$title" "$message"
        ;;
esac
