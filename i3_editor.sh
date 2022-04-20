#!/bin/sh

# path:   /home/klassiker/.local/share/repos/i3/i3_editor.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/i3
# date:   2022-04-20T18:41:56+0200

open() {
    $TERMINAL -e "$EDITOR" "$1://$2/" -c ":call NetrwToggle()"
}

title="i3 editor mode"
message="
<i>[<b>v</b>]im</i>
  [<b>w</b>]iki
  i[<b>d</b>]eas

<i>remote</i>
  [<b>p</b>]i
  p[<b>i</b>]2
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
    --vim)
        cd Desktop || exit 1
        $TERMINAL -e "$EDITOR"
        ;;
    --wiki)
        $TERMINAL -e "$EDITOR" -c ":VimwikiIndex"
        ;;
    --ideas)
        $TERMINAL -e "$EDITOR" -c ":VimwikiIndex" -c ":VimwikiGoto ideas"
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
