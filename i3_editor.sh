#!/bin/sh

# path:   /home/klassiker/.local/share/repos/i3/i3_editor.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/i3
# date:   2022-05-11T15:59:48+0200

open() {
    $TERMINAL -e "$EDITOR" "$1://$2/" -c ":call NetrwToggle()"
}

table_line() {
    divider=" │ "

    case "$1" in
        header)
            printf "<i>%s</i>\n" "$2"
            printf "───┬─────────────────────────────────"
            ;;
        *)
            printf " <b>%s</b>%s%s %s" \
                "$1" \
                "$divider" \
                "$2" \
                "$3"
            ;;
    esac
}

title="i3 editor mode"
message="
$(table_line "header" "local")
$(table_line "v" "vim")
$(table_line "w" "vimwiki")

$(table_line "header" "remote")
$(table_line "p" "pi")
$(table_line "i" "pi2")
$(table_line "m" "middlefinger")
$(table_line "z" "prinzipal")
$(table_line "k" "klassiker")
$(table_line "a" "marcus")

[<b>q</b>]uit, [<b>return</b>], [<b>escape</b>], [<b>super+e</b>]"

notification() {
    notify-send \
        -u low  \
        -t "$1" \
        -i "dialog-information" \
        "$title" \
        "$message" \
        -h string:x-canonical-private-synchronous:"$title"
}

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
        notification 1
        ;;
    *)
        notification 0
        ;;
esac
