#!/bin/sh

# path:   /home/klassiker/.local/share/repos/i3/i3_ssh.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/i3
# date:   2024-08-19T15:32:23+0200

# i3 helper
. i3_helper.sh

title="ssh"
table_width=26
message="
$(i3_table "$table_width" "header" "server")
$(i3_table "$table_width" "m" "󰒍" "m625q")

$(i3_table "$table_width" "header" "client")
$(i3_table "$table_width" "n" "󰌢" "mi")
$(i3_table "$table_width" "b" "󰌢" "macbook")

[<b>q</b>]uit, [<b>return</b>], [<b>escape</b>]"

connect () {
    host="${1##*--}"

    i3_net_check "$host" \
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
        i3_notify 1 "$title"
        ;;
    *)
        i3_notify 0 "$title" "$message"
        ;;
esac
