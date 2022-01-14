#!/bin/sh

# path:   /home/klassiker/.local/share/repos/i3/i3_ssh.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/i3
# date:   2022-01-14T14:53:36+0100

title="i3 ssh mode"
message="
<i>server</i>
  [<b>p</b>]i
  pi[<b>2</b>]
  [<b>n</b>]as

<i>client</i>
  [<b>m</b>]acbook

<i>other</i>
  p[<b>i</b>] + pi2

[<b>q</b>]uit, [<b>return</b>], [<b>escape</b>], [<b>super+h</b>]"

notification() {
    notify-send \
        -u low  \
        -t "$1" \
        -i "dialog-question" \
        "$title" \
        "$message" \
        -h string:x-canonical-private-synchronous:"$title"
}

# ssh or start and kill notification tooltip
case "$1" in
    --pi)
        i3_tmux.sh -o 21 "pi" "ssh pi"
        ;;
    --pi2)
        i3_tmux.sh -o 22 "pi2" "ssh pi2"
        ;;
    --nas)
        i3_tmux.sh -o 23 "nas" "ssh nas"
        ;;
    --macbook)
        i3_tmux.sh -o 24 "macbook" "ssh macbook"
        ;;
    --pipi)
        i3_tmux.sh -o 21 "pi" "ssh pi"
        i3_tmux.sh -o 22 "pi2" "ssh pi2"
        ;;
    --kill)
        notification 1
        ;;
    *)
        notification 0
        ;;
esac
