#!/bin/sh

# path:   /home/klassiker/.local/share/repos/i3/i3_editor.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/i3
# date:   2022-05-11T20:16:46+0200

open() {
    $TERMINAL -e "$EDITOR" "$1://$2/" -c ":call NetrwToggle()"
}

title="i3 editor mode"
table_width=33
message="
$(i3_helper_table.sh "header" "$table_width" "local")
$(i3_helper_table.sh "v" "vim")
$(i3_helper_table.sh "w" "vimwiki")

$(i3_helper_table.sh "header" "$table_width" "remote")
$(i3_helper_table.sh "p" "pi")
$(i3_helper_table.sh "i" "pi2")
$(i3_helper_table.sh "m" "middlefinger")
$(i3_helper_table.sh "z" "prinzipal")
$(i3_helper_table.sh "k" "klassiker")
$(i3_helper_table.sh "a" "marcus")

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
