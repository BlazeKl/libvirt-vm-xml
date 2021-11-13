#!/bin/bash
set -x
USER=`users | cut -f 1 -d ' '`

#Services
systemctl start sshd.service
systemctl start smb.service

#Isolate Cores
systemctl set-property --runtime -- user.slice AllowedCPUs=0,1
systemctl set-property --runtime -- system.slice AllowedCPUs=0,1
systemctl set-property --runtime -- init.scope AllowedCPUs=0,1

#Disable main display
su -l $USER -c "DISPLAY=:0 xrandr --output HDMI-0 --off"
