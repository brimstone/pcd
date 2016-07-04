BUSYBOX_VERSION := 1.25.0

PWD = $(shell pwd)
JOBS = $(shell grep -c processor /proc/cpuinfo)
CC = ${PWD}/../include/bin/musl-gcc
CC += -I${PWD}/../kernel/out/include

all: busybox
	cd busybox; make TARGET_ARCH="x86_64" HOSTCC="${CC} -static" CC="${CC} -static" V=1 install
	cp init busybox/_install
	rm busybox/_install/linuxrc
	mkdir -p busybox/_install/usr/share/udhcpc
	cp busybox/examples/udhcp/simple.script busybox/_install/usr/share/udhcpc/default.script
	tar -C busybox/_install -cf out.tar .

busybox: busybox.tar.bz2
	tar xf busybox.tar.bz2
	mv busybox-${BUSYBOX_VERSION} busybox
	cp busybox.config busybox/.config

busybox.tar.bz2:
	wget http://busybox.net/downloads/busybox-${BUSYBOX_VERSION}.tar.bz2 \
		--progress=bar:force:noscroll -O busybox.tar.bz2
