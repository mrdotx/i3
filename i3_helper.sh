#!/bin/sh

# path:   /home/klassiker/.local/share/repos/i3/i3_helper.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/i3
# date:   2023-11-27T22:36:07+0100

i3_table() {
    i3_table_line="─"
    i3_table_divider="┬"
    i3_table_line_divider="│"

    i3_table_fixed_column=3
    i3_table_variable_column=$(($1 - 2 - (2*i3_table_fixed_column)))

    set_spacer() {
        set_spacer_i=$1
        while [ "$set_spacer_i" -gt 0 ]; do
            printf "%s" "${2:-" "}"
            set_spacer_i=$((set_spacer_i - 1))
        done
    }

    case "$2" in
        header)
            printf "<i>%s</i>\n%s%s%s%s%s" \
                "$3" \
                "$(set_spacer "$i3_table_variable_column" "$i3_table_line")" \
                "$i3_table_divider" \
                "$(set_spacer "$i3_table_fixed_column" "$i3_table_line")" \
                "$i3_table_divider" \
                "$(set_spacer "$i3_table_fixed_column" "$i3_table_line")"
            ;;
        *)
            printf " %s %s%s %s %s <b>%s</b>" \
                "$4" \
                "$(set_spacer "$((i3_table_variable_column - ${#4} - 2))")" \
                "$i3_table_line_divider" \
                "$3" \
                "$i3_table_line_divider" \
                "$2"
            ;;
    esac
}

i3_notify() {
    i3_notify_timer="$1"
    i3_notify_title="$2 [i3 mode]"
    i3_notify_message="$3"
    i3_notify_progress="$4"

    i3_notification() {
        i3_notification_urgency="$1"
        shift

        notify-send \
            -t "$i3_notify_timer" \
            -u "$i3_notification_urgency" \
            "$i3_notify_title" \
            "$i3_notify_message" \
            -h string:x-canonical-private-synchronous:"$i3_notify_title" \
            "$@"
    }

    case "$i3_notify_message" in
        "mouse pointer moved"*)
            i3_notification low
            ;;
        *)
            [ -z "$i3_notify_progress" ] \
                && i3_notification normal \
                && exit 0

            i3_notification low \
                -h int:value:"$i3_notify_progress"
            ;;
    esac
}

i3_net_check() {
    i3_net_check_address=${1:-1.1.1.1}
    i3_net_check_interval=${2:-10}

    while ! ping -c1 -W1 -q "$i3_net_check_address" >/dev/null 2>&1 \
        && [ "$i3_net_check_interval" -gt 0 ]; do
            sleep .1
            i3_net_check_interval=$((i3_net_check_interval - 1))
    done

    case "$i3_net_check_interval" in
        0)
            exit 1
            ;;
    esac
}
