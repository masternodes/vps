# Slick masternode VPS setup for all your beloved crypto masternodes

I am quite confident this is the single best and almost effortless way to setup different crypto masternodes, without bothering too much about the setup part. Vultr is highly recommended for this kind of setup.

Feel free to use my reflink [http://www.vultr.com/?ref=6929414-3B.](http://www.vultr.com/?ref=6929414-3B)

## Intro

This project started as handy bash script to setup my $PIVX masternodes in 2016 when there was almost zero documentation and anything that existed was either $DASH specific, sucked and in most cases both. For that reason, i started to work on a not-so-sucking way to install a lot of different masternodes with next to none manual intervention.

If you are not already aware, visit the project site and join the slack. The website at [https://pivx.org/](https://pivx.org/) is also well worth a visit. 

![][1]

[1]: images/masternode_vps/intro.png

## Get a VPS system for your masternode(s)

I will use vultr for my instructions, but in practice and with a bit of tuning any hoster that gives you multiple free IPv6 addresses. Register / login with vultr. Feel free to use my reflink [http://www.vultr.com/?ref=6929414-3B.](http://www.vultr.com/?ref=6929414-3B.) It's also great that you can use Bitcoin to pay!

![][2]

[2]: images/masternode_vps/get-a-vps-system-for-your-masternode-s-.png

## Deploy a new system

First, create a new VPS by clicking that small "+" button.

![][3]

[3]: images/masternode_vps/deploy-a-new-system.png

## Location choice

The location doesn't matter too much. If in doubt, choose a location next to you.

![][4]

[4]: images/masternode_vps/location-choice.png

## Linux distribution (Ubuntu 16.04 LTS)

Select Ubuntu 16.04, i am mostly testing for that version.

![][5]

[5]: images/masternode_vps/linux-distribution--ubuntu-1604-lts-.png

## VPS size

A decent masternode needs a bit of RAM and some storage space. The $5 instance is good enough for up to 5 masternodes. I recommend not running more than 3 production masternodes in parallel, since block rewards suffer from instability (eg when your nodes go down every couple of hours).

![][6]

[6]: images/masternode_vps/vps-size.png

## Activating additional features (IPv6)

Multiple masternodes on one VPS require multiple IPv6 addresses. Toggle "Enable IPv6" to activate that feature for free (Vultr).

![][7]

[7]: images/masternode_vps/activating-additional-features--ipv6-.png

## Hostnames & number of VPS

Choose how many instances you want and click "Deploy Now".

![][8]

[8]: images/masternode_vps/hostnames--amp--number-of-vps.png

## Accessing your VPS via SSH

Copy access credentials for SSH access by opening the server details.

![][9]

[9]: images/masternode_vps/accessing-your-vps-via-ssh.png

## First SSH session

Login to your newly installed node as "root".

![][10]

[10]: images/masternode_vps/first-ssh-session.png

## Masternode script installation

Follow the instructions at [https://github.com/marsmensch/masternode-vps-setup.](https://github.com/marsmensch/masternode-vps-setup.)

Clone the git repository first:

     git clone [https://github.com/marsmensch/masternode-vps-setup.git](https://github.com/marsmensch/masternode-vps-setup.git)



## Install the desired masternode and amount

Use the *runme.sh* script with the desired crypto and masternode count as parameters, e.g. to install 3 PURE masternodes:

     ./runme.sh pure 3

The script downloads, compiles and configures the system now. This will usually take between 5-15 minutes.

![][11]

[11]: images/masternode_vps/install-the-desired-masternode-and-amount.png

## End of installation

The script will output lots of boring stuff and it's ascii banner when done. Your only real work begins now.

![][12]

[12]: images/masternode_vps/end-of-installation.png

## Masternode configuration files

The generated configuration files are located at /etc/masternodes/. One file per masternode and crypto.

![][13]

[13]: images/masternode_vps/masternode-configuration-files.png

## Insert your masternode private key

In 99% you can use the generated settings as is. The only value you MUST change is the masternode private key, generated in your controller wallet.

![][14]

[14]: images/masternode_vps/insert-your-masternode-private-key.png

## Start your new masternodes

A script to enable masternode start at boot and local process monitoring has been created at */usr/local/bin/restart_maternodes.sh* for your convenience. Run it after you finished configuration.

     /usr/local/bin/restart_masternodes.sh

## Last step, the controller

To activate the new nodes in your _local_ (not the VPS) controller wallet, add the bind address entries with port to a file called "masternode.conf" as usual.

     MN1 [2002:470:1111:1a4:51]:51472 KEY TX OUTPUT
     MN2 [2003:470:1111:1a4:52]:51472 KEY TX OUTPUT
     MN3 [2003:470:1111:1a4:53]:51472 KEY TX OUTPUT

Ping me at[contact@marsmenschen.com](mailto:contact@marsmenschen.com)for questions and send some crypto my way if you are happy.

**Have fun, this is crypto after all!**

     BTC  33ENWZ9RCYBG7nv6ac8KxBUSuQX64Hx3x3