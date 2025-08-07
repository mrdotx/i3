#!/bin/sh

# path:   /home/klassiker/.local/share/repos/i3/_i3_lock.sh
# author: klassiker [mrdotx]
# url:    https://github.com/mrdotx/i3
# date:   2025-08-07T05:32:00+0200

# speed up script by using standard c
LC_ALL=C
LANG=C

# WORKAROUND: https://github.com/i3/i3/issues/3298
# sleep .5

slock -m "$(cinfo -a)" &
