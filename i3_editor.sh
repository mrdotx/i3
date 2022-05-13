#!/bin/sh

# path:   /home/klassiker/.local/share/repos/i3/i3_editor.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/i3
# date:   2022-05-13T14:39:30+0200

open() {
    $TERMINAL -e "$EDITOR" "$1://$2/" -c ":call NetrwToggle()"
}

title="i3 editor mode"
table_width=37
message="
$(i3_helper_table.sh "$table_width" "header" "local")
$(i3_helper_table.sh "$table_width" "v" "vim")
$(i3_helper_table.sh "$table_width" "w" "vimwiki")

$(i3_helper_table.sh "$table_width" "header" "remote")
$(i3_helper_table.sh "$table_width" "p" "pi")
$(i3_helper_table.sh "$table_width" "i" "pi2")
$(i3_helper_table.sh "$table_width" "m" "middlefinger")
$(i3_helper_table.sh "$table_width" "z" "prinzipal")
$(i3_helper_table.sh "$table_width" "k" "klassiker")
$(i3_helper_table.sh "$table_width" "a" "marcus")

[<b>q</b>]uit, [<b>return</b>], [<b>escape</b>], [<b>super+e</b>]"

case "$1" in
    --vim)
        cd Desktop || exit 1
        $TERMINAL -e "$EDITOR"
        ;;
    --vimwiki)
        $TERMINAL -e "$EDITOR" -c ":VimwikiIndex"
        ;;
    --pi)
        open "scp" "pi"
        ;;
    --pi2)
        open "scp" "pi2"
        ;;
    --middlefinger)
        open "scp" "middlefinger"
        ;;
    --prinzipal)
        open "scp" "prinzipal"
        ;;
    --klassiker)
        open "ftp" "klassiker.online.de"
        ;;
    --marcus)
        open "ftp" "marcusreith.de"
        ;;
    --kill)
        i3_helper_notify.sh 1 "$title"
        ;;
    *)
        i3_helper_notify.sh 0 "$title" "$message"
        ;;
esac
