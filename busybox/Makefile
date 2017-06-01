include ../util.mk
BUSYBOX_VERSION := 1.25.0

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

busybox: ../download/busybox.tar.bz2
	tar xf ../download/busybox.tar.bz2
	mv busybox-${BUSYBOX_VERSION} busybox
	cp busybox.config busybox/.config

$(eval $(call cache,\
http://busybox.net/downloads/busybox-${BUSYBOX_VERSION}.tar.bz2, \
../download/busybox.tar.bz2, \
5a0fe06885ee1b805fb459ab6aaa023fe4f2eccee4fb8c0fd9a6c17c0daca2fc))
