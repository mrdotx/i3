#!/bin/sh

# path:       /home/klassiker/.local/share/repos/i3/i3_tmux.sh
# author:     klassiker [mrdotx]
# github:     https://github.com/mrdotx/i3
# date:       2020-10-23T19:17:13+0200

config="$HOME/.config/tmux/tmux.conf"
session="mi"
attach="tmux attach -t $session -d"
term="$TERMINAL -T 'i3 tmux' -e"

script=$(basename "$0")
help="$script [-h/--help] -- script to open applications in tmux windows
  Usage:
    $script [-t] [window] [title] [command]

  Settings:
    without given setting, start/attach tmux session
    [-t]      = open tmux in separate terminal
    [window]  = tmux window nr to open application in
    [title]   = optional title of the window (default command)
    [command] = application to start

  Examples:
    $script
    $script 8 'htop'
    $script 9 'sensors' 'watch -n1 sensors'
    $script -t 8 'htop'
    $script -t 9 'sensors' 'watch -n1 sensors'"

if [ "$1" = "-h" ] \
    || [ "$1" = "--help" ]; then
        printf "%s\n" "$help"
        exit 0
fi

tmux_open() {
    if [ "$1" = "-t" ]; then
        open="$term $attach"
        shift
    else
        open="$attach"
    fi

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
    && ! [ "$(pgrep -fx "$attach")" ] \
    && eval "$open"
