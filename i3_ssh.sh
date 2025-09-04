#!/bin/sh

# path:   /home/klassiker/.local/share/repos/i3/i3_ssh.sh
# author: klassiker [mrdotx]
# url:    https://github.com/mrdotx/i3
# date:   2025-09-04T04:40:48+0200

# source i3 helper
. _i3_helper.sh

title="ssh"
table_width=26
message="
$(i3_table "$table_width" "header" "host")
$(i3_table "$table_width" "m" "󰒍" "m625q")
$(i3_table "$table_width" "d" "󰇅" "m75q")
$(i3_table "$table_width" "n" "󰌢" "t14")
$(i3_table "$table_width" "b" "󰌢" "macbook")

[<b>q</b>]uit, [<b>escape</b>], [<b>return</b>]"

case "$1" in
    --host)
        shift
        i3_net_check "$1" \
            && i3_tmux.sh -o "$2" "$1" "ssh $1"
        ;;
    --kill)
        i3_notify 1 "$title"
        ;;
    *)
        i3_notify 0 "$title" "$message"
        ;;
esac
