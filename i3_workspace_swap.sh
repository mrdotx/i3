#!/bin/sh

# path:       /home/klassiker/.local/share/repos/i3/i3_workspace_swap.sh
# author:     klassiker [mrdotx]
# github:     https://github.com/mrdotx/i3
# date:       2020-11-23T13:09:16+0100

script=$(basename "$0")
help="$script [-h/--help] -- swap workspaces and focus window
  Usage:
    $script [left/right/up/down]

  Settings:
    [left/right/up/down] = direction to focus window after swap workspaces

  Examples:
    $script left
    $script right
    $script up
    $script down"

# swap direction, default up
swap="${1:-up}"

swap_workspaces() {
    current_workspaces=$( \
        i3-msg -t get_outputs \
            | grep -Po '"current_workspace":"(.*?[^\\]")' \
            | cut -d "\"" -f4
    )

    printf "%s\n" "$current_workspaces" | {
        while IFS= read -r line; do
            [ -n "$line" ] \
                && i3-msg -- workspace --no-auto-back-and-forth "$line" >/dev/null 2>&1 \
                && i3-msg -- move workspace to output "$swap" >/dev/null 2>&1
        done
        i3-msg -- focus "$swap" >/dev/null 2>&1
    }
}
case "$1" in
    -h | --help)
        printf "%s\n" "$help"
        ;;
    left | right | up | down)
        swap_workspaces
        ;;
    *)
        printf "%s\n" "$help"
        exit 1
        ;;
esac
