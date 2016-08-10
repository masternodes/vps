#!/bin/bash
# ▓█████▄  ▄▄▄       ██▀███   ██ ▄█▀ ███▄    █ ▓█████▄▄▄█████▓
# ▒██▀ ██▌▒████▄    ▓██ ▒ ██▒ ██▄█▒  ██ ▀█   █ ▓█   ▀▓  ██▒ ▓▒
# ░██   █▌▒██  ▀█▄  ▓██ ░▄█ ▒▓███▄░ ▓██  ▀█ ██▒▒███  ▒ ▓██░ ▒░
# ░▓█▄   ▌░██▄▄▄▄██ ▒██▀▀█▄  ▓██ █▄ ▓██▒  ▐▌██▒▒▓█  ▄░ ▓██▓ ░ 
# ░▒████▓  ▓█   ▓██▒░██▓ ▒██▒▒██▒ █▄▒██░   ▓██░░▒████▒ ▒██▒ ░ 
#  ▒▒▓  ▒  ▒▒   ▓▒█░░ ▒▓ ░▒▓░▒ ▒▒ ▓▒░ ▒░   ▒ ▒ ░░ ▒░ ░ ▒ ░░   
#  ░ ▒  ▒   ▒   ▒▒ ░  ░▒ ░ ▒░░ ░▒ ▒░░ ░░   ░ ▒░ ░ ░  ░   ░    
#  ░ ░  ░   ░   ▒     ░░   ░ ░ ░░ ░    ░   ░ ░    ░    ░      
#    ░          ░  ░   ░     ░  ░            ░    ░  ░        
#  ░                        
#
# version 	0.2-alpha
# date    	2016-08-10
# function	masternode setup script
#			This scripts needs to be run as root
# 			to make services start persistent
#
# Twitter 	@marsmensch
#
# tips
# BTC  1PboFDkBsW2i968UnehWwcSrM9Djq5LcLB
# DNET DBGBYLz484dWBb5wtk5gFVdJ8rGFfcob7R
# SYNX SSKYwMhQQt9DcWozt7zA1tR3DmRuw1gT6b
#
#
SETUP_MNODES_COUNT=3

########################################
# Dont change anything here if unsure!
########################################
# only one masternode by default
SETUP_MNODES_COUNT=${SETUP_MNODES_COUNT:-1}
MNODE_INBOUND_PORT=${MNODE_INBOUND_PORT:-9999}
SSH_INBOUND_PORT=${SSH_INBOUND_PORT:-22}
MNODE_CONF_BASE=${MNODE_CONF_BASE:-/etc/masternodes}
MNODE_DATA_BASE=${MNODE_DATA_BASE:-/var/lib/masternodes}
MNODE_USER=${MNODE_USER:-masternode}
MNODE_HELPER="/usr/local/bin/restart_masternodes.sh"
MNODE_DAEMON=${MNODE_DAEMON:-/usr/local/bin/darknetd}

# Git related stuff
GIT_PROJECT=darknet
GIT_URL=git://github.com/Darknet-Crypto/Darknet.git
PROG_VERSION=master

# DISTRO specific stuff
SYSTEMD_CONF=${SYSTEMD_CONF:-/etc/systemd/system}
NETWORK_CONFIG=${NETWORK_CONFIG:-/etc/network/interfaces}
ETH_INTERFACE=${ETH_INTERFACE:-ens3}

# Useful variables
DATE_STAMP="$(date +%y-%m-%d-%s)"
# im an not very proud of this
IPV6_INT_BASE="$(ip -6 addr | grep inet6 | awk -F '[ \t]+|/' '{print $3}' | grep -v ^::1 | grep -v ^fe80 | cut -f1-4 -d':')"
# a way to override
#IPV6_INT_BASE="2001:19f0:6c01:5e::"

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
	echo "Package installation!"
	apt-get -qq update
	apt-get -qqy -o=Dpkg::Use-Pty=0 install build-essential protobuf-compiler \
    automake libcurl4-openssl-dev libboost-all-dev libssl-dev libdb++-dev \
    make autoconf automake libtool git apt-utils libprotobuf-dev pkg-config \
    libcurl3-dev libudev-dev libqt4-dev libqrencode-dev bsdmainutils
}

function swaphack() { 
	# needed because ant servers are ants
	rm -f /var/swap.img
	dd if=/dev/zero of=/var/swap.img bs=1024k count=3000
	chmod 0600 /var/swap.img
	mkswap /var/swap.img
	swapon /var/swap.img	
}

function build_mn_from_source() {
	# daemon not found compile it
	if [ ! -f ${MNODE_DAEMON} ]; then
		# if code directory does not exists, we create it clone the src
		if [ ! -d /opt/code/${GIT_PROJECT} ]; then
			mkdir -p /opt/code && cd /opt/code
			git clone ${GIT_URL} ${GIT_PROJECT}
		fi	
		# compilation starts here, parameters later	
		echo -e "Starting the compilation process, stay tuned"
		cd /opt/code/${GIT_PROJECT} && ./autogen.sh
		./configure --enable-tests=no --with-incompatible-bdb CFLAGS="-march=native" LIBS="-lcurl -lssl -lcrypto -lz"
		if make; then
			echo "compilation successful, running install and clean target"
			make install
		else
			echo "Damn, compilation failed. Exit!"	
			exit 1
		fi
	else
		echo "daemon already in place at ${MNODE_DAEMON}, not compiling"	
	fi
}

function install_mn_packages() {
	# not yet included, testing
	# packages install to /usr/bin, src to /usr/local/bin
	apt-add-repository ppa:shaun-mcbride/darknet
	apt-get update
	apt-get install darknetd
	apt-get install darknet-cli
}

function prepare_mn_interfaces() {
	# vultr specific, needed to work
	sed -ie '/iface eth0 inet6 auto/s/^/#/' ${NETWORK_CONFIG}
    # move current config out of the way first
    cp ${NETWORK_CONFIG} ${NETWORK_CONFIG}.${DATE_STAMP}.bkp
    
	# create the additional ipv6 interfaces 
	for NUM in $(seq 1 ${SETUP_MNODES_COUNT}); do
		echo "post-up ip -6 addr add ${IPV6_INT_BASE}::${NUM}/64 dev ${ETH_INTERFACE}" >> ${NETWORK_CONFIG}
		# also run it directly to avoid a reboot now
		ip -6 addr add ${IPV6_INT_BASE}::${NUM}/64 dev ${ETH_INTERFACE}
	done
	
	# restarting network services to enable the new interfaces
	service networking restart
}

function create_mn_user() {
    # our new mnode unpriv user acc
    echo "Adding new system user"
    adduser --disabled-password --gecos "" ${MNODE_USER}
}

function create_mn_dirs() {
    # individual data dirs for now to avoid problems
    echo "Creating masternode directories"
    mkdir -p ${MNODE_CONF_BASE}
	for NUM in $(seq 1 ${SETUP_MNODES_COUNT}); do
		echo "creating data directory ${MNODE_DATA_BASE}/${GIT_PROJECT}${NUM}"
		mkdir -p ${MNODE_DATA_BASE}/${GIT_PROJECT}${NUM}
	done    
}

function configure_firewall() {
    echo "Configuring firewall rules"
	# disallow everything except ssh and masternode inbound ports
	ufw default deny
	ufw logging on
	ufw allow ${SSH_INBOUND_PORT}/tcp
	ufw allow ${MNODE_INBOUND_PORT}/tcp
	# This will only allow 6 connections every 30 seconds from the same IP address.
	ufw limit OpenSSH	
	ufw --force enable 
}

function create_mn_configuration() {
	# create one config file per masternode
	for NUM in $(seq 1 ${SETUP_MNODES_COUNT}); do
	PASS=$(date | md5sum | cut -c1-24)
		echo "writing config file ${MNODE_CONF_BASE}/${GIT_PROJECT}_n${NUM}.conf"
		cat > ${MNODE_CONF_BASE}/${GIT_PROJECT}_n${NUM}.conf <<-EOF
			rpcuser=${GIT_PROJECT}rpc
			rpcpassword=${PASS}
			rpcallowip=127.0.0.1
			rpcport=444${NUM}
			server=1
			listen=1
			daemon=1
			bind=[${IPV6_INT_BASE}::${NUM}]:${MNODE_INBOUND_PORT}
			logtimestamps=1
			mnconflock=0
			maxconnections=256
			gen=0
			masternode=1
			masternodeprivkey=HERE_GOES_YOUR_MASTERNODE_KEY_FOR_MASTERNODE_${NUM}
			addnode=108.61.151.69
			addnode=173.245.158.8
			addnode=coin-server.com			
		EOF
	done
}

function create_systemd_configuration() {
	# create one config file per masternode
	for NUM in $(seq 1 ${SETUP_MNODES_COUNT}); do
	PASS=$(date | md5sum | cut -c1-24)
		echo "writing config file ${SYSTEMD_CONF}/${GIT_PROJECT}_n${NUM}.service"
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
▓█████▄  ▄▄▄       ██▀███   ██ ▄█▀ ███▄    █ ▓█████▄▄▄█████▓
▒██▀ ██▌▒████▄    ▓██ ▒ ██▒ ██▄█▒  ██ ▀█   █ ▓█   ▀▓  ██▒ ▓▒
░██   █▌▒██  ▀█▄  ▓██ ░▄█ ▒▓███▄░ ▓██  ▀█ ██▒▒███  ▒ ▓██░ ▒░
░▓█▄   ▌░██▄▄▄▄██ ▒██▀▀█▄  ▓██ █▄ ▓██▒  ▐▌██▒▒▓█  ▄░ ▓██▓ ░ 
░▒████▓  ▓█   ▓██▒░██▓ ▒██▒▒██▒ █▄▒██░   ▓██░░▒████▒ ▒██▒ ░ 
 ▒▒▓  ▒  ▒▒   ▓▒█░░ ▒▓ ░▒▓░▒ ▒▒ ▓▒░ ▒░   ▒ ▒ ░░ ▒░ ░ ▒ ░░   
 ░ ▒  ▒   ▒   ▒▒ ░  ░▒ ░ ▒░░ ░▒ ▒░░ ░░   ░ ▒░ ░ ░  ░   ░    
 ░ ░  ░   ░   ▒     ░░   ░ ░ ░░ ░    ░   ░ ░    ░    ░      
   ░          ░  ░   ░     ░ (@marsmensch)2016  ░  ░        
 ░                      				
EOF
}

function final_call() {
	# note outstanding tasks that need manual work
	echo "There is still work to do in the configuration templates."
	echo "These are located at ${MNODE_CONF_BASE}, one per masternode."
	echo "Add your masternode private keys now."
	echo "eg in /etc/masternodes/darknet_n1.conf"	
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
    create_systemd_configuration 
    set_permissions
    cleanup_after
    final_call
    showbanner     
}

main "$@"
