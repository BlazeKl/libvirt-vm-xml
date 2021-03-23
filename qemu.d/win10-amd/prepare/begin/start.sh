#!/bin/bash
set -x
USER=`users | cut -f 1 -d ' '`

#Services
systemctl start sshd.service
systemctl start smb.service

#Disable main display
su -l $USER -c "DISPLAY=:0 xrandr --output HDMI-0 --off"
