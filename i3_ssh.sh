#!/bin/sh

# path:   /home/klassiker/.local/share/repos/i3/i3_ssh.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/i3
# date:   2023-01-23T08:33:41+0100

basename=${0##*/}
path=${0%"$basename"}

title="ssh"
table_width=37
message="
$("$path"helper/i3_table.sh "$table_width" "header" "server")
$("$path"helper/i3_table.sh "$table_width" "m" "歷" "m625q")

$("$path"helper/i3_table.sh "$table_width" "header" "client")
$("$path"helper/i3_table.sh "$table_width" "n" "" "mi")
$("$path"helper/i3_table.sh "$table_width" "b" "" "macbook")

[<b>q</b>]uit, [<b>return</b>], [<b>escape</b>], [<b>super+h</b>]"

connect () {
    host="${1##*--}"
    i3_tmux.sh -o "$2" "$host" "ssh $host"
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
        "$path"helper/i3_notify.sh 1 "$title"
        ;;
    *)
        "$path"helper/i3_notify.sh 0 "$title" "$message"
        ;;
esac
