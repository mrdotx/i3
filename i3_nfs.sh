#!/bin/sh

# path:   /home/klassiker/.local/share/repos/i3/i3_nfs.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/i3
# date:   2023-02-27T17:48:45+0100

# speed up script by using standard c
LC_ALL=C
LANG=C

# auth can be something like sudo -A, doas -- or nothing,
# depending on configuration requirements
auth="${EXEC_AS_USER:-sudo}"
icon_active="蘒"
icon_inactive="﨡"

server="m625q"
folder="/home/klassiker"
options="noatime,vers=4"

basename=${0##*/}
path=${0%"$basename"}

mount_status() {
    mountpoint -q "$folder/$1"
    case $? in
        0)
            printf "%s" "$icon_active"
            ;;
        *)
            printf "%s" "$icon_inactive"
            ;;
    esac
}

title="nfs"
table_width=51
table_width1=$((table_width + 4))
message="
$("$path"helper/i3_table.sh "$table_width" "header" "$server mounts")
$("$path"helper/i3_table.sh "$table_width" "a" "󰒍" "toggle all")
$("$path"helper/i3_table.sh "$table_width1" "d" "$(mount_status Desktop)" \
    "├─ $folder/Desktop")
$("$path"helper/i3_table.sh "$table_width1" "l" "$(mount_status Downloads)" \
    "├─ $folder/Downloads")
$("$path"helper/i3_table.sh "$table_width1" "m" "$(mount_status Music)" \
    "├─ $folder/Music")
$("$path"helper/i3_table.sh "$table_width1" "p" "$(mount_status Public)" \
    "├─ $folder/Public")
$("$path"helper/i3_table.sh "$table_width1" "t" "$(mount_status Templates)" \
    "├─ $folder/Templates")
$("$path"helper/i3_table.sh "$table_width1" "v" "$(mount_status Videos)" \
    "└─ $folder/Videos")

[<b>q</b>]uit, [<b>return</b>], [<b>escape</b>], [<b>super+shift+backslash</b>]"

mount_toggle() {
    ! "$path"helper/i3_net_check.sh "$server" \
        && exit 1

    # shellcheck disable=SC2068
    for share in $@; do
        mountpoint -q "$folder/$share"
            case $? in
                0)
                    $auth umount "$folder/$share" \
                    ;;
                *)
                    $auth mount -t nfs -o "$options" \
                        "$server:/$share" "$folder/$share"
                    ;;
            esac \
                && "$0"
    done
}

mount_silent() {
    ! "$path"helper/i3_net_check.sh "$server" \
        && exit 1

    # shellcheck disable=SC2068
    for share in $@; do
        ! mountpoint -q "$folder/$share" \
            && $auth mount -t nfs -o "$options" \
                "$server:/$share" "$folder/$share"
    done
}

case "$1" in
    --all)
        mount_toggle "Desktop Downloads Music Public Templates Videos"
        ;;
    --autostart)
        mount_silent "Desktop Downloads Music Public Templates Videos"
        ;;
    --desktop)
        mount_toggle "Desktop"
        ;;
    --downloads)
        mount_toggle "Downloads"
        ;;
    --music)
        mount_toggle "Music"
        ;;
    --public)
        mount_toggle "Public"
        ;;
    --templates)
        mount_toggle "Templates"
        ;;
    --videos)
        mount_toggle "Videos"
        ;;
    --kill)
        "$path"helper/i3_notify.sh 1 "$title"
        ;;
    *)
        "$path"helper/i3_notify.sh 0 "$title" "$message"
        ;;
esac
