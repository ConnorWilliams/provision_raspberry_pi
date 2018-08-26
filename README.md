1. Clone the gist
2. Download the Raspbian lite image
3. Populate your public SSH keys in `template-authorized_keys` on the Linux host. I.e. `cp ~/.ssh/id_rsa.pub template-authorized-keys`
2. Edit `make-rpi.sh` and update `export DEV=` to the device you see on `lsblk`
3. Edit `template-dhcpcd.conf` if your IP range isn't `192.168.0.0/24`
4. Run `sudo ./make-rpi node-1 101` to get `node-1.local` and `192.168.0.101` and so on.

For help etc contact me via Twitter @alexellisuk or Join @openfaas Slack #arm-and-pi channel.