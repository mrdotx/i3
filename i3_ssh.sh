#!/bin/sh

# path:   /home/klassiker/.local/share/repos/i3/i3_ssh.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/i3
# date:   2023-03-02T11:57:48+0100

basename=${0##*/}
path=${0%"$basename"}
i3_table="${path}helper/i3_table.sh"
i3_notify="${path}helper/i3_notify.sh"

title="ssh"
table_width=37
message="
$("$i3_table" "$table_width" "header" "server")
$("$i3_table" "$table_width" "m" "歷" "m625q")

$("$i3_table" "$table_width" "header" "client")
$("$i3_table" "$table_width" "n" "" "mi")
$("$i3_table" "$table_width" "b" "" "macbook")

[<b>q</b>]uit, [<b>return</b>], [<b>escape</b>], [<b>super+h</b>]"

connect () {
    host="${1##*--}"

    "$path"helper/i3_net_check.sh "$host" \
        && i3_tmux.sh -o "$2" "$host" "ssh $host"
}

case "$1" in
    --m625q)
        connect "$1" 23
        ;;
    --mi)
        connect "$1" 24
        ;;
    --macbook)
        connect "$1" 25
        ;;
    --kill)
        "$i3_notify" 1 "$title"
        ;;
    *)
        "$i3_notify" 0 "$title" "$message"
        ;;
esac
