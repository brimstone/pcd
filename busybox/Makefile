BUSYBOX_VERSION := 1.25.0

PWD = $(shell pwd)
JOBS = $(shell grep -c processor /proc/cpuinfo)
CC = ${PWD}/../include/bin/musl-gcc
export CC


all: busybox.tar.bz2
	tar xf busybox.tar.bz2
	cp busybox.config busybox-${BUSYBOX_VERSION}/.config
	make -C busybox-${BUSYBOX_VERSION} install
	cp init busybox-${BUSYBOX_VERSION}/_install
	rm busybox-${BUSYBOX_VERSION}/_install/linuxrc
	tar -C busybox-${BUSYBOX_VERSION}/_install -cf out.tar .

busybox.tar.bz2:
	wget http://busybox.net/downloads/busybox-${BUSYBOX_VERSION}.tar.bz2 \
		--progress=bar:force:noscroll -O busybox.tar.bz2
