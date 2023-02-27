#!/bin/sh

# path:   /home/klassiker/.local/share/repos/i3/helper/i3_net_check.sh
# author: klassiker [mrdotx]
# github: https://github.com/mrdotx/i3
# date:   2023-02-27T10:29:13+0100

net=${1:-1.1.1.1}
check=${2:-10}

while ! ping -c1 -W1 -q "$net" >/dev/null 2>&1 \
    && [ "$check" -gt 0 ]; do
        sleep .1
        check=$((check - 1))
done

case "$check" in
    0)
        exit 1
        ;;
esac
