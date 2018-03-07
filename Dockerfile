FROM brimstone/debian:sid

WORKDIR /buildroot

RUN package build-essential libncurses-dev wget python unzip rsync \
    bc gcc-multilib genisoimage git golang-go locales cpio gcc-5-plugin-dev \
    netcat-traditional kmod bison flex nasm upx ccache libelf-dev \
	gcc-7-plugin-dev libssl-dev \
 && locale-gen en_US.UTF-8

COPY . /buildroot/
