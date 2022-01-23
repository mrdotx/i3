#!/bin/sh

# path:   /home/klassiker/.local/share/repos/i3/i3_services.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/i3
# date:   2022-01-23T17:26:20+0100

# auth can be something like sudo -A, doas -- or nothing,
# depending on configuration requirements
auth="$EXEC_AS_USER"
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
<i>enable/disable</i>
  $(if [ "$(service_status polybar.service user)" = "$active" ]; then \
      printf "%s - polyb[<b>a</b>]r cycl[<b>e</b>]" \
        "$active"
  else
      printf "%s - polyb[<b>a</b>]r" "$inactive"
  fi)

  $(service_status rss.timer user) - [<b>r</b>]ss

  $(service_status xautolock.service user) - auto[<b>l</b>]ock
  $(service_status i3_autotiling.service user) - auto[<b>t</b>]iling
  $(service_status picom.service user) - [<b>c</b>]ompositor
  $(service_status xbanish.service user) - [<b>m</b>]ousepointer
  $(service_status bluetooth.service) - [<b>b</b>]luetooth
  $(service_status cups.service) - [<b>p</b>]rinter
  $(service_status systemd-resolved.service) - re[<b>s</b>]olver
  $(service_status systemd-timesyncd.service) - times[<b>y</b>]nc
  $(service_status sshd.service) - ss[<b>h</b>]
  $(service_status vpnc@hades.service) - [<b>v</b>]pn

<i>restart</i>
  [<b>d</b>]unst

<i>kill</i>
  [<b>u</b>]rxvtd

<i>toggle</i>
  cpu p[<b>o</b>]licy <b>$(cpu_policy.sh --status)</b>

<i>set</i>
  random [<b>w</b>]allpaper

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
    --polybar)
        service_toggle "polybar.service" "user"
        ;;
    --rss)
        service_toggle "rss.timer" "user" \
            && polybar_rss.sh --update
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
        if [ "$(systemctl is-active cups.service)" = "active" ]; then
            service_toggle "cups.service" \
                && sleep .5 \
                && service_toggle "avahi-daemon.service" \
                && service_toggle "avahi-daemon.socket" \
                && service_toggle "colord.service"
        else
            service_toggle "cups.service" \
                && service_toggle "avahi-daemon.service"
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
