#!/bin/bash               				
#                   
# version 	0.62-alpha
# date    	2017-10-31
#
# function	masternode activation script
#			This scripts needs to be run as root
# 			to make services start persistent
#

# Exit immediately if a command exits with a non-zero status.
#
# This might cause problems e.g. using read to read a heredoc cause
# read to always return non-zero set -o errexit Treat unset variables
# as an error when substituting.
set -o nounset

# some usefule variables
declare -r TMP_FILE_PREFIX=${TMPDIR:-/tmp}/prog.$$
declare -r SCRIPTPATH=$( cd $(dirname ${BASH_SOURCE[0]}) > /dev/null; pwd -P )


function checkup() {
    # was the default config changed?
	if grep -q 'HERE_GOES_YOUR_MASTERNODE_KEY' "/etc/masternodes/innova_n1.conf"; then
	   echo "will not work!"
	   exit ${INVALID_OPTION}
	fi

}

function cleanup() {
    rm -f ${TMP_FILE_PREFIX}.*
    exit 100   
}


function usage() {
  cat <<EOF

Usage: $0

 TODO
EOF
}


# Single function
function main() {

  #the optional paramters string starting with ':' for silent errors
  local -r OPTS=':h'

  while builtin getopts ${OPTS} opt "${@}"; do
      
      case $opt in
	  h) usage ; exit 0
	     ;;
	  
	  \?)
	      echo ${opt} ${OPTIND} 'is an invalid option' >&2;
	      usage;
	      exit ${INVALID_OPTION}
	      ;;
	  
          :)
	      echo 'required argument not found for option -'${OPTARG} >&2;
	      usage;
	      exit ${INVALID_OPTION}
	      ;;
          *) echo "Too many options. Can not happen actually :)"
             ;;
 	  
      esac
  done
  

  cleanup

  exit 0
}

trap "cleanup; exit 1" 1 2 3 13 15

# this is the main executable function at end of script
main "$@"	