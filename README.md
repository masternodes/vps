# Intro
A not-so-sucking way to install a lot of different masternodes. 

I am quite confident this is the single best and almost effortless way to setup different crypto masternodes, without bothering too much about the setup part. Vultr is highly recommended for this kind of setup, i even created an [easy step-by-step guide for this provider](https://github.com/marsmensch/masternode-vps-setup/blob/templates/docs/masternode_vps.md).

Feel free to use my reflink to signup and receive a bonus w/ vultr: <a href="https://www.vultr.com/?ref=6903922"><img src="https://www.vultr.com/media/banner_2.png" width="468" height="60"></a>

Thank you!

<img src="https://github.com/marsmensch/masternode-vps-setup/blob/templates/images/collage.jpg" width="1024">

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
cd masternode-vps-setup
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
| PIVX |  ![PIVX](/assets/pivx.jpg){:class="img-responsive" width="64px"}  |  https://pivx.org/ |
| DASH |  ![DASH](/assets/dash.jpg){:class="img-responsive" width="64px"}  | https://www.dash.org/ |
| DESIRE |  ![DESIRE](/assets/desire.jpg){:class="img-responsive" width="64px"}  | https://github.com/lazyboozer/Desire  |
| PURE |  <img src="https://github.com/marsmensch/masternode-vps-setup/blob/templates/images/pure.jpg" width="64">  | https://github.com/puredev321/pure    |
| ENT  |  <img src="https://github.com/marsmensch/masternode-vps-setup/blob/templates/images/ent.jpg" width="64">  | http://ent.eternity-group.org/    |
| SYNX |  <img src="https://github.com/marsmensch/masternode-vps-setup/blob/templates/images/synx.jpg" width="64">  | http://syndicatelabs.io/  |
| CHC |  <img src="https://github.com/marsmensch/masternode-vps-setup/blob/templates/images/chain.jpg" width="64">  | https://www.chaincoin.org/  |
| ZEN |  <img src="https://github.com/marsmensch/masternode-vps-setup/blob/templates/images/zen.jpg" width="64">  | https://zensystem.io/  |
| DP |  <img src="https://github.com/marsmensch/masternode-vps-setup/blob/templates/images/dprice.jpg" width="64">  | http://digitalprice.org/  |
| VIVO |  <img src="https://github.com/marsmensch/masternode-vps-setup/blob/templates/images/vivo.jpg" width="64">  | https://www.vivocrypto.com/  |
| ITZ |  <img src="https://github.com/marsmensch/masternode-vps-setup/blob/templates/images/itz.jpg" width="64">  | https://interzone.space/  |
| MEME |  <img src="https://github.com/marsmensch/masternode-vps-setup/blob/templates/images/meme.jpg" width="64">  | http://www.memetic.ai/  |
| ARC |  <img src="https://github.com/marsmensch/masternode-vps-setup/blob/templates/images/arc.jpg" width="64">  | https://arcticcoin.org/  |
| CRAVE |  <img src="https://github.com/marsmensch/masternode-vps-setup/blob/templates/images/crave.jpg" width="64">  | https://www.craveproject.com/  |
| PIE |  <img src="https://github.com/marsmensch/masternode-vps-setup/blob/templates/images/pie.jpg" width="64">  | https://github.com/flintsoft/PIE  |
| XCXT |  <img src="https://github.com/marsmensch/masternode-vps-setup/blob/templates/images/xcxt.jpg" width="64">  | http://coinonatx.com/  |
| SCORE |  <img src="https://github.com/marsmensch/masternode-vps-setup/blob/templates/images/score.jpg" width="64">  | http://scorecoin.site/ |
| BITSEND |  <img src="https://github.com/marsmensch/masternode-vps-setup/blob/templates/images/bitsend.jpg" width="64">  | https://bitsend.info/ |
| XZC |  <img src="https://github.com/marsmensch/masternode-vps-setup/blob/templates/images/zcoin.jpg" width="64">  | https://zcoin.io/ |
| INSANE |  <img src="https://github.com/marsmensch/masternode-vps-setup/blob/templates/images/insane.jpg" width="64">  | https://insanecoin.com/ |
| XIOS |  <img src="https://github.com/marsmensch/masternode-vps-setup/blob/templates/images/xios.jpg" width="64">  | https://bitcointalk.org/index.php?topic=2251159.0/ |

# Todo
* rewrite for config templates and provide my Dockerfile & Vagrantfile
* provide a delete / uninstall flag
* create a logfile
* make scripts idempotent 
* write test cases
* implement a binary option (?) 
* check if masternode user already exists before creation
* output masternode.conf template for controller wallet at the end of setup
* output all supported cryptos as list within help

# Errors
* currently not fully idempotent
* check if relevant interface already exists (sed) before writing to interfaces file

Ping me at contact@marsmenschen.com for questions and send some crypto my way if you are happy.

**Have fun, this is crypto after all!**
```
BTC  33ENWZ9RCYBG7nv6ac8KxBUSuQX64Hx3x3
```