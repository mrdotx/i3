#!/bin/sh

# path:   /home/klassiker/.local/share/repos/i3/i3_services.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/i3
# date:   2024-04-04T16:33:34+0200

# speed up script by using standard c
LC_ALL=C
LANG=C

# auth can be something like sudo -A, doas -- or nothing,
# depending on configuration requirements
auth="${EXEC_AS_USER:-sudo}"
icon_active="󰨚"
icon_inactive="󰨙"

# i3 helper
. i3_helper.sh

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
        resolv.conf.*)
            if systemctl -q is-active "$1"; then
                $auth systemctl disable "$1" --now
                $auth cp --remove-destination \
                    "/etc/$2" "/etc/resolv.conf"
            else
                $auth systemctl enable "$1" --now
                $auth ln --force --symbolic \
                    "/run/systemd/resolve/resolv.conf" "/etc/resolv.conf"
            fi
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
table_width1=$((table_width + 3))
table_width2=$((table_width + 4))
table_width3=$((table_width + 6))
message="
$(i3_table "$table_width" "header" "enable/disable")
$(i3_table "$table_width1" "l" "󰌾" \
    "$(service_status xautolock.service user) autolock")
$(i3_table "$table_width1" "t" "󰕴" \
    "$(service_status i3_autotiling.service user) autotiling")
$(i3_table "$table_width1" "c" "󰗌" \
    "$(service_status picom.service user) compositor")
$(i3_table "$table_width1" "w" "󰏪" \
    "$(service_status wacom.service user) wacom")
$(i3_table "$table_width1" "m" "󰇀" \
    "$(service_status xbanish.service user) mousepointer")
$(i3_table "$table_width1" "d" "󰇧" \
    "$(service_status systemd-resolved.service) resolver")
$(i3_table "$table_width1" "y" "󱫬" \
    "$(service_status systemd-timesyncd.service) timesync")
$(i3_table "$table_width1" "s" "󰒒" \
    "$(service_status sshd.service) ssh")
$(i3_table "$table_width1" "v" "󰒄" \
    "$(service_status wg0 wireguard) vpn")
$(i3_table "$table_width1" "p" "󰐪" \
    "$(service_status cups.service) printer")
$(i3_table "$table_width1" "b" "󰂯" \
    "$(service_status bluetooth.service) bluetooth")

$(i3_table "$table_width" "header" "polybar")
$(if [ "$(service_status polybar.service user)" = "$icon_active" ]; then
    printf "%s\n" \
        "$(i3_table "$table_width1" "a" "󰄱" \
            "$icon_active bar")"
    printf "%s\n" \
        "$(i3_table "$table_width2" "z" "󰆖" \
            "  ├─ toggle")"
    printf "%s\n" \
        "$(i3_table "$table_width2" "r" "󰑐" \
            "  ├─ reload")"
    printf "%s\n" \
        "$(i3_table "$table_width3" "o" "" \
            "  │  ├─ openweather")"
    printf "%s\n" \
        "$(i3_table "$table_width3" "f" "󰑬" \
            "  │  ├─ freshrss")"
    printf "%s\n" \
        "$(i3_table "$table_width3" "n" "󰏗" \
            "  │  ├─ pacman")"
    printf "%s\n" \
        "$(i3_table "$table_width3" "x" "󰩺" \
            "  │  └─ trash-cli")"
    printf "%s\n" \
        "$(i3_table "$table_width2" "0" "󰎣" \
            "  └─ restart")"
else
    printf "%s" \
        "$(i3_table "$table_width1" "a" "󰄮" \
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
                && service_toggle "colord.service"
        else
            service_toggle "cups.service"
        fi
        ;;
    --resolver)
        service_toggle "systemd-resolved.service" "resolv.conf.m625q"
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
        i3_notify 1 "$title"
        ;;
    *)
        i3_notify 0 "$title" "$message"
        ;;
esac
