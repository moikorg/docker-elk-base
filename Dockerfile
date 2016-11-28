# Pull base image
FROM debian:latest
#FROM docker pull resin/rpi-raspbian

MAINTAINER Michael Mäder <mike@moik.org>


# install plugin dependencies
RUN set -ex \
    && apt-get update && apt-get upgrade -y --no-install-recommends
RUN set -ex \
    &&apt-get install -y --no-install-recommends \
        ca-certificates \
        wget \
        libzmq3 \
        oracle-java8-jdk \
#        openjdk-7-jdk \
    && rm -rf /var/lib/apt/lists/* 

# grab gosu for easy step-down from root
ENV GOSU_VERSION 1.7
RUN set -x \
  && dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" \
  && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch" \
  && wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc" \
  && export GNUPGHOME="$(mktemp -d)" \
  && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
  && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
  && rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
  && chmod +x /usr/local/bin/gosu \
  && gosu nobody true
