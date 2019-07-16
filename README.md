## You'll need

* Raspberry Pi 3, 3+ or 2 (only)
* A Linux PC, laptop or Raspberry with SD card reader/slot
* A number of Raspberry Pis configured with Ethernet

You must have an SSH key, if you don't know what this is then type in `ssh-keygen` and follow the instructions.

## Provision each Raspberry Pi:

1. Clone the gist and run `chmod +x make-rpi.sh`
2. Download the [Raspbian Lite](https://www.raspberrypi.org/downloads/raspbian/) image and place it in the folder
3. Insert a formatted SD card into your SD card reader
4. Edit `make-rpi.sh` and update:
   *  `export DEV=` to the device you see on `lsblk` (or `diskutil list` on Mac) for your SD card reader
   *  `export IMAGE=` to the filename of the image you dowloaded
   *  `export COUNTRY_CODE =` to your 2-letter [ISO 3166 country code](https://www.iso.org/obp/ui/#search)
   *  `export SSH_PUB_KEY=` to the location of the SSH key to be used for logging in to the pi
   *  `export SSID =` to the wifi network you want the RPi to join
   *  `export PSK =` to the wifi password of the network
5. Edit `template-dhcpcd.conf` if your IP range isn't `192.168.0.0/24`
6. Run `sudo ./make-rpi node-1` to get `node-1.local` and so on.

### Notes:

* For security log-in by password is disabled. If you want to log in via password then comment out the lines in `make-rpi.sh` 
* **Do not** push any private passwords such as WiFi to a public repository

## `make-rpi`

1. Flashes SD card
2. Mounts card to machine
3. Adds SSH keys to RPi
4. Enables SSH on the RPi
5. Disables password login (so we have to use SSH keys)
6. Sets the RPi hostname
7. Reduces GPU memory on RPi 
8. Sets RPi static IP
9. Configures RPi wifi connectivity