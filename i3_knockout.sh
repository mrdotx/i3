#!/bin/sh

# path:       /home/klassiker/.local/share/repos/i3/i3_knockout.sh
# author:     klassiker [mrdotx]
# github:     https://github.com/mrdotx/i3
# date:       2020-05-23T20:16:06+0200

script=$(basename "$0")
help="$script [-h/--help] -- script for \"knockout\" the system
  Usage:
    $script [-lock/-suspend/-logout/-reboot/-shutdown] [lockmethod]

  Settings:
    [-lock]         = lock the screen with [lockmethod]
    [-suspend]      = suspend or suspend with [lockmethod]
    [-logout]       = logout from current session
    [-reboot]       = reboot the system
    [-shutdown]     = shutdown the system
    [lockmethod]    = method to lock the screen
      blur          = blured screenshot of the desktop
      simple        = single color with message

  Examples:
    $script -lock blur
    $script -lock simple
    $script -suspend
    $script -suspend blur
    $script -suspend simple
    $script -logout
    $script -reboot
    $script -shutdown"

# suckless simple lock
lock_simple ()
{
    slock -m "$(printf "| host: %s\n\n| user: %s\n\n| date: %s\n\n| time: %s" \
        "$(hostname)" \
        "$(whoami)" \
        "$(date "+%d.%m.%Y")" \
        "$(date "+%k:%M:%S")" \
        )" &
}

# take screenshot, blur it and lock the screen with i3lock
lock_blur ()
{
    # take screenshot
    maim -B -u /tmp/screenshot.png

    # blur it
    #convert -scale 10% -blur 0x0.5 -resize 1000% /tmp/screenshot.png /tmp/screenshot_blur.png

    # more blur but faster
    convert -scale 10% -blur 0x2.5 -resize 1000% /tmp/screenshot.png /tmp/screenshot_blur.png

    # lock the screen
    i3lock -i /tmp/screenshot_blur.png
}

case "$1" in
    -lock)
        if [ "$2" = "blur" ]; then
            lock_blur
            exit 0
        elif [ "$2" = "simple" ]; then
            lock_simple
            exit 0
        else
            printf "%s\n" "$help"
            exit 0
        fi
        ;;
    -suspend)
        if [ -z "$2" ]; then
            systemctl suspend
            exit 0
        elif [ "$2" = "blur" ]; then
            lock_blur && systemctl suspend
            exit 0
        elif [ "$2" = "simple" ]; then
            lock_simple && systemctl suspend
            exit 0
        else
            printf "%s\n" "$help"
            exit 0
        fi
        ;;
    -logout)
        i3-msg exit
        ;;
    -reboot)
        systemctl reboot
        ;;
    -shutdown)
        systemctl poweroff
        ;;
    *)
        printf "%s\n" "$help"
        exit 0
esac
exit 0
