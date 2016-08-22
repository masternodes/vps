# Intro

Here it is: dont be rude please, i write this mostly during my lunch break today to safe some time during the next couple of setups.

# Notes and features
* it is currently only tested on a vultr VPS and Ubuntu 16.04 (smallest instance is good for up to 8 nodes)
* porting to 14.04 is probably not too hard, but no priority for me
* this script doesnt care about the controller side of things
* installs 1-100 (or more!) masternodes in parallel on one machine, with individual config and data
* compilation is currently from source, ubuntu packages on the way
* some security hardening is done, including firewalling and a separate user
* automatic startup for all masternode daemons
* ipv6 enabled, tor/onion will follow
* this script needs to run as root, the masternodes will and should not!

# What do i need to do after running this script?
**0)** Download and tun this script on your VPS instance

**1)** change the amount of masternodes you want to install/configure at the top of the script ("eg SETUP_MNODES_COUNT=3")

**2)** Add your masternode private key to the configuration file(s) located at ```/etc/masternodes/...```
For example, when installing three DNET masternodes:
```
* writing config file /etc/masternodes/darknet_n1.conf
* writing config file /etc/masternodes/darknet_n2.conf
* writing config file /etc/masternodes/darknet_n3.conf
```

**3)** run ```/usr/local/bin/restart_masternodes.sh``` to activate the services permanently.
   Individual masternode data directories are located in ```/var/lib/darknet/darknet${NUMBER_OF_NODE}```

**4)** subsequently, you should only work as user and not ```root```. The default user acc is ```masternode```.
   Change to this user with the command "su masternode" (loged in as root)

# Todo
* document the vultr signup and setup procedure
* provide a delete / uninstall flag
* create a logfile
* instert coin images into readme
* insert vultr signup reflink
* outsource common variables in commin source file

# Errors
* currently not fully idempotent (cfengine?)
* check if relevant interface already exists (sed) before writing to interfaces file


Ping me at contact@marsmenschen.com for questions and send some crypto my way if you are happy.

**Have fun, this is crypto after all!**
```
BTC  1PboFDkBsW2i968UnehWwcSrM9Djq5LcLB
DNET DBGBYLz484dWBb5wtk5gFVdJ8rGFfcob7R
SYNX SSKYwMhQQt9DcWozt7zA1tR3DmRuw1gT6b
DASH Xt1W8cVPxnx9xVmfe1yYM9e5DKumPQHaV5
MUE  7KV3NUX4g7rgEDHVfBttRWcxk3hrqGR4pH
MOJO MTfuWof2NMDPh57U18yniVzpaS2cq4nFFt
```
