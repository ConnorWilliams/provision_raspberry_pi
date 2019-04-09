#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

if [ -z $1 ]; then
  echo "Usage: ./make-rpi.sh <hostname> <ip-suffix>"
  echo "       ./make-rpi.sh node-1 101"
  echo "       ./make-rpi.sh node-2 102"
  exit 1
fi

export DEV='disk2'
export IMAGE='~/Downloads/2018-11-13-raspbian-stretch-lite.img'
export COUNTRY_CODE='NL'
export SSH_PUB_KEY='~/.ssh/home-pi.pub'
export SSID=''
export PSK=''

if [ -z "$SKIP_FLASH" ];
then
  echo "Writing Raspbian Lite image to SD card"
  time dd if=$IMAGE of=/dev/$DEV bs=1M
fi

sync

echo "Mounting SD card from /dev/$DEV"

mount /dev/${DEV}1 /mnt/rpi/boot
mount /dev/${DEV}2 /mnt/rpi/root

# Add our SSH key
mkdir -p /mnt/rpi/root/home/pi/.ssh/
cat $SSH_PUB_KEY > /mnt/rpi/root/home/pi/.ssh/authorized_keys

# Enable ssh
touch /mnt/rpi/boot/ssh

# Disable password login

sed -ie s/#PasswordAuthentication\ yes/PasswordAuthentication\ no/g /mnt/rpi/root/etc/ssh/sshd_config

echo "Setting hostname: $1"

sed -ie s/raspberrypi/$1/g /mnt/rpi/root/etc/hostname
sed -ie s/raspberrypi/$1/g /mnt/rpi/root/etc/hosts

# Reduce GPU memory to minimum
echo "gpu_mem=16" >> /mnt/rpi/boot/config.txt

# Set static IP
cp /mnt/rpi/root/etc/dhcpcd.conf /mnt/rpi/root/etc/dhcpcd.conf.orig

sed s/100/$2/g template-dhcpcd.conf > /mnt/rpi/root/etc/dhcpcd.conf

# Set wifi details
/mnt/rpi/boot/wpa_supplicant.conf << WPASUPPLICANT
    ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
    update_config=1
    country=$COUNTRY_CODE

    network={
        ssid=$SSID
        psk=$PSK
        key_mgmt=WPA-PSK
    }
WPASUPPLICANT

echo "Unmounting SD Card"

umount /mnt/rpi/boot
umount /mnt/rpi/root

sync
