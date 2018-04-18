#
# Dockerfile for a SmartCash masternode
# usage: docker run notatestuser/masternode-smart:latest
#
# how to work with the container
#
# 1) build the container (checkout desired git revision first)
# docker build -t "notatestuser/masternode-smart:latest" -f docker/SMART/Dockerfile_SMART .
#
# 2) start the container
# docker run -p ${NODE_PORT}:${NODE_PORT} -v $(PWD)/data:/opt/smartcash/data "notatestuser/masternode-smart:latest"
#
# 3) start the container interactively
# docker run --interactive --tty --entrypoint=/bin/bash "notatestuser/masternode-smart:latest"

FROM         ubuntu:xenial
MAINTAINER   Luke Plaster <me@lukep.org>

ENV CONTAINER_USER   masternode
ENV PROJECT          smart
ENV GIT_URL          git://github.com/smartcash/smartcash
ENV SVC_VERSION      1.1.0rc4-2xenial3
ENV HOME_DIR         /opt/smartcash
ENV DATA_DIR         /opt/smartcash/data
ENV NODE_PORT        9678
ENV REFRESHED_AT     2018-01-11

# add unprivileged user
RUN adduser --shell /bin/bash --disabled-password \
    --disabled-login --gecos '' ${CONTAINER_USER}

# install packages
RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get install -y software-properties-common python-software-properties && \
    add-apt-repository ppa:smartcash/ppa && \
    apt-get update && \
    apt-get install -y smartcashd=$SVC_VERSION && \
    apt-get purge -y python-software-properties && \
    apt -y autoremove && \
    rm -rf /var/lib/apt/*

# init home and data dirs
RUN mkdir -p ${HOME_DIR} && \
    mkdir -p ${DATA_DIR} && \
    chown -R ${CONTAINER_USER} ${HOME_DIR} && \
    chown -R ${CONTAINER_USER} ${DATA_DIR}

# EXPOSE the masternode port
EXPOSE ${NODE_PORT}

USER ${CONTAINER_USER}
WORKDIR ${HOME_DIR}

ENTRYPOINT ["sh", "-c", "smartcashd -conf=$DATA_DIR/smart.conf -datadir=$DATA_DIR"]
