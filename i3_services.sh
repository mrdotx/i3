#!/bin/sh

# path:   /home/klassiker/.local/share/repos/i3/i3_services.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/i3
# date:   2022-05-11T15:49:40+0200

# speed up script by using standard c
LC_ALL=C
LANG=C

# auth can be something like sudo -A, doas -- or nothing,
# depending on configuration requirements
auth="${EXEC_AS_USER:-sudo}"
active="蘒"
inactive="﨡"

# get xresources
xrdb_query() {
    xrdb -query \
        | grep "$1:" \
        | cut -f2
}

service_status() {
    case "$2" in
        user)
            if systemctl --user -q is-active "$1"; then
                printf "%s" "$active"
            else
                printf "%s" "$inactive"
            fi
            ;;
        *)
            if systemctl -q is-active "$1"; then
                printf "%s" "$active"
            else
                printf "%s" "$inactive"
            fi
            ;;
    esac
}

service_toggle() {
    case "$2" in
        user)
            if systemctl --user -q is-active "$1"; then
                systemctl --user disable "$1" --now
            else
                systemctl --user enable "$1" --now
            fi
            ;;
        *)
            if systemctl -q is-active "$1"; then
                $auth systemctl disable "$1" --now
            else
                $auth systemctl enable "$1" --now
            fi
            ;;
    esac \
        && $0 \
        && polybar_services.sh --update
}

table_line() {
    divider=" │ "

    case "$1" in
        header)
            printf "<i>%s</i>\n" "$2"
            printf "───┬───────────────────────────────────"
            ;;
        *)
            printf " <b>%s</b>%s%s %s" \
                "$1" \
                "$divider" \
                "$2" \
                "$3"
            ;;
    esac
}

table_polybar() {
    if [ "$(service_status polybar.service user)" = "$active" ]; then
        printf "%s\n%s»%s«\n%s»%s«" \
            "$(table_line "a" "$active" "polybar [<b>r</b>]eload")" \
            "$(table_line " " "          [<b>1</b>]")" \
            "$(xrdb_query "Polybar.type.monitor1")" \
            "$(table_line " " "          [<b>2</b>]")" \
            "$(xrdb_query "Polybar.type.monitor2")"
    else
        printf "%s" \
            "$(table_line "a" "$inactive" "polybar")"
    fi
}

title="i3 services mode"
message="
$(table_line "header" "enable/disable")
$(table_polybar)
$(table_line "l" "$(service_status xautolock.service user)" "autolock")
$(table_line "t" "$(service_status i3_autotiling.service user)" "autotiling")
$(table_line "c" "$(service_status picom.service user)" "compositor")
$(table_line "m" "$(service_status xbanish.service user)" "mousepointer")
$(table_line "s" "$(service_status systemd-resolved.service)" "resolver")
$(table_line "y" "$(service_status systemd-timesyncd.service)" "timesync")
$(table_line "h" "$(service_status sshd.service)" "ssh")
$(table_line "v" "$(service_status vpnc@hades.service)" "vpn")
$(table_line "p" "$(service_status cups.service)" "printer")
$(table_line "b" "$(service_status bluetooth.service)" "bluetooth")

$(table_line "header" "restart")
$(table_line "d" "dunst")

$(table_line "header" "kill")
$(table_line "u" "urxvt")

[<b>q</b>]uit, [<b>return</b>], [<b>escape</b>], [<b>alt+space</b>]"

notification() {
    notify-send \
        -u low  \
        -t "$1" \
        -i "dialog-information" \
        "$title" \
        "$message" \
        -h string:x-canonical-private-synchronous:"$title"
}

# toggle service or start and kill notification tooltip
case "$1" in
    --polybar)
        service_toggle "polybar.service" "user"
        ;;
    --autolock)
        service_toggle "xautolock.service" "user"
        ;;
    --tiling)
        service_toggle "i3_autotiling.service" "user"
        ;;
    --compositor)
        service_toggle "picom.service" "user"
        ;;
    --mousepointer)
        service_toggle "xbanish.service" "user"
        ;;
    --bluetooth)
        if lsmod | grep -q btusb; then
            service_toggle "bluetooth.service" \
                && $auth modprobe -r btusb
        else
            $auth modprobe btusb \
                && service_toggle "bluetooth.service"
        fi
        ;;
    --printer)
        if systemctl -q is-active cups.service; then
            service_toggle "cups.service" \
                && sleep .5 \
                && service_toggle "colord.service"
        else
            service_toggle "cups.service"
        fi
        ;;
    --resolver)
        service_toggle "systemd-resolved.service"
        ;;
    --timesync)
        service_toggle "systemd-timesyncd.service"
        ;;
    --ssh)
        service_toggle "sshd.service"
        ;;
    --vpn)
        service_toggle "vpnc@hades.service"
        ;;
    --kill)
        notification 1
        ;;
    *)
        notification 0
        ;;
esac
