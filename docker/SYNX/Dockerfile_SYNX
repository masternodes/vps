#
# Dockerfile for a SYNX masternode
# usage: docker run marsmensch/masternode-dash:latest
# 
# how to work with the container
# 
# 1) build the container (checkout desired git revision first)
# docker build -t "marsmensch/masternode-synx:latest" -f docker/Dockerfile_SYNX .
#
# 2) start the container 
# docker run -p ${NODE_PORT}:${NODE_PORT} -v $(PWD)/config/synx/syndicated.conf:/opt/data "marsmensch/masternode-synx:latest"
# 
# 3) start the container interactively 
# docker run --interactive --tty --entrypoint=/bin/bash "marsmensch/masternode-synx:latest"
#
# 4) standard help
# docker run -v $(PWD)/config/sib:/opt/data "marsmensch/masternode-synx:latest"

FROM                 ubuntu:xenial
MAINTAINER 			 Florian Maier <contact@marsmenschen.com>

ENV CONTAINER_USER   masternode
ENV PROJECT          syndicate
ENV GIT_URL          git://github.com/SyndicateLabs/SyndicateQT.git
ENV SVC_VERSION      tags/v1.0.1.8
ENV HOME_DIR         /usr/local/bin
ENV NODE_PORT        9999
ENV REFRESHED_AT     2017-07-25

# add unprivileged user
RUN adduser --shell /bin/bash --disabled-password \
    --disabled-login --gecos '' ${CONTAINER_USER}

# install system packages and compile
RUN apt-get update \
    && apt-get -y upgrade \
    && apt-get -y install --no-install-recommends build-essential protobuf-compiler \
    automake libcurl4-openssl-dev libboost-all-dev libssl-dev libdb++-dev \
    make autoconf libtool git apt-utils libprotobuf-dev pkg-config \
    libcurl3-dev libudev-dev libqt4-dev libqrencode-dev bsdmainutils libqjson-dev libqjson0  \
    libevent-dev libgmp-dev pkg-config \
    && mkdir -p /opt/code/ && cd /opt/code/ && git clone ${GIT_URL} ${PROJECT} \
    && cd /opt/code/${PROJECT} && git checkout ${SVC_VERSION} \
    && cd src && make -f makefile.unix USE_UPNP= && cp Syndicated /usr/local/bin/syndicated \
	# remove unneeded stuff
	&& apt-get -y remove build-essential make autoconf libtool git apt-utils \	
    && apt -y autoremove \
    && rm -rf /opt/code \
    && rm -rf /var/lib/apt/lists/*

# add entrypoint 
ADD docker_entrypoint.sh /usr/local/bin/   

# EXPOSE the masternode port
EXPOSE ${NODE_PORT} 

RUN chown -R ${CONTAINER_USER} ${HOME_DIR}
USER ${CONTAINER_USER}
WORKDIR ${HOME_DIR}

# start command
ENTRYPOINT ["/usr/local/bin/docker_entrypoint.sh"]