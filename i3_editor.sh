#!/bin/sh

# path:   /home/klassiker/.local/share/repos/i3/i3_editor.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/i3
# date:   2022-01-14T13:43:25+0100

open() {
    $TERMINAL -e "$EDITOR" "$1://$2/" -c ":call NetrwToggle()"
}

title="i3 editor mode"
message="
<i>vimwiki</i>
  [<b>i</b>]deas
  [<b>n</b>]otes

<i>remote</i>
  [<b>p</b>]i
  pi[<b>2</b>]
  [<b>m</b>]iddlefinger
  prin[<b>z</b>]ipal
  [<b>k</b>]lassiker
  m[<b>a</b>]rcus

[<b>q</b>]uit, [<b>return</b>], [<b>escape</b>], [<b>super+e</b>]"

notification() {
    notify-send \
        -u low  \
        -t "$1" \
        -i "dialog-question" \
        "$title" \
        "$message" \
        -h string:x-canonical-private-synchronous:"$title"
}

case "$1" in
    --editor)
        $TERMINAL -e "$EDITOR"
        ;;
    --ideas)
        $TERMINAL -e "$EDITOR" -c ":VimwikiIndex" -c ":VimwikiGoto ideas"
        ;;
    --notes)
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
