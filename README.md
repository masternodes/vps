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
| PURE |  ![PURE](/assets/pure.jpg){:class="img-responsive" width="64px"}  | https://github.com/puredev321/pure    |
| ENT  |  ![ENT](/assets/ent.jpg){:class="img-responsive" width="64px"}  | http://ent.eternity-group.org/    |
| SYNX |  ![SYNX](/assets/synx.jpg){:class="img-responsive" width="64px"}  | http://syndicatelabs.io/  |
| CHC |  ![CHAIN](/assets/chain.jpg){:class="img-responsive" width="64px"}  | https://www.chaincoin.org/  |
| ZEN |  ![ZEN](/assets/zen.jpg){:class="img-responsive" width="64px"}  | https://zensystem.io/  |
| DP |  ![DPRICE](/assets/dprice.jpg){:class="img-responsive" width="64px"}  | http://digitalprice.org/  |
| VIVO |  ![VIVO](/assets/vivo.jpg){:class="img-responsive" width="64px"}  | https://www.vivocrypto.com/  |
| ITZ |  ![ITZ](/assets/itz.jpg){:class="img-responsive" width="64px"}  | https://interzone.space/  |
| MEME |  ![MEME](/assets/meme.jpg){:class="img-responsive" width="64px"}  | http://www.memetic.ai/  |
| ARC |  ![ARC](/assets/arc.jpg){:class="img-responsive" width="64px"}  | https://arcticcoin.org/  |
| CRAVE |  ![CRAVE](/assets/crave.jpg){:class="img-responsive" width="64px"}  | https://www.craveproject.com/  |
| PIE |  ![PIE](/assets/pie.jpg){:class="img-responsive" width="64px"}  | https://github.com/flintsoft/PIE  |
| XCXT |  ![XCXT](/assets/xcxt.jpg){:class="img-responsive" width="64px"}  | http://coinonatx.com/  |
| SCORE |  ![SCORE](/assets/score.jpg){:class="img-responsive" width="64px"}  | http://scorecoin.site/ |
| BITSEND |  ![BITSEND](/assets/bitsend.jpg){:class="img-responsive" width="64px"}  | https://bitsend.info/ |
| XZC |  ![ZCOIN](/assets/zcoin.jpg){:class="img-responsive" width="64px"}  | https://zcoin.io/ |
| INSANE |  ![INSN](/assets/insane.jpg){:class="img-responsive" width="64px"}  | https://insanecoin.com/ |
| XIOS | ![XIOS](/assets/xios.jpg){:class="img-responsive" width="64px"}  | https://bitcointalk.org/index.php?topic=2251159.0/ |

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