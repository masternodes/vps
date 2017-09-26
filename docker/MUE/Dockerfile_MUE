#
# Dockerfile for a MUE masternode
# usage: docker run marsmensch/masternode-mue:latest
# 
# how to work with the container
# 
# 1) build the container (checkout desired git revision first)
# docker build -t "marsmensch/masternode-mue:latest" -f docker/Dockerfile_MUE .
#
# 2) start the container  
# docker run -p ${NODE_PORT}:${NODE_PORT} -v $(PWD)/config/dash/mued.conf:/opt/data "marsmensch/masternode-mue:latest"
# 
# 3) start the container interactively 
# docker run --interactive --tty --entrypoint=/bin/bash "marsmensch/masternode-mue:latest"
#
# 4) standard help
# docker run -v $(PWD)/config/sib:/opt/data "marsmensch/masternode-sib:latest"

FROM                 ubuntu:xenial
MAINTAINER 			 Florian Maier <contact@marsmenschen.com>

ENV CONTAINER_USER   masternode
ENV PROJECT          monetaryunit
ENV GIT_URL          git://github.com/MonetaryUnit/MUE-Src.git
ENV SVC_VERSION      tags/v1.0.10.8
ENV HOME_DIR         /usr/local/bin
ENV NODE_PORT        19683
ENV REFRESHED_AT     2017-07-26

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
    && mkdir -p /opt/code/ && cd /opt/code/ && git clone ${GIT_URL} ${PROJECT} \
    && cd /opt/code/${PROJECT} && git checkout ${SVC_VERSION} \
    && ./autogen.sh && ./configure --enable-tests=no --with-incompatible-bdb \
	--enable-glibc-back-compat --with-gui=no \
    CFLAGS="-march=native" LIBS="-lcurl -lssl -lcrypto -lz" \
    && make && make install \
    # remove unneeded stuff
	&& apt-get -y remove build-essential make autoconf libtool git apt-utils \	
    && apt -y autoremove \
    && rm -rf /opt/code \
    && rm -rf /var/lib/apt/lists/*

# EXPOSE the masternode port
EXPOSE ${NODE_PORT} 

RUN chown -R ${CONTAINER_USER} ${HOME_DIR}
USER ${CONTAINER_USER}
WORKDIR ${HOME_DIR}

# start command
ENTRYPOINT ["screen", "-A", "-m", "-d", "-S", "daemon", "/usr/local/bin/arcticcoind"]  
CMD ["--help"]