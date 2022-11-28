#!/bin/sh

# path:   /home/klassiker/.local/share/repos/i3/i3_services.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/i3
# date:   2022-11-28T10:49:25+0100

# speed up script by using standard c
LC_ALL=C
LANG=C

# auth can be something like sudo -A, doas -- or nothing,
# depending on configuration requirements
auth="${EXEC_AS_USER:-sudo}"
icon_active="蘒"
icon_inactive="﨡"

basename=${0##*/}
path=${0%"$basename"}

# get xresources
xrdb_query() {
    xrdb -query \
        | grep "$1:" \
        | cut -f2
}

service_status() {
    case "$2" in
        wireguard)
            if [ "$(wireguard_toggle.sh -s "$1")" = "$1 is enabled" ]; then
                printf "%s" "$icon_active"
            else
                printf "%s" "$icon_inactive"
            fi
            ;;
        user)
            if systemctl --user -q is-active "$1"; then
                printf "%s" "$icon_active"
            else
                printf "%s" "$icon_inactive"
            fi
            ;;
        *)
            if systemctl -q is-active "$1"; then
                printf "%s" "$icon_active"
            else
                printf "%s" "$icon_inactive"
            fi
            ;;
    esac
}

service_toggle() {
    case "$2" in
        wireguard)
            "$auth" wireguard_toggle.sh "$1"
            ;;
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
        && "$0" \
        && polybar_services.sh --update
}

title="services"
table_width=39
table_width1=$((table_width + 2))
table_width2=$((table_width + 4))
message="
$("$path"helper/i3_table.sh "$table_width" "header" "enable/disable")
$("$path"helper/i3_table.sh "$table_width1" "l" "" \
    "$(service_status xautolock.service user) autolock")
$("$path"helper/i3_table.sh "$table_width1" "t" "侀" \
    "$(service_status i3_autotiling.service user) autotiling")
$("$path"helper/i3_table.sh "$table_width1" "c" "頋" \
    "$(service_status picom.service user) compositor")
$("$path"helper/i3_table.sh "$table_width1" "w" "" \
    "$(service_status wacom.service user) wacom")
$("$path"helper/i3_table.sh "$table_width1" "m" "" \
    "$(service_status xbanish.service user) mousepointer")
$("$path"helper/i3_table.sh "$table_width1" "s" "" \
    "$(service_status systemd-resolved.service) resolver")
$("$path"helper/i3_table.sh "$table_width1" "y" "ﮮ" \
    "$(service_status systemd-timesyncd.service) timesync")
$("$path"helper/i3_table.sh "$table_width1" "h" "撚" \
    "$(service_status sshd.service) ssh")
$("$path"helper/i3_table.sh "$table_width1" "v" "旅" \
    "$(service_status wg0 wireguard) vpn")
$("$path"helper/i3_table.sh "$table_width1" "p" "朗" \
    "$(service_status cups.service) printer")
$("$path"helper/i3_table.sh "$table_width1" "b" "" \
    "$(service_status bluetooth.service) bluetooth")

$("$path"helper/i3_table.sh "$table_width" "header" "polybar")
$(if [ "$(service_status polybar.service user)" = "$icon_active" ]; then
    printf "%s\n" \
        "$("$path"helper/i3_table.sh "$table_width1" "a" "" \
            "$icon_active bar")"
    printf "%s\n" \
        "$("$path"helper/i3_table.sh "$table_width2" "1" "" \
            "  ├─ primary   -> $(xrdb_query "Polybar.type.monitor1")")"
    printf "%s\n" \
        "$("$path"helper/i3_table.sh "$table_width2" "2" "" \
            "  ├─ secondary -> $(xrdb_query 'Polybar.type.monitor2')")"
    printf "%s\n" \
        "$("$path"helper/i3_table.sh "$table_width2" "0" "" \
            "  └─ reload")"
    printf "%s\n" \
        "$("$path"helper/i3_table.sh "$table_width2" "f" "參" \
            "     ├─ freshrss")"
    printf "%s\n" \
        "$("$path"helper/i3_table.sh "$table_width2" "o" "" \
            "     ├─ openweathermap")"
    printf "%s\n" \
        "$("$path"helper/i3_table.sh "$table_width2" "n" "" \
            "     ├─ pacman")"
    printf "%s\n" \
        "$("$path"helper/i3_table.sh "$table_width2" "r" "" \
            "     └─ trash-cli")"
else
    printf "%s" \
        "$("$path"helper/i3_table.sh "$table_width1" "a" "" \
            "$icon_inactive bar")"
fi)

[<b>q</b>]uit, [<b>return</b>], [<b>escape</b>], [<b>alt+space</b>]"

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
    --wacom)
        service_toggle "wacom.service" "user"
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
        service_toggle "wg0" "wireguard"
        ;;
    --kill)
        "$path"helper/i3_notify.sh 1 "$title"
        ;;
    *)
        "$path"helper/i3_notify.sh 0 "$title" "$message"
        ;;
esac
