# Nodemaster

The **Nodemaster** scripts is a collection of utilities to manage, setup and update masternode instances.

I am quite confident this is the single best and almost effortless way to setup different crypto masternodes, without bothering too much about the setup part.

If this script helped you in any way, please contribute some feedback. BTC donations also welcome and never forget:

**Have fun, this is crypto after all!**

```
BTC  33ENWZ9RCYBG7nv6ac8KxBUSuQX64Hx3x3
```

Feel free to use my reflink to signup and receive a bonus w/ vultr:
<a href="https://www.vultr.com/?ref=6903922"><img src="https://www.vultr.com/media/banner_2.png" width="468" height="60"></a>

---

**NOTE on the VPS choice for starters**

**Vultr** is highly recommended for this kind of setup. I created an [easy step-by-step guide for the VPS provider vultr](/docs/masternode_vps.md) that will guide you through the hardest parts.

---

## About / Background

Many masternode crypto currencies only have incomplete or even non-existing instructions available how to setup a masternode from source.

This project started as handy bash script to setup my $PIVX masternodes in 2016 when there was almost zero documentation and anything that existed was either $DASH specific, sucked and in most cases both. For that reason, i started to work on a not-so-sucking way to install a lot of different masternodes with next to none manual intervention.

If you are not already aware, visit the project site and join the slack. The website at [https://pivx.org/](https://pivx.org/) is also well worth a visit.

Many people use binaries, end of with an insecure configuration or fail completely. This is obviously bad for the stability of the individual network.

After doing hundreds of masternode installations in the past two years, i decided to share some of my existing auto-install and management scripts with the community to work on a generalised & reliable setup for all masternode coins.

Comparing with building from source manually, you will benefit from using this script in the following way(s):

* 100% auto-compilation and 99% of configuration on the masternode side of things. It is currently only tested on a vultr VPS but should work almost anywhere where IPv6 addresses are available
* Developed with recent Ubuntu versions in mind, currently only 16.04 is supported
* Installs 1-100 (or more!) masternodes in parallel on one machine, with individual config and data
* Compilation is currently from source for the desired git repo tag (configurable via config files)
  Some security hardening is done, including firewalling and a separate user
* Automatic startup for all masternode daemons
* This script needs to run as root, the masternodes will and should not!
* It's ipv6 enabled, tor/onion will follow

## Installation

SSH to your VPS and clone the Github repository:

```bash
git clone https://github.com/masternodes/vps.git && cd vps
```

Install & configure your desired master node with options:

```bash
./install.sh -p pivx
```

## Examples for typical script invocation

These are only a couple of examples for typical setups. Check my [easy step-by-step guide for [vultr](/docs/masternode_vps.md) that will guide you through the hardest parts.

**Install & configure 4 PIVX masternodes:**

```bash
./install.sh -p pivx -c 4
```

**Install 4 PIVX masternodes, update daemon:**

```bash
./install.sh -p pivx -c 4 -u
```

**Install 6 PIVX masternodes with the git release tag "tags/v3.0.5.1"**

```bash
./install.sh -p pivx -c 6 -r "tags/v3.0.5.1"
```

**Wipe all PIVX masternode data:**

```bash
./install.sh -p pivx -w
```

**Install 2 PIVX masternodes and configure sentinel monitoring:**

```bash
./install.sh -p pivx -c 2 -s
```

## Options

The _install.sh_ script support the following parameters:

| Long Option  | Short Option | Values              | description                                                         |
| :----------- | :----------- | ------------------- | ------------------------------------------------------------------- |
| --project    | -p           | project, e.g. "pix" | shortname for the project                                           |
| --net        | -n           | "4" / "6"           | ip type for masternode. (ipv)6 is default                           |
| --release    | -r           | e.g. "tags/v3.0.4"  | a specific git tag/branch, defaults to latest tested                |
| --count      | -c           | number              | amount of masternodes to be configured                              |
| --update     | -u           | --                  | update specified masternode daemon, combine with -p flag            |
| --sentinel   | -s           | --                  | install and configure sentinel for node monitoring                  |
| --wipe       | -w           | --                  | uninstall & wipe all related master node data, combine with -p flag |
| --help       | -h           | --                  | print help info                                                     |
| --startnodes | -x           | --                  | starts masternode(s) after installation                             |

## Troubleshooting the masternode on the VPS

If you want to check the status of your masternode, the best way is currently running the cli e.g. for $MUE via

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

# Help, Issues and Questions

I activated the "[issues](https://github.com/masternodes/vps/issues)" option on github to give you a way to document defects and feature wishes. Feel free top [open issues](https://github.com/masternodes/vps/issues) for problems / features you are missing here: [https://github.com/masternodes/vps/issues](https://github.com/masternodes/vps/issues).

I might not be able to reply immediately, but i do usually within a couple of days at worst. I will also happily take any pull requests that make masternode installations easier for everyone ;-)

If this script helped you in any way, please contribute some feedback. BTC donations also welcome and never forget:

**Have fun, this is crypto after all!**

```
BTC  33ENWZ9RCYBG7nv6ac8KxBUSuQX64Hx3x3
```

## Management script (not yet implemented)

The management script release will follow within the next couple of days.

| command                               | description                                  |
| :------------------------------------ | -------------------------------------------- |
| nodemaster start pivx (all\|number)   | start all or a specific pivx masternode(s)   |
| nodemaster restart pivx (all\|number) | stop all or a specific pivx masternode(s)    |
| nodemaster stop pivx (all\|number)    | restart all or a specific pivx masternode(s) |
| nodemaster cleanup pivx (all\|number) | delete chain data for all pivx masternodes   |
| nodemaster status pivx (all\|number)  | systemd process status for a pivx masternode |
| nodemaster tail pivx (all\|number)    | tail debug logs for a pivx masternode        |

# Supported cryptos

| CRYPTO   | Logo                              | Url                                                                      |
| -------- | --------------------------------- | ------------------------------------------------------------------------ |
| PIVX     | ![PIVX](/assets/pivx.jpg)         | https://pivx.org/                                                        |
| DASH     | ![DASH](/assets/dash.jpg)         | https://www.dash.org/                                                    |
| DESIRE   | ![DESIRE](/assets/desire.jpg)     | https://github.com/lazyboozer/Desire                                     |
| PURE     | ![PURE](/assets/pure.jpg)         | https://github.com/puredev321/pure                                       |
| ENT      | ![ENT](/assets/ent.jpg)           | http://ent.eternity-group.org/                                           |
| SYNX     | ![SYNX](/assets/synx.jpg)         | http://syndicatelabs.io/                                                 |
| CHC      | ![CHAIN](/assets/chain.jpg)       | https://www.chaincoin.org/                                               |
| ZEN      | ![ZEN](/assets/zen.jpg)           | https://zensystem.io/                                                    |
| DP       | ![DPRICE](/assets/dprice.jpg)     | http://digitalprice.org/                                                 |
| VIVO     | ![VIVO](/assets/vivo.jpg)         | https://www.vivocrypto.com/                                              |
| ITZ      | ![ITZ](/assets/itz.jpg)           | https://interzone.space/                                                 |
| MEME     | ![MEME](/assets/meme.jpg)         | http://www.memetic.ai/                                                   |
| ARC      | ![ARC](/assets/arc.jpg)           | https://arcticcoin.org/                                                  |
| CRAVE    | ![CRAVE](/assets/crave.jpg)       | https://www.craveproject.com/                                            |
| PIE      | ![PIE](/assets/pie.jpg)           | https://github.com/flintsoft/PIE                                         |
| XCXT     | ![XCXT](/assets/xcxt.jpg)         | http://coinonatx.com/                                                    |
| SCORE    | ![SCORE](/assets/score.jpg)       | http://scorecoin.site/                                                   |
| BITSEND  | ![BITSEND](/assets/bitsend.jpg)   | https://bitsend.info/                                                    |
| XZC      | ![ZCOIN](/assets/zcoin.jpg)       | https://zcoin.io/                                                        |
| INSANE   | ![INSN](/assets/insane.jpg)       | https://insanecoin.com/                                                  |
| XIOS     | ![XIOS](/assets/xios.jpg)         | https://bitcointalk.org/index.php?topic=2251159.0/                       |
| HAV      | ![HAV](/assets/have.jpg)          | https://bitcointalk.org/index.php?topic=2336026.0                        |
| NTRN     | ![NTRN](/assets/ntrn.jpg)         | https://www.neutroncoin.com/                                             |
| RNS      | ![RNS](/assets/rns.jpg)           | https://bitcointalk.org/index.php?topic=1809933.msg18029683#msg18029683/ |
| SOLARIS  | ![SOLARIS](/assets/solaris.jpg)   | http://www.solariscoin.com/                                              |
| BTDX     | ![BTDX](/assets/btdx.jpg)         | https://bit-cloud.info/                                                  |
| INNOVA   | ![INNOVA](/assets/innova.jpg)     | http://innovacoin.info/                                                  |
| FORCE    | ![FORCE](/assets/force.jpg)       | https://bitcointalk.org/index.php?topic=2359378                          |
| BITRADIO | ![BITRADIO](/assets/bitradio.jpg) | https://bitrad.io/                                                       |
| MONA     | ![MONA](/assets/mona.jpg)         | https://monacocoin.net/                                                  |
| ALQO     | ![ALQO](/assets/alqo.jpg)         | https://alqo.org                                                         |
| YUP      | ![YUP](/assets/yup.jpg)           | http://yupcrypto.com/                                                    |
| MTNC     | ![MTNC](/assets/mtnc.jpg)         | http://www.masternodecoin.org/                                           |
| CROWN    | ![CROWN](/assets/crown.jpg)       | https://crown.tech/                                                      |
| BLOCKNET | ![BLOCK](/assets/block.jpg)       | https://blocknet.co/                                                     |
| DTMI     | ![DTMI](/assets/dtmi.jpg)         | https://bitcointalk.org/index.php?topic=2325196.0                        |
| MAGNA    | ![MAGNA](/assets/magna.jpg)       | https://www.magnacoin.org/                                               |
| CROWD    | ![CROWD](/assets/crowd.jpg)       | http://crowdcoin.site/                                                   |
| NUMUS    | ![NUMUS](/assets/numus.jpg)       | http://numus.cash/                                                       |
| NODE     | ![NODE](/assets/node.jpg)         | https://bitnodes.co/                                                     |
| SUB1X    | ![SUB1X](/assets/sub1x.jpg)       | https://bitcointalk.org/index.php?topic=2282282.0                        |
| SEND     | ![SEND](/assets/send.jpg)         | https://socialsend.io/                                                   |
| CREAM    | ![CREAM](/assets/cream.jpg)       | http://cream.technology/                                                 |

# Todo

* provide my Dockerfile & Vagrantfile
* write more test cases
* implement a binary option (?)
* output all supported cryptos as list within help

# Errors

* currently not fully idempotent

Ping me at contact@marsmenschen.com for questions and send some crypto my way if you are happy.

**Have fun, this is crypto after all!**

```
BTC  33ENWZ9RCYBG7nv6ac8KxBUSuQX64Hx3x3
```
