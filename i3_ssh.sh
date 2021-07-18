#!/bin/sh

# path:   /home/klassiker/.local/share/repos/i3/i3_ssh.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/i3
# date:   2021-07-18T08:44:50+0200

title="i3 ssh mode"
message="
<i>server</i>
  [<b>h</b>]ermes
  [<b>p</b>]rometheus
  h[<b>e</b>]ra

<i>client</i>
  [<b>a</b>]rtemis

<i>other</i>
  [<b>m</b>]ain
  [<b>d</b>]menu

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

# start and kill notification tooltip
case "$1" in
    --hermes)
        i3_tmux.sh -o 21 "hermes" "ssh hermes"
        i3-msg -q "workspace 3"
        ;;
    --prometheus)
        i3_tmux.sh -o 22 "prometheus" "ssh prometheus"
        i3-msg -q "workspace 3"
        ;;
    --hera)
        i3_tmux.sh -o 23 "hera" "ssh hera"
        i3-msg -q "workspace 3"
        ;;
    --artemis)
        i3_tmux.sh -o 24 "artemis" "ssh artemis"
        i3-msg -q "workspace 3"
        ;;
    --main)
        i3_tmux.sh -o 21 "hermes" "ssh hermes"
        i3_tmux.sh -o 22 "prometheus" "ssh prometheus"
        i3-msg -q "workspace 3"
        ;;
    --dmenu)
        dmenu_ssh.sh
        ;;
    --kill)
        notification 1
        ;;
    *)
        notification 0
        ;;
esac
