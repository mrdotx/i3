#!/bin/sh

# path:   /home/klassiker/.local/share/repos/i3/helper/i3_table.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/i3
# date:   2022-06-20T18:14:42+0200

table_line="─"
table_divider="┬"
line_divider="│"

fixed_column=3
icon_variance=2
variable_column=$(($1 - 1 - fixed_column - 1 - fixed_column))
shift

set_spacer() {
    i=$1
    while [ "$i" -gt 0 ]; do
        printf "%s" "${2:-" "}"
        i=$((i -1))
    done
}

case "$1" in
    header)
        printf "<i>%s</i>\n%s%s%s%s%s" \
            "$2" \
            "$(set_spacer "$variable_column" "$table_line")" \
            "$table_divider" \
            "$(set_spacer "$fixed_column" "$table_line")" \
            "$table_divider" \
            "$(set_spacer "$fixed_column" "$table_line")"
        ;;
    *)
        printf " %s %s%s %s %s <b>%s</b>" \
            "$3" \
            "$(set_spacer "$((variable_column - ${#3} - icon_variance))")" \
            "$line_divider" \
            "$2" \
            "$line_divider" \
            "$1"
        ;;
esac
