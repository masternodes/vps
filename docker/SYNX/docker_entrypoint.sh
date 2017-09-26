#!/bin/bash

set -exuo pipefail

NODE_DIR=/node
NODE_CONF=${NODE_DIR}/node.conf

# If config doesn't exist, initialize with sane defaults for running a 
# non-mining node.

if [ ! -e "${NODE_CONF}" ]; then
  cat >${NODE_CONF} <<EOF

server=1
rpcuser=${BTC_RPCUSER:-btc}
rpcpassword=${BTC_RPCPASSWORD:-ch983754jhsdnfndsf,eplz}
rpcclienttimeout=${BTC_RPCCLIENTTIMEOUT:-30}
rpcallowip=${BTC_RPCALLOWIP:-::/0}
rpcport=${BTC_RPCPORT:-8332}
printtoconsole=${BTC_PRINTTOCONSOLE:-1}

EOF
fi

if [ $# -eq 0 ]; then
  exec bitcoind -datadir=${NODE_DIR} -conf=${NODE_CONF} "$@"
else
  exec "$@"
fi