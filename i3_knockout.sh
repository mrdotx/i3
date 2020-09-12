#!/bin/sh

# path:       /home/klassiker/.local/share/repos/i3/i3_knockout.sh
# author:     klassiker [mrdotx]
# github:     https://github.com/mrdotx/i3
# date:       2020-09-12T14:50:54+0200

script=$(basename "$0")
help="$script [-h/--help] -- script to \"knockout\" the system
  Usage:
    $script [-lock/-suspend/-logout/-reboot/-shutdown] [lockmethod]

  Settings:
    [-lock]         = lock the screen with [lockmethod]
    [-suspend]      = suspend or suspend with [lockmethod]

    [lockmethod]    = method to lock the screen
      blur          = blured screenshot of the desktop
      simple        = single color with message

    [-logout]       = logout from current session
    [-reboot]       = reboot the system
    [-shutdown]     = shutdown the system

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
lock_simple() {
    slock -m "$(/home/klassiker/.local/share/repos/shell/status.sh)" &
}

# take screenshot, blur it and lock the screen with i3lock
lock_blur() {
    # take screenshot
    maim -B -u /tmp/screenshot.png

    # blur
    convert -scale 10% -blur 0x2.5 -resize 1000% /tmp/screenshot.png /tmp/screenshot_blur.png

    # lock the screen
    i3lock -i /tmp/screenshot_blur.png
}

case "$1" in
    -h | --help)
        printf "%s\n" "$help"
        ;;
    -lock)
        if [ "$2" = "blur" ]; then
            lock_blur
        elif [ "$2" = "simple" ]; then
            lock_simple
        else
            printf "%s\n" "$help"
        fi
        ;;
    -suspend)
        if [ -z "$2" ]; then
            systemctl suspend
        elif [ "$2" = "blur" ]; then
            lock_blur && systemctl suspend
        elif [ "$2" = "simple" ]; then
            lock_simple && systemctl suspend
        else
            printf "%s\n" "$help"
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
        exit 1
esac
