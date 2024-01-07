#!/bin/sh

# path:   /home/klassiker/.local/share/repos/i3/i3_tmux.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/i3
# date:   2024-01-06T10:49:32+0100

session="$(uname -n)"
attach="tmux attach -d -t $session"
term="$TERMINAL -T 'i3 tmux' -e"

script=$(basename "$0")
help="$script [-h/--help] -- script to open applications in tmux windows
  Usage:
    $script [-o] [window] [title] [directory/command]

  Settings:
    without given settings, start/attach tmux session
    [-o]                = open tmux in separate terminal
    [window]            = tmux window no. to open application in
    [title]             = optional title of the window (default command)
                          if title is \"shell\" it opens the shell
    [directory/command] = application to start
                          if title is \"shell\" this is the start-directory

  Examples:
    $script
    $script 0 \"shell\"
    $script 9 \"sensors\"
    $script -o 0 \"shell\" \"$HOME/.config\"
    $script -o 9 \"sensors\" \"watch -n1 sensors\""

case "$1" in
    "-h"|"--help")
        printf "%s\n" "$help"
        exit 0
        ;;
    "-o")
        open="$term $attach"
        shift
        ;;
    *)
        open="$attach"
        ;;
esac

tmux_open() {
    if [ $# -ge 2 ]; then
        window=$1
        title=$2
        [ $# -ge 3 ] \
            && shift
        shift
        cmd="$*"

        ! tmux lsw 2>/dev/null | grep -q "^$window:" \
            && if printf "%s" "$title" | grep -q "^shell$"; then
                tmux neww -t "$session:$window" -c "$cmd"
            else
                tmux neww -t "$session:$window" -n "$title" "$cmd"
            fi

        tmux selectw -t "$session:$window"
    fi
}

tmux_kill() {
    [ -n "$1" ] \
        && [ -n "$window" ] \
        && [ ! "$window" -eq "$1" ] \
        && tmux killw -t "$session:$1"
}

if [ "$(tmux ls 2>/dev/null | cut -d ':' -f1)" = "$session" ]; then
    tmux_open "$@"
else
    tmux new -d -s "$session"
    # tmux_open 15 "htop"
    tmux_open "$@"
    tmux_kill 1
fi

if [ ! "$(pgrep -fx "$attach")" ]; then
    eval "$open"
fi
