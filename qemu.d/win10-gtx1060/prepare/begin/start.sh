#!/bin/bash
set -x

# Stop display manager
killall klauncher latte-dock plasmashell
systemctl stop display-manager.service
systemctl stop systemd-logind.service
pkill -9 x
## Uncomment the following line if you use GDM
#killall gdm-x-session

sleep 5

# Unbind VTconsoles
echo 0 > /sys/class/vtconsole/vtcon0/bind
echo 0 > /sys/class/vtconsole/vtcon1/bind

# Unbind EFI-Framebuffer
echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/unbind

# Avoid a Race condition by waiting 2 seconds. This can be calibrated to be shorter or longer if required for your system
sleep 5

# Unload all Nvidia drivers
modprobe -r nvidia_drm
modprobe -r nvidia_modeset
modprobe -r nvidia_uvm
modprobe -r nvidia

# Unbind the GPU from display driver
virsh nodedev-detach pci_0000_07_00_0
virsh nodedev-detach pci_0000_07_00_1

# Load VFIO Kernel Module
modprobe vfio-pci

#Isolate Cores
systemctl set-property --runtime -- user.slice AllowedCPUs=0,1
systemctl set-property --runtime -- system.slice AllowedCPUs=0,1
systemctl set-property --runtime -- init.scope AllowedCPUs=0,1

#Services
systemctl start sshd.service
systemctl start smb.service
