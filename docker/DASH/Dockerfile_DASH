#
# Dockerfile for a DASH masternode
# usage: docker run marsmensch/masternode-dash:latest
# 
# how to work with the container
# 
# 1) build the container (checkout desired git revision first)
# docker build -t "marsmensch/masternode-dash:latest" -f docker/Dockerfile_DASH .
#
# 2) start the container  
# docker run -p ${NODE_PORT}:${NODE_PORT} -v $(PWD)/config/dash/dashd.conf:/opt/data "marsmensch/masternode-dash:latest"
# 
# 3) start the container interactively 
# docker run --interactive --tty --entrypoint=/bin/bash "marsmensch/masternode-dash:latest"
#
# 4) standard help
# docker run -v $(PWD)/config/dash:/opt/data "marsmensch/masternode-dash:latest"

FROM                 ubuntu:xenial
MAINTAINER 			 Florian Maier <contact@marsmenschen.com>

ENV CONTAINER_USER   masternode
ENV PROJECT          dash
ENV GIT_URL          git://github.com/dashpay/dash.git
ENV SVC_VERSION      tags/v0.13.0.0
ENV HOME_DIR         /usr/local/bin
ENV NODE_PORT        9999
ENV REFRESHED_AT     2017-07-25

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
    && apt-get -y remove build-essential \
	libboost-all-dev libboost-atomic-dev libboost-atomic1.58-dev \
	libboost-chrono-dev libboost-chrono1.58-dev \
	libboost-context-dev libboost-context1.58-dev  \
	libboost-coroutine-dev libboost-coroutine1.58-dev \
	libboost-date-time-dev libboost-date-time1.58-dev \
	libboost-dev libboost-exception-dev libboost-exception1.58-dev \
	libboost-filesystem-dev libboost-filesystem1.58-dev \
	libboost-graph-dev libboost-graph-parallel-dev \
	libboost-graph-parallel1.58-dev libboost-graph1.58-dev \
	libboost-iostreams-dev libboost-iostreams1.58-dev libboost-locale-dev \
	libboost-locale1.58-dev libboost-log-dev \
	libboost-log1.58-dev libboost-log1.58.0 libboost-math-dev \
	libboost-math1.58-dev libboost-math1.58.0 libboost-mpi-dev \
	libboost-mpi-python-dev libboost-mpi-python1.58-dev \
	libboost-mpi1.58-dev libboost-program-options-dev \
	libboost-program-options1.58-dev libboost-python-dev  \
	libboost-python1.58-dev libboost-random-dev libboost-random1.58-dev \
	libboost-regex-dev libboost-regex1.58-dev libboost-serialization-dev  \
	libboost-serialization1.58-dev libboost-signals-dev libboost-signals1.58-dev \
	libboost-system-dev libboost-system1.58-dev libboost-test-dev libboost-test1.58-dev \
	libboost-thread-dev libboost-thread1.58-dev libboost-timer-dev libboost-timer1.58-dev \
	libboost-tools-dev libboost-wave-dev libboost-wave1.58-dev libboost1.58-dev \
	libboost1.58-tools-dev libc6-dev libdb5.3++-dev libdb5.3-dev libevent-dev \
	libexpat1-dev libgmp-dev libibverbs-dev libicu-dev libltdl-dev libnuma-dev \
	libopenmpi-dev libprotobuf-dev libpython-dev libpython2.7-dev libssl-dev \
	mpi-default-dev python-dev python2.7-dev zlib1g-dev \  
    && apt -y autoremove \
    && rm -rf /opt/code \
    && rm -rf /var/lib/apt/lists/*

# EXPOSE the masternode port
EXPOSE ${NODE_PORT} 

RUN chown -R ${CONTAINER_USER} ${HOME_DIR}
USER ${CONTAINER_USER}
WORKDIR ${HOME_DIR}

# start command
CMD ["/usr/local/bin/dashd", "--help"]