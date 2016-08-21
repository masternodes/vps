#!/bin/bash
#
#  ███╗   ██╗ ██████╗ ██████╗ ███████╗███╗   ███╗ █████╗ ███████╗████████╗███████╗██████╗ 
#  ████╗  ██║██╔═══██╗██╔══██╗██╔════╝████╗ ████║██╔══██╗██╔════╝╚══██╔══╝██╔════╝██╔══██╗
#  ██╔██╗ ██║██║   ██║██║  ██║█████╗  ██╔████╔██║███████║███████╗   ██║   █████╗  ██████╔╝
#  ██║╚██╗██║██║   ██║██║  ██║██╔══╝  ██║╚██╔╝██║██╔══██║╚════██║   ██║   ██╔══╝  ██╔══██╗
#  ██║ ╚████║╚██████╔╝██████╔╝███████╗██║ ╚═╝ ██║██║  ██║███████║   ██║   ███████╗██║  ██║
#  ╚═╝  ╚═══╝ ╚═════╝ ╚═════╝ ╚══════╝╚═╝     ╚═╝╚═╝  ╚═╝╚══════╝   ╚═╝   ╚══════╝╚═╝  ╚═╝
#                                                                   ╚╗ @marsmensch 2016 ╔╝                      
#
# version: 	0.3-alpha
# date:    	2016-08-20
# function:	part of the masternode scripts, source the proper config file
#
# Twitter: 	@marsmensch
#                                                                      
# 	Instructions:
#               Run this script and wait. After a while you should have a working
#               masternode setup where only the private keys need to be added.
#
#	Platforms: 	
#               - Linux Ubuntu 16.04 LTS ONLY on a Vultr VPS (its by far the cheapest option)
#               - Generic Ubuntu support will be added at a later point in time
#
#	System requirements:
#               - A vultr micro instance works for up to 5 masternodes 
#				- Activate the free IPv6 option
#
# tips
# BTC  1PboFDkBsW2i968UnehWwcSrM9Djq5LcLB
# DNET DBGBYLz484dWBb5wtk5gFVdJ8rGFfcob7R
# SYNX SSKYwMhQQt9DcWozt7zA1tR3DmRuw1gT6b
# DASH Xt1W8cVPxnx9xVmfe1yYM9e5DKumPQHaV5
# MUE  7KV3NUX4g7rgEDHVfBttRWcxk3hrqGR4pH
# MOJO MTfuWof2NMDPh57U18yniVzpaS2cq4nFFt

usage() {
    echo `basename $0`: ERROR: $* 1>&2
    echo usage: `basename $0` '[dnet] OR [mojo] OR [mue] OR [synx] OR [dash] + HOWMANY' 1>&2
    echo '=> for 5 dnet masternodes run:' `basename $0` 'dnet 5' 1>&2
    echo 'Report bugs to: @marsmensch'
    exit 1
}

source_config() {
	if [ -f ${SETUP_CONF_FILE} ]; then
		source "${SETUP_CONF_FILE}"
		echo "read config file for ${1}"
		source .scripts/masternode_install.sh ${1}
	else
		echo "required file ${SETUP_CONF_FILE} does not exist, abort!"
		exit 1   
	fi
}

SETUP_CONF_FILE=".config/${1}/${1}.env"
SETUP_MNODES_COUNT=${2}

case "${1}" in
	dnet)
		echo you picked DNET
		source_config dnet
		;;
	mojo)
		echo you picked MOJO
		source_config mojo
		;;
	mue)
		echo you picked MUE
		source_config mue
		;;
	synx)
		echo you picked SYNX
		source_config synx
		;;
	dash)
		echo you picked DASH
		source_config dash
		;;  
	* ) usage "bad argument $1"
		;;
esac