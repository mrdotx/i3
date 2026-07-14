#!/bin/sh

# path:   /home/klassiker/Projects/repos/i3/i3_macros.sh
# author: klassiker [mrdotx]
# url:    https://github.com/mrdotx/i3
# date:   2026-07-14T02:00:49+0200

# auth can be something like sudo -A, doas -- or nothing,
# depending on configuration requirements
auth="${EXEC_AS_USER:-sudo}"

# source i3 helper
. _i3_helper.sh

# WORKAROUND: RANGER_LEVEL=0 to disable cinfo on shell launch
shell="RANGER_LEVEL=0 $SHELL"

type_string() {
    # WORKAROUND: xdotool mismatched keyboard layouts
    setxkbmap -synch

    # WORKAROUND: early start
    sleep .2

    xdotool type --delay 0 --clearmodifiers "$@"
}

window_available() {
    wmctrl -l | grep -q "$1"
}

wait_for_max() {
    max_ds="$1"
    after_ds="$3"

    while ! window_available "$2" \
        && [ "$max_ds" -ge 1 ]; do
            sleep .1
            max_ds=$((max_ds - 1))
    done

    [ "$max_ds" = 0 ] \
        && return 1

    while [ "$after_ds" -ge 1 ]; do
        sleep .1
        after_ds=$((after_ds - 1))
    done
}

open_terminal() {
    i3-msg workspace "$1"
    i3-msg -q "exec --no-startup-id \
        \"$TERMINAL -T '$2' -e '$SHELL' -ic '$3; $shell'\""
}

open_tmux() {
    # REQUIRES: tmux.sh (https://github.com/mrdotx/shell)
    i3-msg -q "exec --no-startup-id \
        \"tmux.sh -o '$1' '$2' '$3; $shell'\""
    i3-msg workspace 2
}

autostart() {
    table_width=26
    icon_blank="󰄱"
    icon_marked="󰄵"

    progress_message() {
        printf "\n%s" \
            "$(i3_table "$table_width" "header" "mount")"
        printf "\n%s" \
            "$(i3_table "$table_width" \
            "${icon_mfc:-$icon_blank}" "󰒍" "nfs \"Cloud\"")"
        printf "\n%s" \
            "$(i3_table "$table_width" \
            "${icon_mfd:-$icon_blank}" "󰒍" "nfs \"Desktop\"")"
        printf "\n%s" \
            "$(i3_table "$table_width" \
            "${icon_mfm:-$icon_blank}" "󰒍" "nfs \"Music\"")"
        printf "\n%s" \
            "$(i3_table "$table_width" \
            "${icon_mfp:-$icon_blank}" "󰒍" "nfs \"Public\"")"
        printf "\n%s" \
            "$(i3_table "$table_width" \
            "${icon_mfs:-$icon_blank}" "󰒍" "nfs \"Share\"")"
        printf "\n%s" \
            "$(i3_table "$table_width" \
            "${icon_mfv:-$icon_blank}" "󰒍" "nfs \"Videos\"")"
        printf "\n\n%s" \
            "$(i3_table "$table_width" "header" "start")"
        printf "\n%s" \
            "$(i3_table "$table_width" \
            "${icon_ofm:-$icon_blank}" "󰆍" "file manager")"
        printf "\n%s" \
            "$(i3_table "$table_width" \
            "${icon_om:-$icon_blank}" "󰆍" "multiplexer")"
    }

    progress_bar() {
        i3_notify_progress "${2:-0}" "$title" "$(progress_message)" "$1"
    }

    # progress initialization
    progress_bar 0

    # mount directory "Cloud"
    i3_nfs.sh --mount "Cloud" \
        && icon_mfc="$icon_marked"
    progress_bar 10

    # mount directory "Desktop"
    i3_nfs.sh --mount "Desktop" \
        && icon_mfd="$icon_marked"
    progress_bar 20

    # mount directory "Music"
    i3_nfs.sh --mount "Music" \
        && icon_mfm="$icon_marked"
    progress_bar 30

    # mount directory "Public"
    i3_nfs.sh --mount "Public" \
        && icon_mfp="$icon_marked"
    progress_bar 40

    # mount directory "Share"
    i3_nfs.sh --mount "Share" \
        && icon_mfs="$icon_marked"
    progress_bar 50

    # mount directory "Videos"
    i3_nfs.sh --mount "Videos" \
        && icon_mfv="$icon_marked"
    progress_bar 60

    # start file manager and wait
    ! window_available "ranger:" \
        && open_terminal 1 'ranger' "ranger_cd $HOME/Projects/repos"
    progress_bar 70
    wait_for_max 35 "ranger:" 0 \
        && icon_ofm="$icon_marked"
    progress_bar 80

    # start multiplexer and wait
    ! window_available "tmux" \
        && open_tmux 1 'shell'
    progress_bar 90
    wait_for_max 25 "tmux" 0 \
        && icon_om="$icon_marked"
    progress_bar 100 250
}

title="macros"
table_width=26
message="
$(i3_table "$table_width" "header" "system")
$(i3_table "$table_width" "b" "󰐥" "boot next")
$(i3_table "$table_width" "v" "󰕓" "ventoy")

$(i3_table "$table_width" "header" "info")
$(i3_table "$table_width" "w" "" "weather")
$(i3_table "$table_width" "s" "󰟴" "starwars")
$(i3_table "$table_width" "h" "󰟴" "telehack")

[<b>q</b>]uit, [<b>escape</b>], [<b>return</b>]"

case "$1" in
    --bootnext)
        # REQUIRES: efistub.sh (https://github.com/mrdotx/efistub)
        open_tmux '' 'bootnext' "$auth efistub.sh -b"
        ;;
    --ventoy)
        open_tmux '' 'ventoy' "lsblk; ventoy -h"
        type_string "$auth ventoy -u /dev/sd"
        ;;
    --weather)
        # REQUIRES:      wttr.sh (https://github.com/mrdotx/shell)
        # polybar_openweather.sh (https://github.com/mrdotx/polybar)
        open_tmux '' 'weather' \
            "wttr.sh --clean; echo; polybar_openweather.sh --terminal"
        ;;
    --starwars)
        url="starwarstel.net"
        open_tmux '' 'starwars' "telnet '$url'"
        ;;
    --telehack)
        url="telehack.com"
        open_tmux '' 'telehack' "telnet '$url'"
        ;;
    --autostart)
        autostart
        ;;
    --kill)
        i3_notify 1 "$title"
        ;;
    *)
        i3_notify 0 "$title" "$message"
        ;;
esac
