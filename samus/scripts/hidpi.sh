#!/bin/bash
# set monitor to be a bit more zoomed out for higher rez
set -ex
scaling="${1:-1.2}"
screen="$(xrandr | grep -v disconnected | grep connected | cut -d' ' -f1)"
[[ -z $screen ]] && echo "No screen found" && exit 1
gsettings set org.gnome.desktop.interface scaling-factor 2
xrandr --output "$screen" --scale "${scaling}x${scaling}"
geo="$(xrandr | grep $screen |awk '{print $4}')"
# eDP1 connected primary 3072x2040+0+0 (normal left inverted right x axis y axis) 272mm x 181mm
# set mouse to pan across whole screen
xrandr --output "$screen" --panning "$geo"

