## How To Use new features
- Add Generation masternode private key feature
- Add masternode private key preinputed feature

It means you don't need to configure phore_n*.conf on VPS anymore.

## How To use generation feature
1. Enter this command
```bash
git clone https://github.com/phoreproject/vps.git && cd vps && ./install.sh -p phore -g
```

2. Wait the script sets up your masternode.

3. Let's start your masternode client. Enter this command
```
activate_masternodes_phore
```
The masternode daemons will start and begin loading the Phore Blockchain.

4. You need to check masternode.conf in VPS. Enter this command
```
cat /tmp/phore_masternode.conf
```

It will show like this.
<img src="docs/images/masternode_vps/conf.png" alt="VPS configuration" class="inline"/>

Please copy that and paste it to your masternode.conf in local.
After this, you need to start from Step 1.
But You already generate private key, so you can skip step 2.

## How To use preinputed feature
1. Start From Step 1
2. After Step 3, Enter this command on VPS
```bash
git clone https://github.com/phoreproject/vps.git && cd vps && ./install.sh -p phore --key **GENERATED PRIVATE KEY**
```

2. Wait the script sets up your masternode.

3. Let's start your masternode client. Enter this command
```
activate_masternodes_phore
```
The masternode daemons will start and begin loading the Phore Blockchain.

