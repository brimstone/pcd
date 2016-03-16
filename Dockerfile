FROM brimstone/debian:sid

WORKDIR /buildroot

RUN apt-get update \
 && apt-get install -y build-essential libncurses-dev wget python unzip rsync \
    bc gcc-multilib genisoimage git golang-go locales cpio gcc-5-plugin-dev \
 && apt-get clean \
 && locale-gen en_US.UTF-8

ADD . /buildroot/
