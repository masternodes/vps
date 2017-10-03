# Intro
A not-so-sucking way to install a lot of different masternodes. 

I am quite confident this is the single best and almost effortless way to setup different crypto masternodes, without bothering too much about the setup part. Vultr is highly recommended for this kind of setup.

Feel free to use my reflink http://www.vultr.com/?ref=6929414-3B.

<img src="https://github.com/marsmensch/masternode-vps-setup/blob/templates/images/collage.png" width="1024">

Ping me at contact@marsmenschen.com for questions and send some crypto my way if you are happy. 

**Have fun, this is crypto after all!**
```
BTC  33ENWZ9RCYBG7nv6ac8KxBUSuQX64Hx3x3
```

# Notes and features
* It is currently only tested on a vultr VPS but should work almost anywhere where IPv6 addresses are available
* Developed with recent Ubuntu versions in mind, including 14.04/15.10/16.04/16.10
* This script doesn't care about the controller wallet side of things
* Installs 1-100 (or more!) masternodes in parallel on one machine, with individual config and data
* Compilation is currently from source for the desired git repo tag (configurable via config files)
* Some security hardening is done, including firewalling and a separate user
* Automatic startup for all masternode daemons
* It's ipv6 enabled, tor/onion will follow
* This script needs to run as root, the masternodes will and should not!

# What do i need to do after running this script?
**0)** Clone this repository
```
git clone https://github.com/marsmensch/masternode-vps-setup.git
```

**1)** run the **runme.sh** script with the desired crypto and masternode count as parameters, e.g. to install 3 PURE masternodes:

```
./runme.sh pure 3
```


**2)** ADD your masternode private key to the configuration file(s) located at ```/etc/masternodes/$CRYPTO_n$NUM.conf```. 

For example, when installing three PURE masternodes are desired, the following configuration files are generated:
```
* writing config file /etc/masternodes/pure_n1.conf
* writing config file /etc/masternodes/pure_n2.conf
* writing config file /etc/masternodes/pure_n3.conf
```

**3)** Still AS ROOT run ```/usr/local/bin/restart_masternodes.sh``` to activate the services permanently.
   Individual masternode data directories are located in ```/var/lib/masternodes/${CRYPTO}${NUMBER_OF_NODE}```

**4)** subsequently, you should only work as masternode user and not ```root```. The default user account created is ```masternode```.
   You can change to this user with the following command
```
vps:~ su - masternode
```   

**Supported cryptos:**

| CRYPTO  | Logo | Url |
|--------|--------------|-----|
| PIVX |  <img src="https://github.com/marsmensch/masternode-vps-setup/blob/templates/images/pivx.png" width="64">  |  https://pivx.org/ |
| DASH |  <img src="https://github.com/marsmensch/masternode-vps-setup/blob/templates/images/dash.png" width="64">  | https://www.dash.org/ |
| DESIRE |  <img src="https://github.com/marsmensch/masternode-vps-setup/blob/templates/images/desire.png" width="64">  | https://github.com/lazyboozer/Desire  |
| PURE |  <img src="https://github.com/marsmensch/masternode-vps-setup/blob/templates/images/pure.png" width="64">  | https://github.com/puredev321/pure    |
| ENT  |  <img src="https://github.com/marsmensch/masternode-vps-setup/blob/templates/images/ent.png" width="64">  | http://ent.eternity-group.org/    |
| SYNX |  <img src="https://github.com/marsmensch/masternode-vps-setup/blob/templates/images/synx.png" width="64">  | http://syndicatelabs.io/  |
| CHC |  <img src="https://github.com/marsmensch/masternode-vps-setup/blob/templates/images/chain.png" width="64">  | https://www.chaincoin.org/  |
| ZEN |  <img src="https://github.com/marsmensch/masternode-vps-setup/blob/templates/images/zen.png" width="64">  | https://zensystem.io/  |
| DP |  <img src="https://github.com/marsmensch/masternode-vps-setup/blob/templates/images/dprice.png" width="64">  | http://digitalprice.org/  |
| VIVO |  <img src="https://github.com/marsmensch/masternode-vps-setup/blob/templates/images/vivo.png" width="64">  | https://www.vivocrypto.com/  |
| ITZ |  <img src="https://github.com/marsmensch/masternode-vps-setup/blob/templates/images/itz.jpg" width="64">  | https://interzone.space/  |
| MEME |  <img src="https://github.com/marsmensch/masternode-vps-setup/blob/templates/images/meme.png" width="64">  | http://www.memetic.ai/  |
| ARC |  <img src="https://github.com/marsmensch/masternode-vps-setup/blob/templates/images/arc.png" width="64">  | https://arcticcoin.org/  |
| CRAVE |  <img src="https://github.com/marsmensch/masternode-vps-setup/blob/templates/images/crave.png" width="64">  | https://www.craveproject.com/  |

# Todo
* rewrite for config templates and provide my Dockerfile & Vagrantfile
* document the vultr signup and setup procedure
* provide a delete / uninstall flag
* create a logfile
* instert coin images into readme
* insert vultr signup reflink
* make scripts idempotent 
* write test cases
* implement a binary option (?) 
* outsource common variables in commin source file
* check if masternode user already exists before creation
* add all flags everywhere ./configure --disable-dependency-tracking --enable-tests=no --without-gui --without-miniupnpc --with-incompatible-bdb CFLAGS="-march=native" LIBS="-lcurl -lssl -lcrypto -lz"

# Errors
* currently not fully idempotent
* check if relevant interface already exists (sed) before writing to interfaces file

Ping me at contact@marsmenschen.com for questions and send some crypto my way if you are happy.

**Have fun, this is crypto after all!**
```
BTC  33ENWZ9RCYBG7nv6ac8KxBUSuQX64Hx3x3
```