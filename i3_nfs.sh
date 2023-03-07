#!/bin/sh

# path:   /home/klassiker/.local/share/repos/i3/i3_nfs.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/i3
# date:   2023-03-07T12:37:11+0100

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
i3_table="${path}helper/i3_table.sh"
i3_notify="${path}helper/i3_notify.sh"

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

mount_nfs() {
    mountpoint -q "$folder/$1"
    case $? in
        0)
            $auth umount "$folder/$1"
            ;;
        *)
            $auth mount -t nfs -o "$options" "$server:/$1" "$folder/$1"
            ;;
    esac
}

title="nfs"
table_width=43
table_width1=$((table_width + 4))
message="
$("$i3_table" "$table_width" "header" "$server mounts")
$("$i3_table" "$table_width" "a" "歷" "toggle all")
$("$i3_table" "$table_width1" "d" "$(mount_status Desktop)" \
    "├─ $folder/Desktop")
$("$i3_table" "$table_width1" "l" "$(mount_status Downloads)" \
    "├─ $folder/Downloads")
$("$i3_table" "$table_width1" "m" "$(mount_status Music)" \
    "├─ $folder/Music")
$("$i3_table" "$table_width1" "p" "$(mount_status Public)" \
    "├─ $folder/Public")
$("$i3_table" "$table_width1" "t" "$(mount_status Templates)" \
    "├─ $folder/Templates")
$("$i3_table" "$table_width1" "v" "$(mount_status Videos)" \
    "└─ $folder/Videos")

[<b>q</b>]uit, [<b>return</b>], [<b>escape</b>], [<b>super+shift+\\\</b>]"

mount_toggle() {
    case "$1" in
        --silent)
            shift

            # shellcheck disable=SC2068
            "$path"helper/i3_net_check.sh "$server" \
                && for share in $@; do
                    mount_nfs "$share"
                done
                ;;
        *)
            # shellcheck disable=SC2068
            "$path"helper/i3_net_check.sh "$server" \
                && for share in $@; do
                    mount_nfs "$share" \
                        && "$0"
                done
                ;;
    esac
}

case "$1" in
    --all)
        mount_toggle "$2" "Desktop Downloads Music Public Templates Videos"
        ;;
    --kill)
        "$i3_notify" 1 "$title"
        ;;
    --*)
        mount_toggle "$2" "${1##*--}"
        ;;
    *)
        "$i3_notify" 0 "$title" "$message"
        ;;
esac
