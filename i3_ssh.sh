#!/bin/sh

# path:   /home/klassiker/.local/share/repos/i3/i3_ssh.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/i3
# date:   2022-07-08T09:39:19+0200

basename=${0##*/}
path=${0%"$basename"}

title="ssh"
table_width=37
message="
$("$path"helper/i3_table.sh "$table_width" "header" "server")
$("$path"helper/i3_table.sh "$table_width" "p" "菉" "pi")
$("$path"helper/i3_table.sh "$table_width" "i" "菉" "pi2")
$("$path"helper/i3_table.sh "$table_width" "n" "力" "nas")

$("$path"helper/i3_table.sh "$table_width" "header" "client")
$("$path"helper/i3_table.sh "$table_width" "m" "" "mi")
$("$path"helper/i3_table.sh "$table_width" "b" "" "macbook")

$("$path"helper/i3_table.sh "$table_width" "header" "other")
$("$path"helper/i3_table.sh "$table_width" "s" "菉" "pi + pi2")

[<b>q</b>]uit, [<b>return</b>], [<b>escape</b>], [<b>super+h</b>]"

connect () {
    host="${1##*--}"
    i3_tmux.sh -o "$2" "$host" "ssh $host"
}

case "$1" in
    --pi)
        connect "$1" 21
        ;;
    --pi2)
        connect "$1" 22
        ;;
    --nas)
        connect "$1" 23
        ;;
    --mi)
        connect "$1" 24
        ;;
    --macbook)
        connect "$1" 25
        ;;
    --pipi2)
        connect "pi" 21
        connect "pi2" 22
        ;;
    --kill)
        "$path"helper/i3_notify.sh 1 "$title"
        ;;
    *)
        "$path"helper/i3_notify.sh 0 "$title" "$message"
        ;;
esac
