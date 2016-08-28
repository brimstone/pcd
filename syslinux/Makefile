include ../util.mk
JOBS = $(shell grep -c processor /proc/cpuinfo)
PWD = $(shell pwd)
CC = ${PWD}/../include/bin/musl-gcc
export CC
CFLAGS = -I${PWD}/build/include
export CFLAGS
LDFLAGS = -static -L${PWD}/build/lib
export LDFLAGS

SYSLINUX_VERSION := 6.04
SYSLINUX_PATCH := -pre1
LIBUUID_VERSION := 1.0.3

all: syslinux
	mkdir -p ${PWD}/root/sbin
	mkdir -p ${PWD}/root/share/syslinux
	cp ${PWD}/syslinux/bios/extlinux/extlinux ${PWD}/root/sbin
	cp ${PWD}/syslinux/bios/mbr/gptmbr.bin ${PWD}/root/share/syslinux
	strip ${PWD}/root/sbin/extlinux
	tar cf ${PWD}/out.tar -C ${PWD}/root .

syslinux: ../download/syslinux.tar.xz libuuid
	tar xf ../download/syslinux.tar.xz
	mv syslinux-${SYSLINUX_VERSION}${SYSLINUX_PATCH} syslinux
	cd syslinux \
	&& patch -p1 < ../CFLAGS.patch \
	&& make -j${JOBS} \
		DESTDIR="${PWD}/out"

$(eval $(call cache, \
https://www.kernel.org/pub/linux/utils/boot/syslinux/Testing/${SYSLINUX_VERSION}/syslinux-${SYSLINUX_VERSION}${SYSLINUX_PATCH}.tar.xz, \
../download/syslinux.tar.xz, \
3f6d50a57f3ed47d8234fd0ab4492634eb7c9aaf7dd902f33d3ac33564fd631d))

libuuid: ../download/libuuid.tar.gz
	tar xf ../download/libuuid.tar.gz
	mv libuuid-1.0.3 libuuid
	cd libuuid \
	&& ./configure --prefix=/ \
	&& make -j${JOBS} install DESTDIR=${PWD}/build

$(eval $(call cache,\
https://sourceforge.net/projects/libuuid/files/libuuid-${LIBUUID_VERSION}.tar.gz/download, \
../download/libuuid.tar.gz, \
46af3275291091009ad7f1b899de3d0cea0252737550e7919d17237997db5644))
