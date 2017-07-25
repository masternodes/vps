# Intro

Here it is: dont be rude please, i write this mostly during my lunch break today to safe some time during the next couple of setups.

# Notes and features
* It is currently only tested on a vultr VPS but should work almost anywhere
* Developed with recent Ubuntu versions in mind, including 14.04/15.10/16.04/16.10
* This script doesnt care about the controller wallet side of things
* Installs 1-100 (or more!) masternodes in parallel on one machine, with individual config and data
* Compilation is currently from source for the desired git repo tag (currently 2.1.6-stable)
* Some security hardening is done, including firewalling and a separate user
* Automatic startup for all masternode daemons
* It's ipv6 enabled, tor/onion will follow
* This script needs to run as root, the masternodes will and should not!

# What do i need to do after running this script?
**0)** Download and tun this script on your VPS instance or an Ubuntu VM

**1)** change the amount of masternodes you want to install/configure at the top of the script ("eg SETUP_NODES_COUNT=3")

**2)** ADD your masternode private key to the configuration file(s) located at ```/etc/pivx_n$NUM.conf```. Optionally, adapt the IP configuration for multi-node-on-one-system setups.
For example, when installing three DNET masternodes:
```
* writing config file /etc/pivx_n1.conf
* writing config file /etc/pivx_n2.conf
* writing config file /etc/pivx_n3.conf
```

**3)** Still AS ROOT run ```/usr/local/bin/restart_masternodes.sh``` to activate the services permanently.
   Individual masternode data directories are located in ```/var/lib/pivx${NUMBER_OF_NODE}```

**4)** subsequently, you should only work as masternode user and not ```root```. The default user account created is ```pivxd```.
   You can change to this user with the following command
```
vps:~ su - pivxd
```   

# Todo
<<<<<<< HEAD
* rewrite for config templates and provide my Dockerfile & Vagrantfile
=======
>>>>>>> 71c62b0bdc2ba8772d19c73a3941e06f6f087c7f
* document the vultr signup and setup procedure
* provide a delete / uninstall flag
* create a logfile
* instert coin images into readme
* insert vultr signup reflink
* outsource common variables in commin source file
* check if masternode user already exists before creation
* add all flags everywhere ./configure --disable-dependency-tracking --enable-tests=no --without-gui --without-miniupnpc --with-incompatible-bdb CFLAGS="-march=native" LIBS="-lcurl -lssl -lcrypto -lz"

# Errors
* currently not fully idempotent (cfengine?)
* check if relevant interface already exists (sed) before writing to interfaces file


Ping me at contact@marsmenschen.com for questions and send some crypto my way if you are happy.

**Have fun, this is crypto after all!**
```
BTC  1PboFDkBsW2i968UnehWwcSrM9Djq5LcLB
<<<<<<< HEAD
PIVX DQS4rk57bteJ42FSNSPpwqHUoNhx4ywfQc
=======
DNET DBGBYLz484dWBb5wtk5gFVdJ8rGFfcob7R
SYNX SSKYwMhQQt9DcWozt7zA1tR3DmRuw1gT6b
DASH Xt1W8cVPxnx9xVmfe1yYM9e5DKumPQHaV5
MUE  7KV3NUX4g7rgEDHVfBttRWcxk3hrqGR4pH
MOJO MTfuWof2NMDPh57U18yniVzpaS2cq4nFFt
>>>>>>> 71c62b0bdc2ba8772d19c73a3941e06f6f087c7f
```
