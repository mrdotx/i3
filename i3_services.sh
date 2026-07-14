#!/bin/sh

# path:   /home/klassiker/Projects/repos/i3/i3_services.sh
# author: klassiker [mrdotx]
# url:    https://github.com/mrdotx/i3
# date:   2026-07-14T02:01:00+0200

# auth can be something like sudo -A, doas -- or nothing,
# depending on configuration requirements
auth="${EXEC_AS_USER:-sudo}"
icon_active="󰨚"
icon_inactive="󰨙"
wireguard_config="90-vpn_$(uname -n)"

# source i3 helper
. _i3_helper.sh

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
table_width=26
message="
$(i3_table "$table_width" "header" "enable/disable")
$(i3_table "$table_width" "t" "󰕴" \
    "$(service_status i3_autotiling.service user) autotiling")
$(i3_table "$table_width" "l" "󰌾" \
    "$(service_status xautolock.service user) autolock")
$(i3_table "$table_width" "c" "󰗌" \
    "$(service_status picom.service user) compositor")
$(i3_table "$table_width" "m" "󰇀" \
    "$(service_status xhidecursor.service user) mousepointer")
$(i3_table "$table_width" "w" "󰏪" \
    "$(service_status wacom.service user) wacom")
$(i3_table "$table_width" "1" "󰎤" \
    "$(service_status numlockx.service user) numlock")
$(i3_table "$table_width" "d" "󰇧" \
    "$(service_status systemd-resolved.service) resolver")
$(i3_table "$table_width" "y" "󱫬" \
    "$(service_status systemd-timesyncd.service) timesync")
$(i3_table "$table_width" "s" "󰒒" \
    "$(service_status sshd.service) ssh")
$(i3_table "$table_width" "v" "󰒄" \
    "$(service_status "$wireguard_config" wireguard) vpn")
$(i3_table "$table_width" "p" "󰐪" \
    "$(service_status cups.service) printer")
$(i3_table "$table_width" "b" "󰂯" \
    "$(service_status bluetooth.service) bluetooth")

$(i3_table "$table_width" "header" "polybar")
$(if [ "$(service_status polybar.service user)" = "$icon_active" ]; then
    printf "%s\n" \
        "$(i3_table "$table_width" "a" "󰄱" \
            "$icon_active bar")"
    printf "%s\n" \
        "$(i3_table "$table_width" "z" "󰆖" \
            "  ├─ toggle")"
    printf "%s\n" \
        "$(i3_table "$table_width" "r" "󰑐" \
            "  ├─ reload")"
    printf "%s\n" \
        "$(i3_table "$table_width" "o" "" \
            "  │  ├─ weather")"
    printf "%s\n" \
        "$(i3_table "$table_width" "f" "󰑬" \
            "  │  ├─ rss")"
    printf "%s\n" \
        "$(i3_table "$table_width" "n" "󰏗" \
            "  │  ├─ packages")"
    printf "%s\n" \
        "$(i3_table "$table_width" "x" "󰩺" \
            "  │  └─ trash")"
    printf "%s\n" \
        "$(i3_table "$table_width" "0" "󰎣" \
            "  └─ restart")"
else
    printf "%s" \
        "$(i3_table "$table_width" "a" "󰄮" \
            "$icon_inactive bar")"
fi)

[<b>q</b>]uit, [<b>escape</b>], [<b>return</b>]"

case "$1" in
    --polybar)
        service_toggle "polybar.service" "user"
        ;;
    --tiling)
        service_toggle "i3_autotiling.service" "user"
        ;;
    --autolock)
        service_toggle "xautolock.service" "user"
        ;;
    --compositor)
        service_toggle "picom.service" "user"
        ;;
    --mousepointer)
        service_toggle "xhidecursor.service" "user"
        ;;
    --wacom)
        service_toggle "wacom.service" "user"
        ;;
    --numlock)
        service_toggle "numlockx.service" "user"
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
            service_toggle "cups.service"
        else
            service_toggle "cups.service"
        fi
        ;;
    --resolver)
        if systemctl -q is-active systemd-resolved.service; then
            service_toggle "systemd-resolved.service" \
                && $auth cp --remove-destination \
                    "/etc/resolv.conf.m625q" "/etc/resolv.conf"
        else
            service_toggle "systemd-resolved.service" \
                && $auth ln --force --symbolic \
                    "/run/systemd/resolve/resolv.conf" "/etc/resolv.conf"
        fi
        ;;
    --timesync)
        service_toggle "systemd-timesyncd.service"
        ;;
    --ssh)
        service_toggle "sshd.service"
        ;;
    --vpn)
        service_toggle "$wireguard_config" "wireguard"
        ;;
    --kill)
        i3_notify 1 "$title"
        ;;
    *)
        i3_notify 0 "$title" "$message"
        ;;
esac
