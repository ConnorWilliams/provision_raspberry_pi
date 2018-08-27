## You'll need

* Raspberry Pi 3, 3+ or 2 (only)
* A Linux PC, laptop or Raspberry with SD card reader/slot
* A number of Raspberry Pis configured with Ethernet

You must have an SSH key, if you don't know what this is then type in `ssh-keygen` and follow the instructions.

## Provision each Raspberry Pi:

1. Clone the gist and run `chmod +x make-rpi.sh`
2. Download the [Raspbian Lite](https://www.raspberrypi.org/downloads/raspbian/) image and place it in the folder
3. Populate your public SSH keys in `template-authorized_keys` on the Linux host. I.e. `cp ~/.ssh/id_rsa.pub template-authorized_keys`
4. Insert an SD card into your SD card reader
5. Edit `make-rpi.sh` and update `export DEV=` to the device you see on `lsblk` for your SD card reader
6. Edit `template-dhcpcd.conf` if your IP range isn't `192.168.0.0/24`
7. Run `sudo ./make-rpi node-1 101` to get `node-1.local` and `192.168.0.101` and so on.

Notes:

* For security log-in by password is disabled. If you want to log in via password then comment out the lines in `make-rpi.sh` 

## Create a cluster

On each Raspberry Pi run

```
curl -sLS https://get.docker.com | sudo sh
sudo usermod -aG docker pi
```

Then on one Raspberry Pi (master) run:

```
sudo apt update && sudo apt install -qy git
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

See also:

* [Serverless Kubernetes home-lab with your Raspberry Pis](https://blog.alexellis.io/serverless-kubernetes-on-raspberry-pi/)
* [Your Serverless Raspberry Pi cluster with Docker Swarm](https://blog.alexellis.io/your-serverless-raspberry-pi-cluster/) (original article)