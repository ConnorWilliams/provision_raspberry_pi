## You'll need

* A Linux PC, laptop or Raspberry with SD card reader/slot
* A number of Raspberry Pis configured with Ethernet

## Provision each Raspberry Pi:

1. Clone the gist
2. Download the Raspbian lite image
3. Populate your public SSH keys in `template-authorized_keys` on the Linux host. I.e. `cp ~/.ssh/id_rsa.pub template-authorized-keys`
2. Edit `make-rpi.sh` and update `export DEV=` to the device you see on `lsblk`
3. Edit `template-dhcpcd.conf` if your IP range isn't `192.168.0.0/24`
4. Run `sudo ./make-rpi node-1 101` to get `node-1.local` and `192.168.0.101` and so on.

## Create a cluster

On each Raspberry Pi run

```
curl -sLS https://get.docker.com | sudo sh
```

Then on one Raspberry Pi (master) run:

```
docker swarm init --advertise-addr=eth0
```

One each of the others run the `docker swarm join` command that you were issued.

## Deploy a distributed system

[OpenFaaS](https://www.openfaas.com/) provides a way for you to build functions and run them across the capacity of your cluster including metrics, monitoring and auto-scaling with support for many programming languages.

On the master node:

```
git clone https://github.com/openfaas/faas
cd faas
./deploy_stack.armhf.sh
```

Now open up the OpenFaaS UI with: http://master-ip:8080/ and click "Deploy Function" to deploy a function from the built-in function store, or follow a tutorial at [https://www.openfaas.com](www.openfaas.com).

For help etc contact me via Twitter @alexellisuk or Join @openfaas Slack #arm-and-pi channel.