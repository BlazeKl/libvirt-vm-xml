#!/bin/bash
set -x
USER=`users | cut -f 1 -d ' '`

#Stop service
systemctl start sshd.service
systemctl start smb.service

#Reallocate Cores
systemctl set-property --runtime -- user.slice AllowedCPUs=0-15
systemctl set-property --runtime -- system.slice AllowedCPUs=0-15
systemctl set-property --runtime -- init.scope AllowedCPUs=0-15

#Enable main display
su -l $USER -c "DISPLAY=:0 xrandr --output HDMI-0 --mode 1920x1080 --rate 74  --left-of DP-0"
