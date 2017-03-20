# Intro

Here it is: dont be rude please, i write this mostly during my lunch break today to safe some time during the next couple of setups.

# Notes and features
* it is currently only tested on a vultr VPS
* Should work for all recent Ubuntu versions, including 14.04/15.10/16.04/16.10
* this script doesnt care about the controller wallet side of things
* installs 1-100 (or more!) masternodes in parallel on one machine, with individual config and data
* compilation is currently from source for the desired git repo tag (currently 2.1.6-stable)
* some security hardening is done, including firewalling and a separate user
* automatic startup for all masternode daemons
* ipv6 enabled, tor/onion will follow
* this script needs to run as root, the masternodes will and should not!

# What do i need to do after running this script?
**0)** Download and tun this script on your VPS instance

**1)** change the amount of masternodes you want to install/configure at the top of the script ("eg SETUP_NODES_COUNT=3")

**2)** Add your masternode private key to the configuration file(s) located at ```/etc/pivx/...```
For example, when installing three DNET masternodes:
```
* writing config file /etc/pivx/pivx_n1.conf
* writing config file /etc/pivx/pivx_n2.conf
* writing config file /etc/pivx/pivx_n3.conf
```

**3)** run ```/usr/local/bin/restart_masternodes.sh``` to activate the services permanently.
   Individual masternode data directories are located in ```/var/lib/pivx${NUMBER_OF_NODE}```

**4)** subsequently, you should only work as user and not ```root```. The default user acc is ```pivxd```.
   Change to this user with the command "su masternode" (loged in as root)

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
