BUSYBOX_VERSION := 1.24.1

PWD = $(shell pwd)
JOBS = $(shell grep -c processor /proc/cpuinfo)
export CC = ${PWD}/../include/bin/musl-gcc


all: busybox.tar.bz2
	tar xf busybox.tar.bz2
	cd busybox-* \
	&& cp ../busybox.config .config \
	&& make install

busybox.tar.bz2:
	wget http://busybox.net/downloads/busybox-1.24.1.tar.bz2 \
	-O busybox.tar.bz2
