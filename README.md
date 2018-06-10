# Nodemaster

The **Nodemaster** scripts is a collection of utilities to manage, setup and update masternode instances.

I am quite confident this is the single best and almost effortless way to setup different crypto masternodes, without bothering too much about the setup part.

If this script helped you in any way, please contribute some feedback. BTC donations also welcome and never forget:

**Have fun, this is crypto after all!**

```
BTC  126W23rf63hMr58AP3Rs2N3qMprrepCcg8
```


Feel free to use my reflink to signup and receive a bonus w/ vultr:
<a href="https://www.vultr.com/?ref=7434970"><img src="https://www.vultr.com/media/banner_2.png" width="468" height="60"></a>

**NOTE on the VPS choice for starters**

**Vultr** is highly recommended for this kind of setup. I created an [easy step-by-step guide for the VPS provider vultr](/docs/masternode_vps.md) that will guide you through the hardest parts.

---

## Installation

SSH to your VPS and clone the Github repository:

```bash
git clone https://github.com/DRIP-Project/vps.git && cd vps
```

Install & configure your desired master node with options:

```bash
./install.sh -p drip
```

## Examples for typical script invocation

These are only a couple of examples for typical setups. Check my [easy step-by-step guide for [vultr](/docs/masternode_vps.md) that will guide you through the hardest parts.

**Install & configure 4 DRIP masternodes:**

```bash
./install.sh -p drip -c 4
```

**Update daemon of previously installed DRIP masternodes:**

```bash
./install.sh -p drip -u
```

**Install 6 DRIP masternodes with the git release tag "tags/v1.0.2.4"**

```bash
./install.sh -p drip -c 6 -r "tags/v1.0.2.4"
```

**Wipe all DRIP masternode data:**

```bash
./install.sh -p drip -w
```

**Install 2 DRIP masternodes and configure sentinel monitoring:**

```bash
./install.sh -p drip -c 2 -s
```

## Options

The _install.sh_ script support the following parameters:

| Long Option  | Short Option | Values              | description                                                         |
| :----------- | :----------- | ------------------- | ------------------------------------------------------------------- |
| --project    | -p           | project, e.g. "drp" | shortname for the project                                           |
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

Join our Discord and post issues or questions to the masternodes channel: [https://discord.gg/n93p2BW](https://discord.gg/n93p2BW).

**Have fun, this is crypto after all!**

```
BTC  126W23rf63hMr58AP3Rs2N3qMprrepCcg8
```

## Management script (not yet implemented)

The management script release will follow within the next couple of days.

| command                               | description                                  |
| :------------------------------------ | -------------------------------------------- |
| nodemaster start drip (all\|number)   | start all or a specific drip masternode(s)   |
| nodemaster restart drip (all\|number) | stop all or a specific drip masternode(s)    |
| nodemaster stop drip (all\|number)    | restart all or a specific drip masternode(s) |
| nodemaster cleanup drip (all\|number) | delete chain data for all drip masternodes   |
| nodemaster status drip (all\|number)  | systemd process status for a drip masternode |
| nodemaster tail drip (all\|number)    | tail debug logs for a drip masternode        |

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
BTC  126W23rf63hMr58AP3Rs2N3qMprrepCcg8
```
