FROM brimstone/debian:sid

WORKDIR /buildroot

RUN package build-essential libncurses-dev wget python2 unzip rsync \
    bc gcc-multilib genisoimage git golang-go locales cpio \
    netcat-traditional kmod bison flex nasm upx ccache libelf-dev \
    gcc-9-plugin-dev libssl-dev squashfs-tools \
 && locale-gen en_US.UTF-8

RUN wget https://github.com/brimstone/notminisign/releases/download/0.0.1/notminisign_linux_amd64 -O /usr/local/bin/notminisign \
 && chmod 755 /usr/local/bin/notminisign

COPY . /buildroot/
