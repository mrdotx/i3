#!/bin/sh

# path:   /home/klassiker/.local/share/repos/i3/i3_ssh.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/i3
# date:   2022-05-20T12:55:47+0200

title="i3 ssh mode"
table_width=37
table_width1=$((table_width + 2))
message="
$(i3_helper_table.sh "$table_width" "header" "server")
$(i3_helper_table.sh "$table_width1" "p" "菉" "pi")
$(i3_helper_table.sh "$table_width1" "i" "菉" "pi2")
$(i3_helper_table.sh "$table_width1" "n" "力" "nas")

$(i3_helper_table.sh "$table_width" "header" "client")
$(i3_helper_table.sh "$table_width1" "m" "" "mi")
$(i3_helper_table.sh "$table_width1" "b" "" "macbook")

$(i3_helper_table.sh "$table_width" "header" "other")
$(i3_helper_table.sh "$table_width1" "s" "菉" "pi + pi2")

[<b>q</b>]uit, [<b>return</b>], [<b>escape</b>], [<b>super+h</b>]"

case "$1" in
    --pi)
        i3_tmux.sh -o 21 "pi" "ssh pi"
        ;;
    --pi2)
        i3_tmux.sh -o 22 "pi2" "ssh pi2"
        ;;
    --nas)
        i3_tmux.sh -o 23 "nas" "ssh nas"
        ;;
    --mi)
        i3_tmux.sh -o 24 "mi" "ssh mi"
        ;;
    --macbook)
        i3_tmux.sh -o 25 "macbook" "ssh macbook"
        ;;
    --pipi2)
        i3_tmux.sh -o 21 "pi" "ssh pi"
        i3_tmux.sh -o 22 "pi2" "ssh pi2"
        ;;
    --kill)
        i3_helper_notify.sh 1 "$title"
        ;;
    *)
        i3_helper_notify.sh 0 "$title" "$message"
        ;;
esac
