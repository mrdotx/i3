#!/bin/sh

# path:   /home/klassiker/.local/share/repos/i3/i3_workspace_swap.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/i3
# date:   2022-04-21T10:48:16+0200

# speed up script by using posix
LC_ALL=C
LANG=C

script=$(basename "$0")
help="$script [-h/--help] -- swap workspaces and focus
  Usage:
    $script [left/right/up/down]

  Settings:
    [left/right/up/down] = direction to focus after the workspaces swaped

  Examples:
    $script left
    $script right
    $script up
    $script down"

swap_workspaces() {
    current_workspaces=$( \
        i3-msg -t get_outputs \
            | grep -oE '"current_workspace":"[0-9]{1,2}"' \
            | cut -d "\"" -f4
    )

    for line in $current_workspaces; do
        [ -n "$line" ] \
            && i3-msg -q "workspace --no-auto-back-and-forth $line" \
            && i3-msg -q "move workspace to output $1"
    done
    i3-msg -q "focus $1"
}

case "$1" in
    left | right | up | down)
        swap_workspaces "$1"
        ;;
    *)
        printf "%s\n" "$help"
        exit 1
        ;;
esac
