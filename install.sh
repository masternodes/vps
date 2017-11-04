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


SETUP_MNODES_COUNT=${2}
CRYPTOS=`ls -l config/ | egrep '^d' | awk '{print $9}'`

################# DELETE #
DEFAULT_IPADDR=$(ip addr | grep 'inet ' | grep -Ev 'inet 127|inet 192\.168|inet 10\.' | \
            sed "s/[[:space:]]*inet \([0-9.]*\)\/.*/\1/")
RUN_PATH=$(cd `dirname $0`;pwd )
RUN_OPTS=$*
################# DELETE #

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
function show_help() {
	clear
	showbanner
	options=(
			  "--project@ project shortname" \
			  "--net@ ip address format ipv4|ipv6" \
			  "--count@ amount of nodes to be installed" \
			  "--release@ release to install" \
			  "--update,-u@ update toversion" \
			  "--wipe,-w@ wipe all data (!!!)" \
			  "--help,-h@ print help info" )
	printf "Usage: %s CRYPTO [OPTIONS]\n\nOptions:\n\n" $0

	for option in "${options[@]}";do
	  printf "  %-20s%s\n" "$( echo ${option} | sed 's/@.*//g')"  "$( echo ${option} | sed 's/.*@//g')"
	done	
	echo -e "\n"
	exit 1
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

if (( $# < 1 ));
then
    show_help
    exit 1
fi    

# “a” and “arga” have optional arguments with default values.
# “b” and “argb” have no arguments, acting as sort of a flag.
# “c” and “argc” have required arguments.

# set an initial value for the flag
ARG_B=0

# read the options
TEMP=`getopt -o a::bc: --long arga::,argb,argc: -n 'test.sh' -- "$@"`
eval set -- "$TEMP"

# extract options and their arguments into variables.
while true ; do
    case "$1" in
        -a|--arga)
            case "$2" in
                "") ARG_A='some default value' ; shift 2 ;;
                *) ARG_A=$2 ; shift 2 ;;
            esac ;;
        -b|--argb) ARG_B=1 ; shift ;;
        -c|--argc)
            case "$2" in
                "") shift 2 ;;
                *) ARG_C=$2 ; shift 2 ;;
            esac ;;
        --) shift ; break ;;
        *) echo "Internal error!" ; exit 1 ;;
    esac
done

# do something with the variables -- in this case the lamest possible one :-)
echo "ARG_A = $ARG_A"
echo "ARG_B = $ARG_B"
echo "ARG_C = $ARG_C"


# for _PARAMETER in $RUN_OPTS
# do
#     case "${_PARAMETER}" in
#       --project=*)
#         CODENAME=${_PARAMETER}
#         #project="${_PARAMETER#--project=}"
#         echo "CODENAME: ${CODENAME}"
#         source_config ${CODENAME}
#       ;;    
#       --net=*)  
#         net=${_PARAMETER} #ipaddr_list=$(echo "${_PARAMETER#--net=}" | sed 's/:/\n/g' | sed '/^$/d')
#       ;;
#       --count=*)
#         SETUP_MNODES_COUNT==${_PARAMETER}
#         #count="${_PARAMETER#--count=}"
#         echo "SETUP_MNODES_COUNT: ${SETUP_MNODES_COUNT}"
#       ;;
#       --release=*)
#         release="${_PARAMETER}"
#         #release="${_PARAMETER#--relese=}"
#       ;;
#       --update|-u)
#         update_only="true" # set some var here
#       ;;
#       --wipe|-w)
#         remove_install # run uninstall function here
#         exit 0
#       ;;      
#       --help|-h)
#         show_help
#         exit 1
#       ;;
#       *)
#          echo "option ${_PARAMETER} is not support"
#          exit 1
#       ;;
# 
#     esac
# done

[ -n "${port}" ] && DEFAULT_PORT="${port}"
[ -n "${ipaddr_list}" ] && DEFAULT_IPADDR="${ipaddr_list}"
[ -n "${user}" ] && DEFAULT_USER="${user}"
[ -n "${passwd}" ] && DEFAULT_PAWD="${passwd}"
[ -n "${whitelist_ipaddrs}" ] && WHITE_LIST_NET="${whitelist_ipaddrs}"
[ -n "${whitelist}" ] && WHITE_LIST="${whitelist}"

generate_config "${DEFAULT_IPADDR}" "${WHITE_LIST}" "${WHITE_LIST_NET}"

[ -u "$update_only" ]  && echo "===========>> update_only, replace daemon!" && cat ${CONFIG_PATH} && exit 0


main() {
    #source_config ${1}
    echo "PROJECT: ${project}"
    echo "CODENAME: ${CODENAME}"
    echo "SETUP_MNODES_COUNT: ${SETUP_MNODES_COUNT}"
    echo "RELEASE: ${release}"
    echo "NET: ${NET}"    
}

main "$@"