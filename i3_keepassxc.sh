#!/bin/sh

# path:       /home/klassiker/.local/share/repos/i3/i3_keepassxc.sh
# author:     klassiker [mrdotx]
# github:     https://github.com/mrdotx/i3
# date:       2020-06-04T09:30:47+0200

# start keepassxc, if it's running toggle from/to i3 scratchpad
if pgrep -x keepassxc; then
    i3-msg [class="KeePassXC"] scratchpad show
else
    sync_keepass.sh \
        && keepassxc \
        && sync_keepass.sh
fi
