# Masternode nodemaster script introduction

I am quite confident this is the single best and almost effortless way to setup different crypto masternodes, without bothering too much about the setup part.

Vultr is highly recommended for this kind of setup, i even created an [easy step-by-step guide for this provider [vultr](/docs/masternode_vps.md). 

Ping me at contact@marsmenschen.com for questions and send some crypto my way if you are happy.

**Have fun, this is crypto after all!**
```
BTC  33ENWZ9RCYBG7nv6ac8KxBUSuQX64Hx3x3
```

## Wait! What is this?

A not-so-sucking way to install a lot of different masternodes. 

## Which crypto projects are currently supported?

PIVX DASH DESIRE PURE ENT SYNX CHC ZEN DPRICE VIVO ITZ MEME ARC CRAVE PIE XCXT SCORE BITSEND XZC INSANE XIOS master nodes. More added as soon as i find the time.

## Can i see a demo?

Sure > INSERT DEMO VIDEO HERE <,here is a demo showing the script in action. After the installation, you have 2 instances of a $XIOS masternode.
A not-so-sucking way to install a lot of different masternodes. 

## Which VPS providers are currently supported?

Vultr is highly recommended for this kind of setup, i even created an [easy step-by-step guide for this provider [vultr](/docs/masternode_vps.md).  

Feel free to use my reflink to signup and receive a bonus w/ vultr: <a href="https://www.vultr.com/?ref=6903922"><img src="https://www.vultr.com/media/banner_2.png" width="468" height="60"></a>

Generally, you can use any provider. Vultr is the only provider i am testing for and you should know what you are doing when you use another provider.

![supported projects](/assets/collage.jpg)

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

## How do i install a XXX masternodes with this script?

### 1) SSH to your Linux VPS and clone this repository
You should be able to do that ;-) Install git if not already present.

```
vps:~ git clone https://github.com/masternodes/vps.git && cd vps
```

### 2) execute the **runme.sh** script

the **runme.sh** script takes the desired crypto and masternode count (optional) as parameters, e.g. to install 3 PURE masternodes:

```
vps:~ ./runme.sh pure 3
```

The script downloads, compiles and configures the system now. This will usually take between 5-15 minutes.

<img src="docs/images/masternode_vps/install-the-desired-masternode-and-amount.png" alt="crypto choice" class="inline"/>

The *runme.sh* script outputs an alphabetic list of supported crypto projects when executed without a parameter.

### 3) adapt the master node configuration files

ADD your masternode private key to the configuration file(s) located at ```/etc/masternodes/$CRYPTO_n$NUM.conf```. 

For example, when installing three PURE masternodes are desired, the following configuration files are generated:

```
* writing config file /etc/masternodes/pure_n1.conf
* writing config file /etc/masternodes/pure_n2.conf
* writing config file /etc/masternodes/pure_n3.conf
```

### 4) activate the master node system services

Still AS ROOT run ```/usr/local/bin/restart_masternodes.sh``` to activate the services permanently.

Individual masternode data directories are located in ```/var/lib/masternodes/${CRYPTO}${NUMBER_OF_NODE}```

## Last step, the controller

To activate the new nodes in your _local_ (not the VPS) controller wallet, add the bind address entries with port to a file called "masternode.conf" as usual.

     MN1 [2002:470:1111:1a4:51]:51472 KEY TX OUTPUT
     MN2 [2003:470:1111:1a4:52]:51472 KEY TX OUTPUT
     MN3 [2003:470:1111:1a4:53]:51472 KEY TX OUTPUT

To make this a bit easier for large installations, i implemented a small gimmick in the newest version. Now after the script has run, a partial of the "masternode.conf" file is generated and placed on the VPS eg for XIOS at "/tmp/xios_masternode.conf"

So you can take the contents from there and paste it into your local controller-wallets masternode.conf all that you need to add is the relevant pieces from "masternode outputs"

<img src="docs/images/masternode_vps/controller_conf_partial.png" alt="controller conference generated partial" class="inline"/>

You get the idea, another step to a fully automated setup... ;-)


# A dedicated unprivileged user for the masternodes

Subsequently, you should only work as masternode user and not ```root```. The default user account created is ```masternode```.

You can change to this user (as root since "root" can become any account) with the following command:

```
vps:~ su - masternode
```   

If you prefer, you can also set a password for that user with the following command:

```
vps:~ passwd masternode
```


# Supported cryptos

| CRYPTO  | Logo | Url |
|--------|--------------|-----|
| PIVX |  ![PIVX](/assets/pivx.jpg)  |  https://pivx.org/ |
| DASH |  ![DASH](/assets/dash.jpg)  | https://www.dash.org/ |
| DESIRE |  ![DESIRE](/assets/desire.jpg)  | https://github.com/lazyboozer/Desire  |
| PURE |  ![PURE](/assets/pure.jpg)  | https://github.com/puredev321/pure    |
| ENT  |  ![ENT](/assets/ent.jpg)  | http://ent.eternity-group.org/    |
| SYNX |  ![SYNX](/assets/synx.jpg)  | http://syndicatelabs.io/  |
| CHC |  ![CHAIN](/assets/chain.jpg)  | https://www.chaincoin.org/  |
| ZEN |  ![ZEN](/assets/zen.jpg)  | https://zensystem.io/  |
| DP |  ![DPRICE](/assets/dprice.jpg)  | http://digitalprice.org/  |
| VIVO |  ![VIVO](/assets/vivo.jpg)  | https://www.vivocrypto.com/  |
| ITZ |  ![ITZ](/assets/itz.jpg)  | https://interzone.space/  |
| MEME |  ![MEME](/assets/meme.jpg)  | http://www.memetic.ai/  |
| ARC |  ![ARC](/assets/arc.jpg)  | https://arcticcoin.org/  |
| CRAVE |  ![CRAVE](/assets/crave.jpg)  | https://www.craveproject.com/  |
| PIE |  ![PIE](/assets/pie.jpg)  | https://github.com/flintsoft/PIE  |
| XCXT |  ![XCXT](/assets/xcxt.jpg)  | http://coinonatx.com/  |
| SCORE |  ![SCORE](/assets/score.jpg)  | http://scorecoin.site/ |
| BITSEND |  ![BITSEND](/assets/bitsend.jpg)  | https://bitsend.info/ |
| XZC |  ![ZCOIN](/assets/zcoin.jpg)  | https://zcoin.io/ |
| INSANE |  ![INSN](/assets/insane.jpg)  | https://insanecoin.com/ |
| XIOS | ![XIOS](/assets/xios.jpg)  | https://bitcointalk.org/index.php?topic=2251159.0/ |

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