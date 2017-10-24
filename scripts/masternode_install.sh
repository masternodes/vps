#!/bin/bash
#  ███╗   ██╗ ██████╗ ██████╗ ███████╗███╗   ███╗ █████╗ ███████╗████████╗███████╗██████╗ 
#  ████╗  ██║██╔═══██╗██╔══██╗██╔════╝████╗ ████║██╔══██╗██╔════╝╚══██╔══╝██╔════╝██╔══██╗
#  ██╔██╗ ██║██║   ██║██║  ██║█████╗  ██╔████╔██║███████║███████╗   ██║   █████╗  ██████╔╝
#  ██║╚██╗██║██║   ██║██║  ██║██╔══╝  ██║╚██╔╝██║██╔══██║╚════██║   ██║   ██╔══╝  ██╔══██╗
#  ██║ ╚████║╚██████╔╝██████╔╝███████╗██║ ╚═╝ ██║██║  ██║███████║   ██║   ███████╗██║  ██║
#  ╚═╝  ╚═══╝ ╚═════╝ ╚═════╝ ╚══════╝╚═╝     ╚═╝╚═╝  ╚═╝╚══════╝   ╚═╝   ╚══════╝╚═╝  ╚═╝
#                                                              ╚╗ @marsmensch 2016-2017 ╔╝                   				
#                   
# version 	0.4-alpha
# date    	2017-09-26
#
# function	masternode setup script
#			This scripts needs to be run as root
# 			to make services start persistent
#
# Twitter 	@marsmensch
#

# Useful variables
DATE_STAMP="$(date +%y-%m-%d-%s)"
# im an not very proud of this
IPV6_INT_BASE="$(ip -6 addr show dev ${ETH_INTERFACE} | grep inet6 | awk -F '[ \t]+|/' '{print $3}' | grep -v ^fe80 | grep -v ^::1 | cut -f1-4 -d':' | head -1)"

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

function build_mn_from_source() {
        # daemon not found compile it
        if [ ! -f ${MNODE_DAEMON} ]; then
                mkdir -p ${CODE_DIR}
                # if code directory does not exists, we create it clone the src
                if [ ! -d ${CODE_DIR}/${GIT_PROJECT} ]; then
                        mkdir -p ${CODE_DIR} && cd ${CODE_DIR}
                        git clone ${GIT_URL} ${GIT_PROJECT}
                        cd ${GIT_PROJECT}
                        echo "Checkout desired tag: ${SCVERSION}"
                        git checkout ${SCVERSION}
                else
                        echo "code and project dirs exist, update the git repo and checkout again"
                        cd ${CODE_DIR}/${GIT_PROJECT}
                        git pull
                        git checkout ${SCVERSION}
                fi

                # print ascii banner if a logo exists
                echo -e "Starting the compilation process for ${CODENAME}, stay tuned"
                if [ -f "../../assets/$CODENAME.jpg" ]; then
                        jp2a -b --colors --width=64 ../../assets/${CODENAME}.jpg     
                fi  
                # compilation starts here
                source ../../config/${CODENAME}/${CODENAME}.compile
        else
                echo "daemon already in place at ${MNODE_DAEMON}, not compiling"
        fi
}

function prepare_mn_interfaces() {
	# vultr specific, needed to work
	sed -ie '/iface ${ETH_INTERFACE} inet6 auto/s/^/#/' ${NETWORK_CONFIG}
    # move current config out of the way first
    cp ${NETWORK_CONFIG} ${NETWORK_CONFIG}.${DATE_STAMP}.bkp

	# create the additional ipv6 interfaces, rc.local because it's more generic 	    
	for NUM in $(seq 1 ${SETUP_MNODES_COUNT}); do

	    # check if the interfaces exist	    
	    ip -6 addr | grep -qi "${IPV6_INT_BASE}:${NETWORK_BASE_TAG}::${NUM}"
		if [ $? -eq 0 ]
		then
		  echo "IP already exists"
		else
		  echo "Creating new IP address for ${GIT_PROJECT} masternode nr ${NUM}"
		  echo "ip -6 addr add ${IPV6_INT_BASE}:${NETWORK_BASE_TAG}::${NUM}/64 dev ${ETH_INTERFACE}" >> ${NETWORK_CONFIG}
		  sleep 2
		  ip -6 addr add ${IPV6_INT_BASE}:${NETWORK_BASE_TAG}::${NUM}/64 dev ${ETH_INTERFACE}
		fi
		
	done
}

function create_mn_user() {

    # our new mnode unpriv user acc is added 
    if id "${MNODE_USER}" >/dev/null 2>&1; then
        echo "user exists already, do nothing"
    else
        echo "Adding new system user ${MNODE_USER}"
        adduser --disabled-password --gecos "" ${MNODE_USER}
    fi
    
}

function create_mn_dirs() {
    # individual data dirs for now to avoid problems
    echo "Creating masternode directories"
    mkdir -p ${MNODE_CONF_BASE}
	for NUM in $(seq 1 ${SETUP_MNODES_COUNT}); do
	    if [ ! -d "${MNODE_DATA_BASE}/${GIT_PROJECT}${NUM}" ]; then
	         echo "creating data directory ${MNODE_DATA_BASE}/${GIT_PROJECT}${NUM}"
             mkdir -p ${MNODE_DATA_BASE}/${GIT_PROJECT}${NUM}
        fi
	done    
}

function configure_firewall() {
    echo "Configuring firewall rules"
	# disallow everything except ssh and masternode inbound ports
	ufw default deny
	ufw logging on
	ufw allow ${SSH_INBOUND_PORT}/tcp
	# KISS, its always the same port for all interfaces
	ufw allow ${MNODE_INBOUND_PORT}/tcp
	# This will only allow 6 connections every 30 seconds from the same IP address.
	ufw limit OpenSSH	
	ufw --force enable 
}

function create_mn_configuration() {
        # create one config file per masternode
        for NUM in $(seq 1 ${SETUP_MNODES_COUNT}); do
        PASS=$(date | md5sum | cut -c1-24)

			# we dont want to overwrite an existing config file
			if [ ! -f ${MNODE_CONF_BASE}/${GIT_PROJECT}_n${NUM}.conf ]; then
                echo "config doesn't exist, generate it!"
                
				# if a template exists, use this instead of the default
				if [ -e config/${GIT_PROJECT}/${GIT_PROJECT}.conf ]; then
					echo "configuration template for ${GIT_PROJECT} found, use this instead"
					cp config/${GIT_PROJECT}/${GIT_PROJECT}.conf ${MNODE_CONF_BASE}/${GIT_PROJECT}_n${NUM}.conf
				else
					echo "using the default configuration template"
					echo "PWD: $PWD"
					echo "LS: "
					ls -lah
					
					cp config/default.conf ${MNODE_CONF_BASE}/${GIT_PROJECT}_n${NUM}.conf
				fi
				# replace placeholders
				echo "running sed on file ${MNODE_CONF_BASE}/${GIT_PROJECT}_n${NUM}.conf"
				sed -e "s/XXX_GIT_PROJECT_XXX/${GIT_PROJECT}/" -e "s/XXX_NUM_XXX/${NUM}/" -e "s/XXX_PASS_XXX/${PASS}/" -e "s/XXX_IPV6_INT_BASE_XXX/${IPV6_INT_BASE}/" -e "s/XXX_NETWORK_BASE_TAG_XXX/${NETWORK_BASE_TAG}/" -e "s/XXX_MNODE_INBOUND_PORT_XXX/${MNODE_INBOUND_PORT}/" -i ${MNODE_CONF_BASE}/${GIT_PROJECT}_n${NUM}.conf
										   
			fi        
			
        done
}

function create_control_configuration() {
    rm /tmp/${GIT_PROJECT}_masternode.conf
	# create one line per masternode with the data we have
	for NUM in $(seq 1 ${SETUP_MNODES_COUNT}); do
		cat >> /tmp/${GIT_PROJECT}_masternode.conf <<-EOF
			${GIT_PROJECT}MN${NUM} [${IPV6_INT_BASE}:${NETWORK_BASE_TAG}::${NUM}]:${MNODE_INBOUND_PORT} MASTERNODE_PRIVKEY_FOR_${GIT_PROJECT}MN${NUM} COLLATERAL_TX_FOR_${GIT_PROJECT}MN${NUM} OUTPUT_NO_FOR_${GIT_PROJECT}MN${NUM}	
		EOF
	done
}

function create_systemd_configuration() {
	# create one config file per masternode
	for NUM in $(seq 1 ${SETUP_MNODES_COUNT}); do
	PASS=$(date | md5sum | cut -c1-24)
		echo "(over)writing systemd config file ${SYSTEMD_CONF}/${GIT_PROJECT}_n${NUM}.service"
		cat > ${SYSTEMD_CONF}/${GIT_PROJECT}_n${NUM}.service <<-EOF
			[Unit]
			Description=${GIT_PROJECT} distributed currency daemon
			After=network.target
                 
			[Service]
			User=${MNODE_USER}
			Group=${MNODE_USER}
         	
			Type=forking
			PIDFile=${MNODE_DATA_BASE}/${GIT_PROJECT}${NUM}/${GIT_PROJECT}.pid
			ExecStart=${MNODE_DAEMON} -daemon -pid=${MNODE_DATA_BASE}/${GIT_PROJECT}${NUM}/${GIT_PROJECT}.pid \
			-conf=${MNODE_CONF_BASE}/${GIT_PROJECT}_n${NUM}.conf -datadir=${MNODE_DATA_BASE}/${GIT_PROJECT}${NUM}
       		 
			Restart=always
			RestartSec=5
			PrivateTmp=true
			TimeoutStopSec=60s
			TimeoutStartSec=5s
			StartLimitInterval=120s
			StartLimitBurst=15
         	
			[Install]
			WantedBy=multi-user.target			
		EOF
	done
}

function set_permissions() {
	# maybe add a sudoers entry later
	chown -R ${MNODE_USER}:${MNODE_USER} ${MNODE_CONF_BASE} ${MNODE_DATA_BASE}
}

function cleanup_after() {
	apt-get -qqy -o=Dpkg::Use-Pty=0 --force-yes autoremove
	apt-get -qqy -o=Dpkg::Use-Pty=0 --force-yes autoclean

	echo "kernel.randomize_va_space=1" > /etc/sysctl.conf
	echo "net.ipv4.conf.all.rp_filter=1" >> /etc/sysctl.conf
	echo "net.ipv4.conf.all.accept_source_route=0" >> /etc/sysctl.conf
	echo "net.ipv4.icmp_echo_ignore_broadcasts=1" >> /etc/sysctl.conf
	echo "net.ipv4.conf.all.log_martians=1" >> /etc/sysctl.conf
	echo "net.ipv4.conf.default.log_martians=1" >> /etc/sysctl.conf
	echo "net.ipv4.conf.all.accept_redirects=0" >> /etc/sysctl.conf
	echo "net.ipv6.conf.all.accept_redirects=0" >> /etc/sysctl.conf
	echo "net.ipv4.conf.all.send_redirects=0" >> /etc/sysctl.conf
	echo "kernel.sysrq=0" >> /etc/sysctl.conf
	echo "net.ipv4.tcp_timestamps=0" >> /etc/sysctl.conf
	echo "net.ipv4.tcp_syncookies=1" >> /etc/sysctl.conf
	echo "net.ipv4.icmp_ignore_bogus_error_responses=1" >> /etc/sysctl.conf
	sysctl -p
	
}

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

function final_call() {
	# note outstanding tasks that need manual work
    echo "************! ALMOST DONE !******************************"	
	echo "There is still work to do in the configuration templates."
	echo "These are located at ${MNODE_CONF_BASE}, one per masternode."
	echo "Add your masternode private keys now."
	echo "eg in /etc/masternodes/${GIT_PROJECT}_n1.conf"	
	# systemctl command to work with mnodes here 
	echo "#!/bin/bash" > ${MNODE_HELPER}
	for NUM in $(seq 1 ${SETUP_MNODES_COUNT}); do
		echo "systemctl enable ${GIT_PROJECT}_n${NUM}" >> ${MNODE_HELPER}
		echo "systemctl restart ${GIT_PROJECT}_n${NUM}" >> ${MNODE_HELPER}
	done
	chmod u+x ${MNODE_HELPER}
	tput sgr0
}

main() {
    showbanner
    check_distro
    swaphack
    install_packages
    build_mn_from_source 
    prepare_mn_interfaces
    create_mn_user
    create_mn_dirs
    configure_firewall      
    create_mn_configuration
    create_control_configuration
    create_systemd_configuration 
    set_permissions
    cleanup_after
    final_call
    showbanner     
}

main "$@"
