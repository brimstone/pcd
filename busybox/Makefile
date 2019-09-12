include ../util.mk
BUSYBOX_VERSION := 1.31.0

PWD = $(shell pwd)
JOBS = $(shell grep -c processor /proc/cpuinfo)
CC = ${PWD}/../include/bin/musl-gcc
CC += -I${PWD}/../kernel/out/include

all: busybox
	cd busybox; make TARGET_ARCH="x86_64" HOSTCC="${CC} -static" CC="${CC} -static" V=1 install
	cp init busybox/_install
	rm busybox/_install/linuxrc
	cp udhcpc.script busybox/_install/bin/udhcpc.script
	chmod 755 busybox/_install/bin/udhcpc.script
	tar -C busybox/_install -cf out.tar .

busybox: ../download/busybox-${BUSYBOX_VERSION}.tar.bz2
	tar xf ../download/busybox-${BUSYBOX_VERSION}.tar.bz2
	mv busybox-${BUSYBOX_VERSION} busybox
	cp busybox.config busybox/.config

$(eval $(call cache,\
http://busybox.net/downloads/busybox-${BUSYBOX_VERSION}.tar.bz2, \
../download/busybox-${BUSYBOX_VERSION}.tar.bz2, \
0e4925392fd9f3743cc517e031b68b012b24a63b0cf6c1ff03cce7bb3846cc99)) #busybox
