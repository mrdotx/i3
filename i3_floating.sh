#!/bin/sh

# path:   /home/klassiker/.local/share/repos/i3/i3_floating.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/i3
# date:   2024-08-21T22:24:49+0200

# speed up script by using standard c
LC_ALL=C
LANG=C

# i3 helper
. i3_helper.sh

title="floating"
table_width=26
message="
$(i3_table "$table_width" "header" "output")
$(i3_table "$table_width" "󰞕" "󰍹" "non primary")
$(i3_table "$table_width" "󰞒" "󰍹" "primary")
$(i3_table "$table_width" "0" "󰕴" "tiling")

<i>position</i>
──────────────────────────
 ┌───────────────────────┐
 │[<b>1</b>]       [<b>2</b>]       [<b>3</b>]│
 │                       │
 │[<b>4</b>]       [<b>5</b>]       [<b>6</b>]│
 │                       │
 │[<b>7</b>]       [<b>8</b>]       [<b>9</b>]│
 └───────────────────────┘

[<b>q</b>]uit, [<b>escape</b>], [<b>return</b>]"

case "$1" in
    --kill)
        i3_notify 1 "$title"
        ;;
    *)
        i3_notify 0 "$title" "$message"
        ;;
esac
