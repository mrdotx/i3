#!/bin/sh

# path:   /home/klassiker/Projects/repos/i3/i3_floating.sh
# author: klassiker [mrdotx]
# url:    https://github.com/mrdotx/i3
# date:   2026-07-14T02:00:45+0200

# source i3 helper
. _i3_helper.sh

title="floating"
message="
<i>position</i>
──────────────────────────
 ┌───────────────────────┐
 │ resize      [<b>←</b>,<b>→</b>,<b>↑</b>,<b>↓</b>] │
 ├───────────────────────┤
 │ [<b>7</b>]      [<b>8</b>]      [<b>9</b>] │
 │          [<b>w</b>]          │
 │ [<b>4</b>]   [<b>a</b>][<b>5</b>][<b>d</b>]   [<b>6</b>] │
 │          [<b>s</b>]          │
 │ [<b>1</b>]      [<b>2</b>]      [<b>3</b>] │
 ├───────────────────────┤
 │ disable           [<b>0</b>] │
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
