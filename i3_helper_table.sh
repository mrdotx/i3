#!/bin/sh

# path:   /home/klassiker/.local/share/repos/i3/i3_helper_table.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/i3
# date:   2022-05-13T19:18:33+0200

table_line="─"
table_divider="┬"
line_divider="│"

table_width="$1"
key="$2"
description="$3"

fixed_column=3
variable_column=$((table_width - fixed_column - 1))

set_spacer() {
    i=$1
    while [ "$i" -gt 0 ]; do
        printf "%s" "${2:-" "}"
        i=$((i -1))
    done
}

case "$key" in
    header)
        printf "<i>%s</i>\n%s%s%s" \
            "$description" \
            "$(set_spacer "$variable_column" "$table_line")" \
            "$table_divider" \
            "$(set_spacer "$fixed_column" "$table_line")"
        ;;
    *)
        printf " %s %s%s <b>%s</b>" \
            "$description" \
            "$(set_spacer "$((variable_column - ${#description} - 2))")" \
            "$line_divider" \
            "$key"
        ;;
esac
