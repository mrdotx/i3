#!/bin/sh

# path:       /home/klassiker/.local/share/repos/i3/i3_services.sh
# author:     klassiker [mrdotx]
# github:     https://github.com/mrdotx/i3
# date:       2020-11-16T19:58:33+0100

# auth can be something like sudo -A, doas -- or
# nothing, depending on configuration requirements
auth="doas"
active="[X]"
inactive="[ ]"

service_status() {
    case "$2" in
        user)
            if [ "$(systemctl --user is-active "$1")" = "active" ]; then
                printf "%s" "$active"
            else
                printf "%s" "$inactive"
            fi
            ;;
        *)
            if [ "$(systemctl is-active "$1")" = "active" ]; then
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
            if [ "$(systemctl --user is-active "$1")" = "active" ]; then
                systemctl --user disable "$1" --now
            else
                systemctl --user enable "$1" --now
            fi
            ;;
        *)
            if [ "$(systemctl is-active "$1")" = "active" ]; then
                $auth systemctl disable "$1" --now
            else
                $auth systemctl enable "$1" --now
            fi
            ;;
    esac \
        && $0 \
        && polybar_services.sh --update
}

title="i3 services mode"
message="
<i>restart</i>
  [<b>d</b>]unst

<i>enable/disable</i>
  $(service_status authentication.service user) - [<b>a</b>]uthentication
  $(service_status xautolock.service user) - auto[<b>l</b>]ock
  $(service_status bluetooth.service) - [<b>b</b>]luetooth
  $(service_status picom.service user) - [<b>c</b>]ompositor
  $(service_status ufw.service) - [<b>f</b>]irewall
  $(service_status gestures.service user) - [<b>g</b>]estures
  $(service_status xbanish.service user) - [<b>m</b>]ousepointer
  $(service_status org.cups.cupsd.service) - [<b>p</b>]rinter
  $(service_status systemd-resolved.service) - re[<b>s</b>]olver
  $(service_status rss.timer user) - [<b>r</b>]ss
  $(service_status i3_tiling.service user) - [<b>t</b>]iling
  $(service_status systemd-timesyncd.service) - times[<b>y</b>]nc
  $(service_status vpnc@hades.service) - [<b>v</b>]pn

[<b>q</b>]uit, [<b>return</b>], [<b>escape</b>], [<b>alt+space</b>]"

notification() {
    notify-send \
        -u low  \
        -t "$1" \
        -i "dialog-question" \
        "$title" \
        "$message" \
        -h string:x-canonical-private-synchronous:"$title"
}

# toggle service or start and kill notification tooltip
case "$1" in
    authentication)
        service_toggle "authentication.service" "user"
        ;;
    autolock)
        service_toggle "xautolock.service" "user"
        ;;
    bluetooth)
        service_toggle "bluetooth.service"
        ;;
    compositor)
        service_toggle "picom.service" "user"
        ;;
    firewall)
        service_toggle "ufw.service"
        ;;
    gestures)
        service_toggle "gestures.service" "user"
        ;;
    mousepointer)
        service_toggle "xbanish.service" "user"
        ;;
    printer)
        service="org.cups.cupsd.service"
        avahi_service="avahi-daemon.service"
        avahi_socket="avahi-daemon.socket"
        if [ "$(systemctl is-active $service)" = "active" ]; then
            service_toggle "$avahi_service" \
                && service_toggle "$avahi_socket" \
                && service_toggle "$service"
        else
            service_toggle "$service" \
                && service_toggle "$avahi_service"
        fi
        ;;
    resolver)
        service="systemd-resolved.service"
        network="systemd-networkd.service"
        avahi_socket="avahi-daemon.socket"
        if [ "$(systemctl is-active $service)" = "active" ]; then
            service_toggle "$service" \
                && service_toggle "$network"
        else
            service_toggle "$service" \
                && service_toggle "$network"
        fi
        ;;
    rss)
        service_toggle "rss.timer" "user" \
            && polybar_rss.sh --update
        ;;
    tiling)
        service_toggle "i3_tiling.service" "user"
        ;;
    vpn)
        service_toggle "vpnc@hades.service"
        ;;
    timesync)
        service_toggle "systemd-timesyncd.service"
        ;;
    --kill)
        notification 1
        ;;
    *)
        notification 0
        ;;
esac
