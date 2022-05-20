#!/bin/sh

# path:   /home/klassiker/.local/share/repos/i3/i3_services.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/i3
# date:   2022-05-20T15:00:56+0200

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

title="i3 services mode"
table_width=39
table_width1=$((table_width + 2))
table_width2=$((table_width + 4))
table_width3=$((table_width + 6))
message="
$(i3_helper_table.sh "$table_width" "header" "enable/disable")
$(if [ "$(service_status polybar.service user)" = "$active" ]; then
    printf "%s\n" \
        "$(i3_helper_table.sh "$table_width2" "a" "" \
            "$active polybar")"
    printf "%s\n" \
        "$(i3_helper_table.sh "$table_width3" "1" "" \
            "├─ primary   -> $(xrdb_query "Polybar.type.monitor1")")"
    printf "%s\n" \
        "$(i3_helper_table.sh "$table_width3" "2" "" \
            "├─ secondary -> $(xrdb_query 'Polybar.type.monitor2')")"
    printf "%s\n" \
        "$(i3_helper_table.sh "$table_width3" "r" "勒" \
            "└─ reload")"
else
    printf "%s" \
        "$(i3_helper_table.sh "$table_width2" "a" "" \
            "$inactive polybar")"
fi)
$(i3_helper_table.sh "$table_width2" "l" "ﱱ" \
    "$(service_status xautolock.service user) autolock")
$(i3_helper_table.sh "$table_width2" "t" "侀" \
    "$(service_status i3_autotiling.service user) autotiling")
$(i3_helper_table.sh "$table_width2" "c" "頋" \
    "$(service_status picom.service user) compositor")
$(i3_helper_table.sh "$table_width2" "m" "" \
    "$(service_status xbanish.service user) mousepointer")
$(i3_helper_table.sh "$table_width2" "s" "" \
    "$(service_status systemd-resolved.service) resolver")
$(i3_helper_table.sh "$table_width2" "y" "祥" \
    "$(service_status systemd-timesyncd.service) timesync")
$(i3_helper_table.sh "$table_width2" "h" "撚" \
    "$(service_status sshd.service) ssh")
$(i3_helper_table.sh "$table_width2" "v" "旅" \
    "$(service_status vpnc@hades.service) vpn")
$(i3_helper_table.sh "$table_width2" "p" "朗" \
    "$(service_status cups.service) printer")
$(i3_helper_table.sh "$table_width2" "b" "" \
    "$(service_status bluetooth.service) bluetooth")

$(i3_helper_table.sh "$table_width" "header" "restart")
$(i3_helper_table.sh "$table_width1" "d" "" "dunst")

$(i3_helper_table.sh "$table_width" "header" "kill")
$(i3_helper_table.sh "$table_width1" "u" "" "urxvt")

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
        i3_helper_notify.sh 1 "$title"
        ;;
    *)
        i3_helper_notify.sh 0 "$title" "$message"
        ;;
esac
