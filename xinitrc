#!/bin/sh
#########################
#
# called by startx. start wms here
#
#########################

DEFAULT_SESSION=gnome-session

case $1 in
awesome)
	exec awesome
	;;
gnome)
	exec ck-launch-session gnome-session
	;;
xfce4)
	exec startxfce4
	;;
blackbox)
	exec blackbox
	;;
*)	
	exec ck-launch-session $DEFAULT_SESSION
	;;
esac
