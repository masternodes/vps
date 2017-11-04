#!/bin/bash
#  ███╗   ██╗ ██████╗ ██████╗ ███████╗███╗   ███╗ █████╗ ███████╗████████╗███████╗██████╗ 
#  ████╗  ██║██╔═══██╗██╔══██╗██╔════╝████╗ ████║██╔══██╗██╔════╝╚══██╔══╝██╔════╝██╔══██╗
#  ██╔██╗ ██║██║   ██║██║  ██║█████╗  ██╔████╔██║███████║███████╗   ██║   █████╗  ██████╔╝
#  ██║╚██╗██║██║   ██║██║  ██║██╔══╝  ██║╚██╔╝██║██╔══██║╚════██║   ██║   ██╔══╝  ██╔══██╗
#  ██║ ╚████║╚██████╔╝██████╔╝███████╗██║ ╚═╝ ██║██║  ██║███████║   ██║   ███████╗██║  ██║
#  ╚═╝  ╚═══╝ ╚═════╝ ╚═════╝ ╚══════╝╚═╝     ╚═╝╚═╝  ╚═╝╚══════╝   ╚═╝   ╚══════╝╚═╝  ╚═╝
#                                                              ╚╗ @marsmensch 2016-2017 ╔╝                   				
#                   
# version 	0.7-alpha
# date    	2017-11-03
#
# function:	part of the masternode scripts, source the proper config file
#                                                                      
# 	Instructions:
#               Run this script w/ the desired parameters. Leave blank or use -h for help.
#
#	Platforms: 	
#               - Linux Ubuntu 16.04 LTS ONLY on a Vultr VPS (its by far the cheapest option)
#               - Generic Ubuntu support will be added at a later point in time
#
#	System requirements:
#               - A vultr micro instance works for up to 5 masternodes 
#				- Activate the free IPv6 option for best results
#
# Twitter 	@marsmensch

# Useful variables
declare -r CRYPTOS=`ls -l config/ | egrep '^d' | awk '{print $9}' | xargs echo -n; echo`
declare -r DATE_STAMP="$(date +%y-%m-%d-%s)"
declare -r SCRIPTPATH=$( cd $(dirname ${BASH_SOURCE[0]}) > /dev/null; pwd -P )
declare -r MASTERPATH="$(dirname "${SCRIPTPATH}")"


function showbanner() {
cat << "EOF"
 ███╗   ██╗ ██████╗ ██████╗ ███████╗███╗   ███╗ █████╗ ███████╗████████╗███████╗██████╗ 
 ████╗  ██║██╔═══██╗██╔══██╗██╔════╝████╗ ████║██╔══██╗██╔════╝╚══██╔══╝██╔════╝██╔══██╗
 ██╔██╗ ██║██║   ██║██║  ██║█████╗  ██╔████╔██║███████║███████╗   ██║   █████╗  ██████╔╝
 ██║╚██╗██║██║   ██║██║  ██║██╔══╝  ██║╚██╔╝██║██╔══██║╚════██║   ██║   ██╔══╝  ██╔══██╗
 ██║ ╚████║╚██████╔╝██████╔╝███████╗██║ ╚═╝ ██║██║  ██║███████║   ██║   ███████╗██║  ██║
 ╚═╝  ╚═══╝ ╚═════╝ ╚═════╝ ╚══════╝╚═╝     ╚═╝╚═╝  ╚═╝╚══════╝   ╚═╝   ╚══════╝╚═╝  ╚═╝
                                                             ╚╗ @marsmensch 2016-2017 ╔╝                   				
EOF
}

function check_distro() {
	# currently only for Ubuntu 16.04
	if [[ -r /etc/os-release ]]; then
		. /etc/os-release
		if [[ "${VERSION_ID}" != "16.04" ]]; then
			echo "This script only supports ubuntu 16.04 LTS, exiting."
			exit 1
		fi
	else
		# no, thats not ok!
		echo "This script only supports ubuntu 16.04 LTS, exiting."	
		exit 1
	fi
}

function check_ipv6() {
    
    declare -r IPV6_INT_BASE="$(ip -6 addr show dev ${ETH_INTERFACE} | grep inet6 | awk -F '[ \t]+|/' '{print $3}' | grep -v ^fe80 | grep -v ^::1 | cut -f1-4 -d':' | head -1)"
	# check for vultr ipv6 box active
	if [ -z "${IPV6_INT_BASE}" ]; then
		echo "we don't have ipv6 range support on this VPS, please switch to ipv4 with option -n 4"
		echo "OUTPUT DOCS LINK HERE!"
		exit 1
	fi	
}

function install_packages() {
	# development and build packages
	# these are common on all cryptos
	echo "Package installation!"
	apt-get -qq update
	apt-get -qqy -o=Dpkg::Use-Pty=0 install build-essential g++ \
	protobuf-compiler libboost-all-dev autotools-dev \
    automake libcurl4-openssl-dev libboost-all-dev libssl-dev libdb++-dev \
    make autoconf automake libtool git apt-utils libprotobuf-dev pkg-config \
    libcurl3-dev libudev-dev libqrencode-dev bsdmainutils pkg-config libssl-dev \
    libgmp3-dev libevent-dev jp2a
}

function swaphack() { 
#check if swap is available
if [ $(free | awk '/^Swap:/ {exit !$2}') ] || [ ! -f "/var/mnode_swap.img" ];then
	echo "No proper swap, creating it"
	# needed because ant servers are ants
	rm -f /var/mnode_swap.img
	dd if=/dev/zero of=/var/mnode_swap.img bs=1024k count=${MNODE_SWAPSIZE}
	chmod 0600 /var/mnode_swap.img
	mkswap /var/mnode_swap.img
	swapon /var/mnode_swap.img
	echo '/var/mnode_swap.img none swap sw 0 0' | tee -a /etc/fstab
	echo 'vm.swappiness=10' | tee -a /etc/sysctl.conf
	echo 'vm.vfs_cache_pressure=50' | tee -a /etc/sysctl.conf		
else
	echo "All good, we have a swap"	
fi
}

# source the default and desired crypto configuration files
function source_config() {
    SETUP_CONF_FILE="config/${1}/${1}.env"    
    
	if [ -f ${SETUP_CONF_FILE} ]; then
		#echo "read default config"	
		#source config/default.env
		echo "Script version ${SCRIPT_VERSION}, you picked: ${1}"
		echo "apply config file for ${1}"		
		source "${SETUP_CONF_FILE}"

		echo "running installer script, NOT YET"		
		#source scripts/masternode_install.sh ${1}
	else
		echo "required file ${SETUP_CONF_FILE} does not exist, abort!"
		exit 1   
	fi

    # release is from the default config but can ultimately be
    # overwritten at runtime
	if [ -z "$count" ]
	then
		count=${SETUP_MNODES_COUNT}
		echo "COUNT EMPTY, setting to default: ${SETUP_MNODES_COUNT}"
	fi

    # release is from the default project config but can ultimately be
    # overwritten at runtime
	if [ -z "$release" ]
	then
		release=${SCVERSION}
		echo "release EMPTY, setting to proj default: ${SCVERSION}"
	fi

    # net is from the default config but can ultimately be
    # overwritten at runtime
	if [ -z "$net" ]; then
		net=${NETWORK_TYPE}
		echo "net EMPTY, setting to default: ${NETWORK_TYPE}"
	fi

    # TODO: PRINT A BOLD WANRING REGARDING MANUAL IPv$ CONFIG STEPS
    # AND LINK TO THE CORRESPONDING ARTICLE HERE	
	# check the exact type of network
	if [ "$net" -eq 4 ]; then
        echo "YOU will have some mamual work to do, see xxxx for some"
        echo "details how to add multiple ipv4 addresses on vultr"
    fi		

	# user opted for ipv6 (default), so we have to check for ipv6 support
	if [ "$net" -eq 6 ]; then
         check_ipv6
	fi
	
}

# display the help message
function show_help(){
	clear
	#showbanner
	echo "project is a required parameter !";
    echo "";
    echo "Usage example:";
    echo "install.sh (-p|--project) string [(-h|--help)] [(-n|--net) value] [(-c|--count) value] [(-r|--release) value] [(-w|--wipe)] [(-u|--update) value]";
    echo "Options:";
    echo "-h or --help: Displays this information.";
    echo "-p or --project string: Project to be installed. Required.";
    echo "-n or --net: IP address type t be used (ipv4 vs ipv6).";
    echo "-c or --count: Number of masternodes to be installed.";
    echo "-r or --release: Release version to be installed.";
    echo "-w or --wipe: Wipe ALL local data.";
    echo "-u or --update: Update a specific masternode daemon.";
    exit 1;
}

##################------------Menu()---------#####################################

# Declare vars. Flags initalizing to 0.
wipe=0;
 
# Execute getopt
ARGS=$(getopt -o "hp:n:c:r:wu:" -l "help,project:,net:,count:,release:,wipe,update:" -n "install.sh" -- "$@");
 
#Bad arguments
if [ $? -ne 0 ];
then
    help;
fi
 
eval set -- "$ARGS";
 
while true; do
    case "$1" in
        -h|--help)
            shift;
            help;
            ;;
        -p|--project)
            shift;
                    if [ -n "$1" ]; 
                    then
                        project="$1";
                        shift;
                    fi
            ;;
        -n|--net)
            shift;
                    if [ -n "$1" ]; 
                    then
                        net="$1";
                        shift;
                    fi
            ;;
        -c|--count)
            shift;
                    if [ -n "$1" ]; 
                    then
                        count="$1";
                        shift;
                    fi
            ;;
        -r|--release)
            shift;
                    if [ -n "$1" ]; 
                    then
                        release="$1";
                        shift;
                    fi
            ;;
        -w|--wipe)
            shift;
                    wipe="1";
            ;;
        -u|--update)
            shift;
                    if [ -n "$1" ]; 
                    then
                        update="$1";
                        shift;
                    fi
            ;;
 
        --)
            shift;
            break;
            ;;
    esac
done
 
# Check required arguments
if [ -z "$project" ]
then
    show_help;
fi
 
# Iterate over rest arguments called $arg
for arg in "$@"
do
    # Your code here (remove example below)
    echo $arg
 
done

#################################################
# source default config before everything else
source ${SCRIPTPATH}/config/default.env
#################################################

# [ -n "${ipaddr_list}" ] && DEFAULT_IPADDR="${ipaddr_list}"
# [ -n "${user}" ] && DEFAULT_USER="${user}"
# [ -n "${passwd}" ] && DEFAULT_PAWD="${passwd}"
# [ -n "${whitelist_ipaddrs}" ] && WHITE_LIST_NET="${whitelist_ipaddrs}"
# [ -n "${whitelist}" ] && WHITE_LIST="${whitelist}"
# 
# generate_config "${DEFAULT_IPADDR}" "${WHITE_LIST}" "${WHITE_LIST_NET}"
# 
# [ -u "$update_only" ]  && echo "===========>> update_only, replace daemon!" && cat ${CONFIG_PATH} && exit 0


main() {
    #showbanner
    check_distro
    swaphack
    install_packages
    echo "********************** VALUES AFTER CONFIG SOURCING: ************************"
    echo "START DEFAULTS => "
	echo "SCRIPT_VERSION:       $SCRIPT_VERSION"
	echo "SSH_INBOUND_PORT:     ${SSH_INBOUND_PORT}"
	echo "SYSTEMD_CONF:         ${SYSTEMD_CONF}"
	echo "NETWORK_CONFIG:       ${NETWORK_CONFIG}"
	echo "NETWORK_TYPE:         ${NETWORK_TYPE}"	
	echo "ETH_INTERFACE:        ${ETH_INTERFACE}"
	echo "MNODE_CONF_BASE:      ${MNODE_CONF_BASE}"
	echo "MNODE_DATA_BASE:      ${MNODE_DATA_BASE}"
	echo "MNODE_USER:           ${MNODE_USER}"
	echo "MNODE_HELPER:         ${MNODE_HELPER}"
	echo "MNODE_SWAPSIZE:       ${MNODE_SWAPSIZE}"
	echo "CODE_DIR:             ${CODE_DIR}"
    echo "SETUP_MNODES_COUNT:   ${SETUP_MNODES_COUNT}"	
    echo "END DEFAULTS => "
 
    source_config ${project}
    echo "START PROJECT => "
	echo "CODENAME:             $CODENAME"
	echo "SETUP_MNODES_COUNT:   ${SETUP_MNODES_COUNT}"
	echo "MNODE_DAEMON:         ${MNODE_DAEMON}"
	echo "MNODE_INBOUND_PORT:   ${MNODE_INBOUND_PORT}"
	echo "GIT_URL:              ${GIT_URL}"
	echo "SCVERSION:            ${SCVERSION}"
	echo "NETWORK_BASE_TAG:     ${NETWORK_BASE_TAG}"	
    echo "END PROJECT => "   	
	     
    echo "START OPTIONS => "
    echo "RELEASE: ${release}"
    echo "PROJECT: ${project}"
    echo "SETUP_MNODES_COUNT: ${count}"
    echo "NETWORK_TYPE: ${NETWORK_TYPE}"    
       
    echo "END OPTIONS => "
    echo "********************** VALUES AFTER CONFIG SOURCING: ************************"           
}

main "$@"