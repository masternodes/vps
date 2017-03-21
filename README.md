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
**0)** Download and tun this script on your VPS instance

**1)** change the amount of masternodes you want to install/configure at the top of the script ("eg SETUP_NODES_COUNT=3")

**2)** Add your masternode private key and IP configuration to the configuration file(s) located at ```/etc/pivx_n$NUM.conf```
For example, when installing three DNET masternodes:
```
* writing config file /etc/pivx_n1.conf
* writing config file /etc/pivx_n2.conf
* writing config file /etc/pivx_n3.conf
```

**3)** run ```/usr/local/bin/restart_masternodes.sh``` to activate the services permanently.
   Individual masternode data directories are located in ```/var/lib/pivx${NUMBER_OF_NODE}```

**4)** subsequently, you should only work as masternode user and not ```root```. The default user account created is ```pivxd```.
   Change to this user with the following command
```
vps:~ su - pivxd
```   

# Todo
* rewrite for config templates and provide my Dockerfile & Vagrantfile
* document the vultr signup and setup procedure
* currently not fully idempotent, be careful when running it often
* provide a delete / uninstall flag
* create a logfile 

Ping me at contact@marsmenschen.com for questions and send some crypto my way if you are happy.

**Have fun, this is crypto after all!**
```
BTC  1PboFDkBsW2i968UnehWwcSrM9Djq5LcLB
PIVX DBGBYLz484dWBb5wtk5gFVdJ8rGFfcob7R
```
