#!/bin/sh

# path:   /home/klassiker/.local/share/repos/i3/_i3_lock.sh
# author: klassiker [mrdotx]
# url:    https://github.com/mrdotx/i3
# date:   2026-03-28T05:14:53+0100

# speed up script by using standard c
LC_ALL=C
LANG=C

slock -m "$(cinfo -a)" &
