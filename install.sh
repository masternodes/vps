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
declare -r IPV6_INT_BASE="$(ip -6 addr show dev ${ETH_INTERFACE} | grep inet6 | awk -F '[ \t]+|/' '{print $3}' | grep -v ^fe80 | grep -v ^::1 | cut -f1-4 -d':' | head -1)"
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

# source the default and desired crypto configuration files
function source_config() {
    SETUP_CONF_FILE="config/${1}/${1}.env"
	if [ -f ${SETUP_CONF_FILE} ]; then
		echo "read default config"	
		source config/default.env
		echo "Script version ${SCRIPT_VERSION}, you picked: ${1}"
		echo "apply config file for ${1}"		
		source "${SETUP_CONF_FILE}"

		echo "running installer script, NOT YET"		
		#source scripts/masternode_install.sh ${1}
	else
		echo "required file ${SETUP_CONF_FILE} does not exist, abort!"
		exit 1   
	fi
}

# display the help message
function show_help(){
	clear
	showbanner
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

remove_install(){
    [ -s "${BIN_SCRIPT}" ] && ${BIN_SCRIPT} stop > /dev/null 2>&1
    [ -f "${BIN_SCRIPT}" ] && rm "${BIN_SCRIPT}"
    [ -n "$BIN_DIR" ] && rm -r "$BIN_DIR"
}

generate_config_ip(){
    local ipaddr="$1"
    local port="$2"

    cat <<EOF
# Generate interface ${ipaddr}
internal: ${ipaddr}  port = ${port}
external: ${ipaddr}

EOF
}

generate_config_white(){
    local white_ipaddr="$1"

    [ -z "${white_ipaddr}" ] && return 1

    # x.x.x.x/32
    for ipaddr_range in ${white_ipaddr};do
        cat <<EOF
#------------ Network Trust: ${ipaddr_range} ---------------
pass {
        from: ${ipaddr_range} to: 0.0.0.0/0
        method: none
}

EOF
    done
}

generate_config(){
    local ipaddr_list="$1"
    local whitelist_url="$2"
    local whitelist_ip="$3"
    echo "in generate config NOW"
}



##################------------Menu()---------#####################################

# Declare vars. Flags initalizing to 0.
wipe=0;
 
# Execute getopt
ARGS=$(getopt -o "hp:n:c:r:wu:" -l "help,project:,net:,count:,release:,wipe,update:" -n "test" -- "$@");
 
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


[ -n "${count}" ] && echo "COUNT: ${count}" && count="${SETUP_MNODES_COUNT}"
[ -n "${ipaddr_list}" ] && DEFAULT_IPADDR="${ipaddr_list}"
[ -n "${user}" ] && DEFAULT_USER="${user}"
[ -n "${passwd}" ] && DEFAULT_PAWD="${passwd}"
[ -n "${whitelist_ipaddrs}" ] && WHITE_LIST_NET="${whitelist_ipaddrs}"
[ -n "${whitelist}" ] && WHITE_LIST="${whitelist}"

generate_config "${DEFAULT_IPADDR}" "${WHITE_LIST}" "${WHITE_LIST_NET}"

[ -u "$update_only" ]  && echo "===========>> update_only, replace daemon!" && cat ${CONFIG_PATH} && exit 0


main() {
    echo "PROJECT: ${project}"
    echo "SETUP_MNODES_COUNT: ${count}"
    echo "RELEASE: ${release}"
    echo "NET: ${net}"
    source_config ${project} 
    echo "PROJECT: ${project}"
    echo "SETUP_MNODES_COUNT: ${count}"
    echo "DEFAULT SETUP_MNODES_COUNT: ${SETUP_MNODES_COUNT}"
    echo "RELEASE: ${release}"
    echo "NET: ${net}"       
}

main "$@"