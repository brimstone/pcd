FROM brimstone/debian:sid

WORKDIR /buildroot

RUN package build-essential libncurses-dev wget python unzip rsync \
    bc gcc-multilib genisoimage git golang-go locales cpio \
    netcat-traditional kmod bison flex nasm upx ccache libelf-dev \
    gcc-7-plugin-dev libssl-dev squashfs-tools \
 && locale-gen en_US.UTF-8

COPY . /buildroot/
