#!/bin/bash
echo "OUTPUT EVERYTHING FOR DEBUGGING"
echo "*******************************"
echo HOWMANY       ${SETUP_MNODES_COUNT}
echo IN_PORT       ${MNODE_INBOUND_PORT}
echo SSH_IN        ${SSH_INBOUND_PORT}
echo CONF_BASE     ${MNODE_CONF_BASE}
echo DATA_BASE     ${MNODE_DATA_BASE}
echo MNODE_USER    ${MNODE_USER}
echo HELPER        ${MNODE_HELPER}
echo DAEMON        ${MNODE_DAEMON}
echo SWAPSIZE      ${MNODE_SWAPSIZE}
echo GIT_PROJ      ${GIT_PROJECT}
echo URL           ${GIT_URL}
echo PROGVERS      ${PROG_VERSION}
echo SYSTEMD_CONF  ${SYSTEMD_CONF}
echo NETWORK_CONF  ${NETWORK_CONFIG}
echo ETH_INTERFACE ${ETH_INTERFACE}
echo "*******************************"