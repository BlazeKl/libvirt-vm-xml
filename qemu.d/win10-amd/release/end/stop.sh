#!/bin/bash
set -x
USER=`users | cut -f 1 -d ' '`

#Stop service
systemctl start sshd.service
systemctl start smb.service

#Enable main display
su -l $USER -c "DISPLAY=:0 xrandr --output HDMI-0 --auto --left-of DVI-D-0"
