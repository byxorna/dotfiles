#
# /etc/profile.d/motd.sh

MOTD_DATE=`date "+%A %B %d %F"`
MOTD_KERNEL=`uname -r`
MOTD_MEMORY="$(free -h | awk 'NR==2 { printf "RAM:  %s, Used: %s, Free: %s",$2,$3,$4; }')"
MOTD_DISKS=`df -h /dev/mapper/*|grep -v devtmpfs`
#MOTD_MEMORY=`free -h|awk '/Mem:/ {print $3"/"$2}'`
MOTD_ROOT=`df -h / | awk '/\// {print $(NF-1)}'`
MOTD_HOME=`df -h /home | awk '/\/home/ {print $(NF-1)}'`
MOTD_VAR=`df -h /var | awk '/\/var/ {print $(NF-1)}'`

SYSTEMCTL_STATUS=`SYSTEMD_COLORS=true systemctl status|head -n 4`
# clear # to clear the screen when showing up

printf "$MOTD_DATE\n\n"
printf "%s\n\n" "$MOTD_MEMORY"
printf "%s\n\n" "$SYSTEMCTL_STATUS"
