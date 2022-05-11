#!/bin/sh

# path:   /home/klassiker/.local/share/repos/i3/i3_ssh.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/i3
# date:   2022-05-11T20:09:53+0200

title="i3 ssh mode"
table_width=33
message="
$(i3_helper_table.sh "header" "$table_width" "server")
$(i3_helper_table.sh "p" "pi")
$(i3_helper_table.sh "i" "pi2")
$(i3_helper_table.sh "n" "nas")

$(i3_helper_table.sh "header" "$table_width" "client")
$(i3_helper_table.sh "m" "mi")
$(i3_helper_table.sh "b" "macbook")

$(i3_helper_table.sh "header" "$table_width" "other")
$(i3_helper_table.sh "s" "pi + pi2")

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
