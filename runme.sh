#!/bin/bash
#  ███╗   ██╗ ██████╗ ██████╗ ███████╗███╗   ███╗ █████╗ ███████╗████████╗███████╗██████╗ 
#  ████╗  ██║██╔═══██╗██╔══██╗██╔════╝████╗ ████║██╔══██╗██╔════╝╚══██╔══╝██╔════╝██╔══██╗
#  ██╔██╗ ██║██║   ██║██║  ██║█████╗  ██╔████╔██║███████║███████╗   ██║   █████╗  ██████╔╝
#  ██║╚██╗██║██║   ██║██║  ██║██╔══╝  ██║╚██╔╝██║██╔══██║╚════██║   ██║   ██╔══╝  ██╔══██╗
#  ██║ ╚████║╚██████╔╝██████╔╝███████╗██║ ╚═╝ ██║██║  ██║███████║   ██║   ███████╗██║  ██║
#  ╚═╝  ╚═══╝ ╚═════╝ ╚═════╝ ╚══════╝╚═╝     ╚═╝╚═╝  ╚═╝╚══════╝   ╚═╝   ╚══════╝╚═╝  ╚═╝
#                                                              ╚╗ @marsmensch 2016-2017 ╔╝                   				           
#
# version: 	0.4-beta
# date:    	2017-10-04
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

function source_config() {
	if [ -f ${SETUP_CONF_FILE} ]; then
		echo "read default config"	
		source config/default.env
		echo "Script version ${SCRIPT_VERSION}, you picked: ${1}"
		echo "apply config file for ${1}"		
		source "${SETUP_CONF_FILE}"

		echo "running installer script"		
		source scripts/masternode_install.sh ${1}
	else
		echo "required file ${SETUP_CONF_FILE} does not exist, abort!"
		exit 1   
	fi
}

SETUP_CONF_FILE="config/${1}/${1}.env"
SETUP_MNODES_COUNT=${2}

# put in main at a later point in time

source_config ${1}