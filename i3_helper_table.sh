#!/bin/sh

# path:   /home/klassiker/.local/share/repos/i3/i3_helper_table.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/i3
# date:   2022-05-12T09:12:40+0200

table_line="─"
table_divider="┬"
line_divider="│"

set_spacer() {
    i=$1
    while [ "$i" -gt 0 ]; do
        printf "%s" "$2"
        i=$((i -1))
    done
}

case "$1" in
    header)
        printf "<i>%s</i>\n" "$3"
        printf "%s%s%s" \
            "$(set_spacer 3 "$table_line")" \
            "$table_divider" \
            "$(set_spacer "$2" "$table_line")"
        ;;
    *)
        printf " <b>%s</b> %s %s %s" \
            "$1" \
            "$line_divider" \
            "$2" \
            "$3"
        ;;
esac
