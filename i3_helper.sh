#!/bin/sh

# path:   /home/klassiker/.local/share/repos/i3/i3_helper.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/i3
# date:   2023-11-28T08:37:40+0100

i3_set_spacer() {
    i3_set_spacer_i=$1
    while [ "$i3_set_spacer_i" -gt 0 ]; do
        printf "%s" "${2:-" "}"
        i3_set_spacer_i=$((i3_set_spacer_i - 1))
    done
}

i3_table() {
    i3_table_line="─"
    i3_table_divider="┬"
    i3_table_line_divider="│"

    i3_table_fixed_column=3
    i3_table_variable_column=$(($1 - 2 - (2*i3_table_fixed_column)))

    case "$2" in
        header)
            printf "<i>%s</i>\n%s%s%s%s%s" \
                "$3" \
                "$(i3_set_spacer "$i3_table_variable_column" "$i3_table_line")" \
                "$i3_table_divider" \
                "$(i3_set_spacer "$i3_table_fixed_column" "$i3_table_line")" \
                "$i3_table_divider" \
                "$(i3_set_spacer "$i3_table_fixed_column" "$i3_table_line")"
            ;;
        *)
            printf " %s %s%s %s %s <b>%s</b>" \
                "$4" \
                "$(i3_set_spacer "$((i3_table_variable_column - ${#4} - 2))")" \
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

    case "$i3_notify_message" in
        "mouse pointer moved"*)
            i3_notification_urgency="low"
            ;;
        *)
            i3_notification_urgency="normal"
            ;;
    esac

    notify-send \
        -t "$i3_notify_timer" \
        -u "$i3_notification_urgency" \
        "$i3_notify_title" \
        "$i3_notify_message" \
        -h string:x-canonical-private-synchronous:"$i3_notify_title"
}

i3_notify_progress() {
    i3_notify_progress_timer="$1"
    i3_notify_progress_title="$2 [i3 mode]"
    i3_notify_progress_message="$3"
    i3_notify_progress_value="$4"

    notify-send \
        -t "$i3_notify_progress_timer" \
        -u "low" \
        "$i3_notify_progress_title" \
        "$i3_notify_progress_message" \
        -h string:x-canonical-private-synchronous:"$i3_notify_progress_title" \
        -h int:value:"$i3_notify_progress_value"
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
