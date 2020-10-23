#!/bin/sh

# path:       /home/klassiker/.local/share/repos/i3/i3_tmux.sh
# author:     klassiker [mrdotx]
# github:     https://github.com/mrdotx/i3
# date:       2020-10-23T12:38:05+0200

config="$HOME/.config/tmux/tmux.conf"
session="mi"

script=$(basename "$0")
help="$script [-h/--help] -- script to open applications in tmux windows
  Usage:
    $script [window] [title] [command]

  Settings:
    without given setting, start/attach tmux session
    [window]  = tmux window nr to open application in
    [title]   = optional title of the window (default command)
    [command] = application to start

  Examples:
    $script
    $script 8 'htop'
    $script 9 'sensors' 'watch -n1 sensors'"

if [ "$1" = "-h" ] \
    || [ "$1" = "--help" ]; then
        printf "%s\n" "$help"
        exit 0
fi

tmux_open() {
    if [ $# -ge 2 ]; then
        window=$1
        title=$2
        if [ $# -ge 3 ]; then
            shift 2
        else
            shift
        fi
        cmd="$*"
        tmux neww -t "$session:$window" -n "$title" "$cmd"
        tmux selectw -t "$session:$window"
    fi
}

[ -z "$TMUX" ] \
    &&  if [ "$(tmux ls 2>/dev/null | cut -d ':' -f1)" = "$session" ]; then
            tmux_open "$@"
        else
            tmux -f "$config" new -s "$session" -n "shell" -d
            # tmux_open 8 "htop"
            tmux_open "$@"
        fi \
    && ! [ "$(pgrep -fx "tmux attach -t $session -d")" ] \
    && $TERMINAL -T "i3 tmux" -e tmux attach -t "$session" -d
