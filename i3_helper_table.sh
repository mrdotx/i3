#!/bin/sh

# path:   /home/klassiker/.local/share/repos/i3/i3_helper_table.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/i3
# date:   2022-05-11T19:49:19+0200

divider=" │ "

case "$1" in
    header)
        i=$2
        printf "<i>%s</i>\n" "$3"
        printf "───┬"
        while [ "$i" -gt 0 ]; do
            printf "─"
            i=$((i -1))
        done
        ;;
    *)
        printf " <b>%s</b>%s%s %s" \
            "$1" \
            "$divider" \
            "$2" \
            "$3"
        ;;
esac
