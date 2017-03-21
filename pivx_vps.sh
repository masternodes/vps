#!/bin/bash
#                             
# ██████╗ ██╗██╗   ██╗██╗  ██╗
# ██╔══██╗██║██║   ██║╚██╗██╔╝
# ██████╔╝██║██║   ██║ ╚███╔╝ 
# ██╔═══╝ ██║╚██╗ ██╔╝ ██╔██╗ 
# ██║     ██║ ╚████╔╝ ██╔╝ ██╗
# ╚═╝     ╚═╝  ╚═══╝  ╚═╝  ╚═╝           
#
# version 	0.32-beta
# date    	2017-03-21
# function	masternode setup script
#			This scripts needs to be run as root
# 			to make services start persistent
#
# Twitter 	@marsmensch
#
# tips welcome at
# BTC  1PboFDkBsW2i968UnehWwcSrM9Djq5LcLB
# PIVX DQS4rk57bteJ42FSNSPpwqHUoNhx4ywfQc
#
SETUP_NODES_COUNT=1

########################################
# Dont change anything here if unsure!
########################################

# variables
SSH_INBOUND_PORT=${SSH_INBOUND_PORT:-22}
SYSTEMD_CONF=${SYSTEMD_CONF:-/etc/systemd/system}
GIT_URL=git@github.com:PIVX-Project/PIVX.git
NODE_CONF_BASE=${NODE_CONF_BASE:-/etc}
NODE_DATA_BASE=${NODE_DATA_BASE:-/var/lib}
NODE_USER=${NODE_USER:-pivxd}
NODE_INBOUND_PORT=${NODE_INBOUND_PORT:-51472}
NODE_SWAPSIZE=${NODE_SWAPSIZE:-5000}
NODE_DAEMON=${NODE_DAEMON:-/usr/local/bin/pivxd}

# Git related stuff
CODENAME=pivx
GIT_URL=https://github.com/PIVX-Project/PIVX.git
SCVERSION="v2.1.6-stable"

# DISTRO specific stuff
SYSTEMD_CONF=${SYSTEMD_CONF:-/etc/systemd/system}
NETWORK_CONFIG=${NETWORK_CONFIG:-/etc/network/interfaces}
ETH_INTERFACE=${ETH_INTERFACE:-ens3}

# Useful variables
DATE_STAMP="$(date +%y-%m-%d-%s)"

function check_distro() {
	# currently only for Ubuntu 16.04
	if [[ -r /etc/os-release ]]; then
	. /etc/os-release
		if [[ "${VERSION_ID}" = "16.04" ]]; then
			echo "This is 16.04 LTS"
		elif [[ "${VERSION_ID}" = "15.10" ]]; then
			echo "This is 15.10"			
		elif [[ "${VERSION_ID}" = "14.04" ]]; then
			echo "This is 14.04 LTS"
		else
			echo "Nope"
			exit 1	
		fi
	else
		# no, thats not ok!
		echo "This script only supports ubuntu 14.04, 15.10 and 16.04 LTS, exiting."	
		exit 1
	fi
}

function install_packages() {
	# development and build packages
	# these are common on all cryptos
	echo "Package installation!"
	apt-get -qq update
	apt-get -qqy -o=Dpkg::Use-Pty=0 install build-essential protobuf-compiler \
    automake libcurl4-openssl-dev libboost-all-dev libssl-dev libdb++-dev \
    make autoconf automake libtool git apt-utils libprotobuf-dev pkg-config \
    libcurl3-dev libudev-dev libqt4-dev libqrencode-dev bsdmainutils qt5-default \
    libqjson-dev libqjson0 qtdeclarative5-dev libqrencode-dev qtbase5-dev \
    libqt5opengl5-dev pkg-config
}

function swaphack() { 
	#check if swap is available
	if free | awk '/^Swap:/ {exit !$2}'; then
		echo "Already have swap"
	else
		echo "No swap"
		# needed because ant servers are ants
		rm -f /var/swap.img
		dd if=/dev/zero of=/var/swap.img bs=1024k count=${NODE_SWAPSIZE}
		chmod 0600 /var/swap.img
		mkswap /var/swap.img
		swapon /var/swap.img
		echo '/var/swap.img none swap sw 0 0' | tee -a /etc/fstab
		echo 'vm.swappiness=10' | tee -a /etc/sysctl.conf
		echo 'vm.vfs_cache_pressure=50' | tee -a /etc/sysctl.conf		
	fi
}

function build_from_source() {
	# daemon not found compile it
	if [ ! -f ${NODE_DAEMON} ]; then
			# if code directory does not exists, we create it and clone the src
			if [ ! -d /opt/code/${CODENAME} ]; then
				mkdir -p /opt/code/ && cd /opt/code/
				# full clone
				git clone ${GIT_URL} ${CODENAME}
				# always make sure we are in the source root dir
				cd /opt/code/${CODENAME}
				# get the latest release tag
				#GIT_REL_TAG=$(git tag | sort -n | tail -1)
				git checkout tags/${SCVERSION}
			fi
			# compilation starts here, parameters later	
			echo -e "Starting the compilation process, stay tuned"
			cd /opt/code/${CODENAME} && ./autogen.sh
			./configure --enable-tests=no --with-incompatible-bdb \
			--enable-glibc-back-compat --with-gui=no \
			CFLAGS="-march=native" LIBS="-lcurl -lssl -lcrypto -lz"
			if make; then
				echo "compilation successful, running install and clean target"
				make install
			else
				echo "Damn, compilation failed. Exit!"	
				exit 1
			fi
	else
		echo "daemon already in place at ${NODE_DAEMON}, not compiling"	
	fi
}

function prepare_interfaces() {
	# vultr specific, needed to work
	sed -ie '/iface eth0 inet6 auto/s/^/#/' ${NETWORK_CONFIG}
    # move current config out of the way first
    cp ${NETWORK_CONFIG} ${NETWORK_CONFIG}.${DATE_STAMP}.bkp
    
	# create the additional ipv6 interfaces 
	for NUM in $(seq 1 ${SETUP_NODES_COUNT}); do
		echo "post-up ip -6 addr add ${IPV6_INT_BASE}::${NUM}/64 dev ${ETH_INTERFACE}" >> ${NETWORK_CONFIG}
		# also run it directly to avoid a reboot now
		ip -6 addr add ${IPV6_INT_BASE}::${NUM}/64 dev ${ETH_INTERFACE}
	done
	
	# restarting network services to enable the new interfaces
	service networking restart
}

function create_node_user() {
    # unpriv user acc
    echo "Adding new system user"
    adduser --disabled-password --gecos "" ${NODE_USER}
}

function create_node_dirs() {
    # individual data dirs for now to avoid problems
    echo "Creating masternode directories"
    mkdir -p ${NODE_CONF_BASE}
	for NUM in $(seq 1 ${SETUP_NODES_COUNT}); do
		echo "creating data directory ${NODE_DATA_BASE}/${CODENAME}${NUM}"
		mkdir -p ${NODE_DATA_BASE}/${CODENAME}${NUM}
	done    
}

function configure_firewall() {
	echo "Configuring firewall rules"
	# disallow everything except ssh and relevant zcash inbound ports	
	ufw default deny incoming
	ufw default allow outgoing
	ufw logging on
	ufw logging medium
	# This will only allow 6 connections every 30 seconds from the same IP address.
	ufw allow 22/tcp
	# Standard zcash port
	ufw allow ${NODE_INBOUND_PORT}/tcp
	ufw limit OpenSSH
	ufw --force enable	
}

function create_node_configuration() {
	# create one config file per masternode
	for NUM in $(seq 1 ${SETUP_NODES_COUNT}); do
	PASS=$(date | md5sum | cut -c1-24)
		echo "writing config file ${NODE_CONF_BASE}/${CODENAME}_n${NUM}.conf"
		cat > ${NODE_CONF_BASE}/${CODENAME}_n${NUM}.conf <<-EOF
			rpcuser=${CODENAME}rpc
			rpcpassword=${PASS}
			rpcallowip=127.0.0.1
			rpcport=444${NUM}
			server=1
			listen=1
			daemon=1
			logtimestamps=1
			mnconflock=0
			maxconnections=256
			gen=0
			masternode=1
			# add some doc references here
			masternodeprivkey=HERE_GOES_YOUR_MASTERNODE_KEY_FOR_MASTERNODE_${NUM}
			# add some examples here
			bind=[HERE_GOES_YOUR_MASTERNODE_IP_ADDRESS_FOR_MASTERNODE_${NUM}]:${NODE_INBOUND_PORT}		
		EOF
	done
}

function create_systemd_configuration() {
	# create one config file per masternode
	for NUM in $(seq 1 ${SETUP_NODES_COUNT}); do
	if [[ "${VERSION_ID}" = "15.10" ]] || [[ "${VERSION_ID}" = "16.04" ]]; then
		echo "writing config file ${SYSTEMD_CONF}/${CODENAME}_n${NUM}.service"
		cat > ${SYSTEMD_CONF}/${CODENAME}_n${NUM}.service <<-EOF
			[Unit]
			Description=${CODENAME} distributed currency daemon
			After=network.target
                 
			[Service]
			StandardOutput=syslog
			StandardError=syslog
			SyslogIdentifier=${CODENAME}
			User=${NODE_USER}
			Group=${NODE_USER}
         	
			Type=forking
			PIDFile=${NODE_DATA_BASE}/${CODENAME}${NUM}/${CODENAME}.pid
			ExecStart=${NODE_DAEMON} -daemon -pid=${NODE_DATA_BASE}/${CODENAME}${NUM}/${CODENAME}.pid -conf=${NODE_CONF_BASE}/${CODENAME}_n${NUM}.conf -datadir=${NODE_DATA_BASE}/${CODENAME}${NUM}

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
	elif [[ "${VERSION_ID}" = "14.04" ]]; then
		echo "adding startup command to rc.local"
		cat > /etc/rc.local <<-EOF
			# zcashd startup command
			su - ${NODE_USER} -c "${NODE_DAEMON} -daemon -pid=/var/lib/${CODENAME}/${CODENAME}.pid -conf=${NODE_CONF_BASE}/${CODENAME}.conf -datadir=${NODE_DATA_BASE}/${CODENAME}${NUM}"
			exit 0			
		EOF
	else
		echo "Nope"
		exit 1	
	fi
	done
}

function set_permissions() {
    echo "running chown -R ${NODE_USER}:${NODE_USER} ${NODE_CONF_BASE}/${CODENAME}_n*.conf ${NODE_DATA_BASE}/${CODENAME}*"
	chown -R ${NODE_USER}:${NODE_USER} ${NODE_CONF_BASE}/${CODENAME}_n*.conf ${NODE_DATA_BASE}/${CODENAME}*
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
tput sgr0
cat <<-EOF
    ${SCVERSION} for ${VERSION_ID}
	██████╗ ██╗██╗   ██╗██╗  ██╗
	██╔══██╗██║██║   ██║╚██╗██╔╝
	██████╔╝██║██║   ██║ ╚███╔╝ 
	██╔═══╝ ██║╚██╗ ██╔╝ ██╔██╗ 
	██║     ██║ ╚████╔╝ ██╔╝ ██╗
	╚═╝     ╚═╝  ╚═══╝  ╚═╝  ╚═╝
	feel free to donate PIVX for my work
	DQS4rk57bteJ42FSNSPpwqHUoNhx4ywfQc                    				
EOF
}

main() {
    showbanner
    check_distro
    swaphack
    install_packages
    build_from_source
    prepare_interfaces 
    create_node_user
    create_node_dirs
    configure_firewall      
    create_node_configuration
    create_systemd_configuration 
    set_permissions
    cleanup_after
    showbanner     
}

main "$@"