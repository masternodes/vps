#
# Dockerfile for a BLOCK servicenode
# usage: docker run marsmensch/servicenode-block:latest
# 
# how to work with the container
# 
# 1) build the container (checkout desired git revision first)
# docker build -t "marsmensch/servicenode-block:latest" -f docker/Dockerfile_BLOCK .
#
# 2) start the container 
# docker run -p ${NODE_PORT}:${NODE_PORT}  -v $(PWD)/config/block/blockd.conf:/opt/data "marsmensch/servicenode-block:latest"
# 
# 3) start the container interactively 
# docker run --interactive --tty --entrypoint=/bin/bash "marsmensch/servicenode-block:latest"
#
# 4) standard help
# docker run -v $(PWD)/config/block:/opt/data "marsmensch/servicenode-block:latest"

FROM                 ubuntu:xenial
MAINTAINER 			 Florian Maier <contact@marsmenschen.com>

ENV CONTAINER_USER   servicenode
ENV PROJECT          blocknet
ENV GIT_URL          git://github.com/atcsecure/blocknet.git
ENV SECP_URL         git://github.com/bitcoin-core/secp256k1.git
ENV SVC_VERSION      xbridge-new-2
ENV HOME_DIR         /usr/local/bin
ENV NODE_PORT        31337
ENV REFRESHED_AT     2017-07-28

# add unprivileged user
RUN adduser --shell /bin/bash --disabled-password \
    --disabled-login --gecos '' ${CONTAINER_USER}

# install system packages and compile
RUN apt-get update \
    && apt-get -y upgrade \
    && apt-get -y install --no-install-recommends build-essential libtool autotools-dev \
    libcurl4-openssl-dev libboost-all-dev libssl-dev libdb++-dev make autoconf automake \
    libtool git apt-utils libprotobuf-dev pkg-config libboost-filesystem-dev libboost-chrono-dev \
    libevent-dev libboost-program-options-dev libgmp-dev libboost-test-dev libboost-thread-dev \
    && mkdir -p /opt/code/ && cd /opt/code/ \
    && git clone ${SECP_URL} && cd secp256k1 && ./autogen.sh \
    && ./configure --enable-module-recovery && make && make install \ 
    && cd /opt/code/ && git clone ${GIT_URL} ${PROJECT} \
    && cd /opt/code/${PROJECT} && git checkout ${SVC_VERSION} \
    && cd src && make -f makefile.unix USE_UPNP= \
    && cp blocknetd /usr/local/bin/blocknetd && ldconfig \
    && apt -y autoremove \
    && rm -rf /opt/code \
    && rm -rf /var/lib/apt/lists/*

# EXPOSE the masternode port
EXPOSE ${NODE_PORT} 

#RUN chown -R ${CONTAINER_USER} ${HOME_DIR}
#USER ${CONTAINER_USER}
#WORKDIR ${HOME_DIR}

# start command
CMD ["/usr/local/bin/blocknetd", "--help"]