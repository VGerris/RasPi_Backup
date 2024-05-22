#!/bin/bash

saveloc="/home/gerge" # where the backup is saved
piSDcard="mmcblk0" # make sure this is the SD card and not a partition (example mmcblk0p1 is invalid)
#piSDcard="sda" #if cloning a USB stick
#based on https://www.pragmaticlinux.com/2020/12/how-to-clone-your-raspberry-pi-sd-card-in-linux/
if [[ -d $saveloc ]]; then
  echo "save location $saveloc ok"
else
  echo "your save location $saveloc does not exists"
  exit
fi
if [[ -b /dev/$piSDcard ]]; then # -b checks if block device exixts
  echo "SD card $piSDcard ok"
else
  echo "your SD card $piSDcard does not exists"
  exit
fi

freearray=($(df -h $saveloc))
sdsize=($(lsblk | grep "^$piSDcard"))
echo "Minimum space required is ${sdsize[3]} (size of the SD card). You have ${freearray[10]} available."
echo 'give .img filename (file extension will be appended automatically):'
read name
name=$(date +%Y-%m-%d)_$name
sudo dd bs=4M if=/dev/$piSDcard of=$saveloc/$name.img conv=fsync status=progress
sudo chown $USER: $saveloc/$name.img
#exit #exit here if you copy something other than a Pi OS card
if [[ -f /usr/local/sbin/pishrink ]]; then
  echo 'found pishrink, shrinking empty space...'
  sudo pishrink $saveloc/$name.img
else
  echo 'You do not have pishrink, installing...'
  wget https://raw.githubusercontent.com/Drewsif/PiShrink/master/pishrink.sh
  chmod +x pishrink.sh
  sudo mv pishrink.sh /usr/local/sbin/pishrink
  echo 'shrinking empty space...'
  sudo pishrink $saveloc/$name.img
fi

