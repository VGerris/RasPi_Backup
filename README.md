# RasPi_Backup

system backup for Raspberry Pi SD cards

# Why?
Regular backups are a must for any system, but especially important if you run a server which other people use. The last thing you want is server downtime due to a corrupted or dead SD card. There are many ways to do this such as with TimeShift or dedicated disk cloning like clonezilla, I am just documenting how I do it for Raspberry Pi SD cards.

### Advantages
- The created `.img` system image works with Raspi Imager. This means you essentially create your own Raspbian version.
- Move to smaller or larger SD card if you want.
- Use the same system image you create with other Raspberry Pis (even different models).
### Disadvantages
- The Server needs to be powered off and SD removed for the backup. (~approx 10 minutes, depending on SD card speed/size)

# The Script
Credit to `PragmaticLinux` for [this awesome guide](https://www.pragmaticlinux.com/2020/12/how-to-clone-your-raspberry-pi-sd-card-in-linux/) that the script is based on. You should never trust me or my scripts, you can read and see what it does.

Download this repository or [just the script](https://gitea.raspiweb.com/Gerge/RasPi_Backup/src/branch/main/raspiclone.sh) and make it executable with `chmod +x raspiclone.sh`

Before you use `raspiclone.sh` you need to configure the SD card and save location at the top of the file.
```
saveloc="/home/gerge" # where the backup is saved
piSDcard="mmcblk0" # make sure this is the SD card and not a partition (example mmcblk0p1 is invalid)
```
WARNING: If you do not have an internal SD card reader in your computer and use a USB adapter it will most likely be named `sda` `sdb` or `sdc`. If there are other USB drives it may be hard to tell, but if the SD reader is the only one plugged in it should always be `sda` and you can set up the script as such. Just be careful to not have other USB drives when cloning in the future, because you may accidentally clone a USB drive instead of your Pi SD card.

## How to Use
- power off your Pi and remove the SD card
- place SD card in your computer SD slot or adapter
- run the script with `./raspiclone.sh`, specify the filename when it asks and type password for sudo
- DONE, now you can put the SD card back in the Pi

## Use the backup
- open raspi Imager
- Choose OS > Use Custom > select your backup.img file
- DO NOT EDIT SETTINGS, leave it empty, the image already has everything.
- flash to an adequately sized SD (you can see the size of the `.img`)

The Pi will resize the partitons to use the full SD card, just like it would do with a fresh install, on first bootup.
