#!/bin/sh

# path:   /home/klassiker/.local/share/repos/i3/i3_editor.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/i3
# date:   2022-05-20T13:19:41+0200

open() {
    $TERMINAL -e "$EDITOR" "$1://$2/" -c ":call NetrwToggle()"
}

title="i3 editor mode"
table_width=37
table_width1=$((table_width + 2))
message="
$(i3_helper_table.sh "$table_width" "header" "local")
$(i3_helper_table.sh "$table_width1" "v" "" "vim")
$(i3_helper_table.sh "$table_width1" "w" "ﴬ" "vimwiki")

$(i3_helper_table.sh "$table_width" "header" "remote")
$(i3_helper_table.sh "$table_width1" "p" "菉" "pi")
$(i3_helper_table.sh "$table_width1" "i" "菉" "pi2")
$(i3_helper_table.sh "$table_width1" "m" "力" "middlefinger")
$(i3_helper_table.sh "$table_width1" "z" "力" "prinzipal")
$(i3_helper_table.sh "$table_width1" "k" "力" "klassiker")
$(i3_helper_table.sh "$table_width1" "a" "力" "marcus")

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
