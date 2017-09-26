#!/bin/sh
set -exuo pipefail

NODE_DIR=/node
NODE_CONF=${NODE_DIR}/node.conf

# If config doesn't exist, initialize with sane defaults for running a 
# non-mining node.

if [ ! -e "${NODE_CONF}" ]; then
  mkdir -p ${NODE_DIR}
  chmod 700 ${NODE_DIR}
  chown -R masternode ${NODE_DIR}
  cat >${NODE_CONF} <<EOF

server=1
rpcuser=${BTC_RPCUSER:-node}
rpcpassword=${BTC_RPCPASSWORD:-secret}
rpcclienttimeout=${BTC_RPCCLIENTTIMEOUT:-30}
printtoconsole=${BTC_PRINTTOCONSOLE:-1}

EOF
fi

echo "xx"
id
echo "xx"

if [ $# -eq 0 ]; then
  su-exec masternode /pivxd -datadir=${NODE_DIR} -conf=${NODE_CONF}
else
  su-exec masternode /pivxd -datadir=${NODE_DIR} -conf=${NODE_CONF}
fi