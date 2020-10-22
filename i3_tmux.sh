#!/bin/sh

# path:       /home/klassiker/.local/share/repos/i3/i3_tmux.sh
# author:     klassiker [mrdotx]
# github:     https://github.com/mrdotx/i3
# date:       2020-10-22T15:06:52+0200

config="$HOME/.config/tmux/tmux.conf"
session="mi"

tmux_start() {
    tmux -f "$config" new -s "$session" -n "shell" -d
    # tmux_open 8 "htop"
}

tmux_open() {
    if [ $# -ge 1 ]; then
        window=$1
        title=$2
        if [ $# -ge 3 ]; then
            shift 2
        else
            shift
        fi
        cmd="$*"
        tmux neww -t"$session:$window" -n "$title" "$cmd"
        tmux selectw -t "$session:$window"
    fi
}

tmux_attach() {
    tmux -2 attach -t "$session" -d
}

[ -z "$TMUX" ] \
    && if [ "$(tmux ls 2>/dev/null | cut -d ':' -f1)" = "$session" ]; then
        tmux_open "$@"
    else
        tmux_start
        tmux_open "$@"
    fi \
    && tmux_attach
