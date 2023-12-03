#!/bin/sh

# path:   /home/klassiker/.local/share/repos/i3/i3_nfs.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/i3
# date:   2023-12-03T09:24:14+0100

# speed up script by using standard c
LC_ALL=C
LANG=C

# auth can be something like sudo -A, doas -- or nothing,
# depending on configuration requirements
auth="${EXEC_AS_USER:-sudo}"
icon_active="󰨚"
icon_inactive="󰨙"

server="m625q"
folder="/home/klassiker"
options="noatime,vers=4"

# i3 helper
. i3_helper.sh

nfs_status() {
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

nfs_toggle() {
    shares="$*"
    for share in $shares; do
        mountpoint -q "$folder/$share"
        case $? in
            0)
                $auth umount "$folder/$share"
                ;;
            *)
                $auth mount -t nfs -o "$options" \
                    "$server:/$share" \
                    "$folder/$share"
                ;;
        esac \
            && "$0"
    done
}

nfs_mount() {
    shares="$*"
    for share in $shares; do
        mountpoint -q "$folder/$share" \
            || $auth mount -t nfs -o "$options" \
                "$server:/$share" \
                "$folder/$share"
    done
}

nfs_umount() {
    shares="$*"
    for share in $shares; do
        mountpoint -q "$folder/$share" \
            && $auth umount "$folder/$share"
    done
}

title="nfs"
table_width=43
table_width1=$((table_width + 4))
message="
$(i3_table "$table_width" "header" "$server mounts")
$(i3_table "$table_width" "a" "󰒍" "toggle all")
$(i3_table "$table_width1" "c" "$(nfs_status Cloud)" \
    "├─ $folder/Cloud")
$(i3_table "$table_width1" "d" "$(nfs_status Desktop)" \
    "├─ $folder/Desktop")
$(i3_table "$table_width1" "m" "$(nfs_status Music)" \
    "├─ $folder/Music")
$(i3_table "$table_width1" "p" "$(nfs_status Public)" \
    "├─ $folder/Public")
$(i3_table "$table_width1" "t" "$(nfs_status Templates)" \
    "├─ $folder/Templates")
$(i3_table "$table_width1" "v" "$(nfs_status Videos)" \
    "├─ $folder/Videos")
$(i3_table "$table_width" "\\\\" "󰒍" "toggle default")

[<b>q</b>]uit, [<b>return</b>], [<b>escape</b>], [<b>super+shift+\\\</b>]"

case "$1" in
    --all)
        i3_net_check "$server" \
            && nfs_toggle "Cloud Desktop Music Public Templates Videos"
        ;;
    --default)
        i3_net_check "$server" \
            && nfs_toggle "Cloud Desktop Music Public Videos"
        ;;
    --kill)
        i3_notify 1 "$title"
        ;;
    --mount)
        shift

        i3_net_check "$server" \
            && nfs_mount "$*"
        ;;
    --umount)
        shift

        i3_net_check "$server" \
            && nfs_umount "$*"
        ;;
    --*)
        i3_net_check "$server" \
            && nfs_toggle "${1##*--}"
        ;;
    *)
        i3_notify 0 "$title" "$message"
        ;;
esac
