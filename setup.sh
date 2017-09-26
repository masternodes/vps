#!/bin/bash -eux

# Useful variables
DATE_STAMP="$(date +%y-%m-%d-%s)"

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

function install_base_packages() {
	echo "Package installation!"
	apt-get -qq update
	apt-get -qqy -o=Dpkg::Use-Pty=0 install curl wget pwgen jq httpie sl tmux
}

main() {
    #showbanner
    check_distro
    install_base_packages    
}

main "$@"