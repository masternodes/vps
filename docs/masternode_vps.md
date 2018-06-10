# Slick masternode VPS setup for all your beloved crypto masternodes (Vultr example)


---
**PLEASE ALSO READ THE README**

Please also see the [README for this project](../README.md) that will give you a high-level overview of features. 

---

## Get a VPS system for your masternode(s)

I will use vultr for my instructions, but in practice and with a bit of tuning any hoster that gives you multiple free IPv6 addresses. Register / login with vultr.

Feel free to use my reflink to signup and receive a bonus w/ vultr:
<a href="https://www.vultr.com/?ref=7434970"><img src="https://www.vultr.com/media/banner_2.png" width="468" height="60"></a>

It's also great that you can use Bitcoin to pay!

<img src="images/masternode_vps/get-a-vps-system-for-your-masternode-s-.png" alt="VPS signup" class="inline"/>

## Deploy a new system

First, create a new VPS by clicking that small "+" button.

<img src="images/masternode_vps/deploy-a-new-system.png" alt="VPS creation" class="inline"/>

## Location choice

The location doesn't matter too much. If in doubt, choose a location next to you.

<img src="images/masternode_vps/location-choice.png" alt="VPS location choice" class="inline"/>

## Linux distribution (Ubuntu 16.04 LTS)

Select Ubuntu 16.04, i am mostly testing for that version.

<img src="images/masternode_vps/linux-distribution--ubuntu-1604-lts-.png" alt="VPS location choice" class="inline"/>

## VPS size

A decent masternode needs a bit of RAM and some storage space. The $5 instance is good enough for up to 5 masternodes. I recommend not running more than 3 production masternodes in parallel, since block rewards suffer from instability (eg when your nodes go down every couple of hours).

<img src="images/masternode_vps/vps-size.png" alt="VPS sizing" class="inline"/>

## Activating additional features (IPv6)

Multiple masternodes on one VPS require multiple IPv6 addresses. Toggle "Enable IPv6" to activate that feature for free (Vultr).

<img src="images/masternode_vps/activating-additional-features--ipv6-.png" alt="VPS sizing" class="inline"/>


## Hostnames & number of VPS

Choose how many instances you want and click "Deploy Now".

<img src="images/masternode_vps/hostnames--amp--number-of-vps.png" alt="VPS sizing" class="inline"/>

## Accessing your VPS via SSH

Copy access credentials for SSH access by opening the server details.

<img src="images/masternode_vps/accessing-your-vps-via-ssh.png" alt="VPS sizing" class="inline"/>

## First SSH session

Login to your newly installed node as "root".

<img src="images/masternode_vps/first-ssh-session.png" alt="VPS sizing" class="inline"/>

## Masternode script installation

Clone this git repository first:

```
git clone https://github.com/DRIP-Project/vps.git && cd vps
```


## Install the desired masternode and amount

Use the *./install.sh* script with the desired crypto and masternode count as parameters, e.g. to install 4 DRIP masternodes:

```
./install.sh -p drip -c 4
```

The script downloads, compiles and configures the system now. This will usually take between 10-15 minutes.

<img src="images/masternode_vps/install-the-desired-masternode-and-amount.png" alt="VPS sizing" class="inline"/>

The *./install.sh* script outputs a list of possible parameters if executed without options.

## End of installation

The script will output lots of boring stuff and it's ascii banner when done. Your only real work begins now.

<img src="images/masternode_vps/end-of-installation.png" alt="VPS sizing" class="inline"/>


## Masternode configuration files

The generated configuration files are located at /etc/masternodes/. One file per masternode and crypto.

<img src="images/masternode_vps/masternode-configuration-files.png" alt="VPS sizing" class="inline"/>


## Insert your masternode private key

In 99% you can use the generated settings as is. The only value you MUST change is the masternode private key, generated in your controller wallet. Contact the individual crypto community if unsure, although the steps are identical for most master node coins. Check the [Dash documentation for example](https://dashpay.atlassian.net/wiki/spaces/DOC/pages/1867877/Start+multiple+masternodes+from+one+wallet+start-many).

<img src="images/masternode_vps/insert-your-masternode-private-key.png" alt="the master node private key" class="inline"/>


## Start your new masternodes

A script to enable masternode start at boot has been created at */usr/local/bin/activate_masternodes_${CODENAME}.sh* for your convenience. There is exactly one script per installed masternode crypto.

Run it after you finished configuration, e.g. after a DRIP installation do.

```
/usr/local/bin/activate_masternodes_drip
```     

## Last step, the controller

To activate the new nodes in your _local_ (not the VPS) controller wallet, add the bind address entries with port to a file called "masternode.conf" as usual.

     MN1 [2002:470:1111:1a4:51]:51472 KEY TX OUTPUT
     MN2 [2003:470:1111:1a4:52]:51472 KEY TX OUTPUT
     MN3 [2003:470:1111:1a4:53]:51472 KEY TX OUTPUT

To make this a bit easier for large installations, i implemented a small gimmick in the newest version. Now after the script has run, a partial of the "masternode.conf" file is generated and placed on the VPS eg for DRIP at "/tmp/drip_masternode.conf"

So you can take the contents from there and paste it into your local controller-wallets masternode.conf all that you need to add is the relevant pieces from "masternode outputs"

<img src="images/masternode_vps/controller_conf_partial.png" alt="controller conference generated partial" class="inline"/>

You get the idea, another step to a fully automated setup... ;-)

## Troubleshooting the masternode on the VPS

If you want to check the status of your masternode, the best way is currently running the cli e.g. via

```
/usr/local/bin/mue-cli -conf=/etc/masternodes/mue_n1.conf getinfo

{
  "version": 1000302,
  "protocolversion": 70701,
  "walletversion": 61000,
  "balance": 0.00000000,
  "privatesend_balance": 0.00000000,
  "blocks": 209481,
  "timeoffset": 0,
  "connections": 5,
  "proxy": "",
  "difficulty": 42882.54964804553,
  "testnet": false,
  "keypoololdest": 1511380627,
  "keypoolsize": 1001,
  "paytxfee": 0.00000000,
  "relayfee": 0.00010000,
  "errors": ""
}
```


# Issues and Questions

Join our Discord and post issues or questions to the masternodes channel: [https://discord.gg/n93p2BW](https://discord.gg/n93p2BW)

**Have fun, this is crypto after all!**
