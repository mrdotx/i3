#!/bin/sh

# path:       /home/klassiker/.local/share/repos/i3/i3_cmus.sh
# author:     klassiker [mrdotx]
# github:     https://github.com/mrdotx/i3
# date:       2020-06-08T11:09:35+0200

# start cmus, if it's running toggle from/to i3 scratchpad
if pgrep -x cmus; then
    i3-msg [title="cmus" instance="$TERMINAL"] scratchpad show
else
    cmus \
        && polybar-msg hook module/cmus 1
fi