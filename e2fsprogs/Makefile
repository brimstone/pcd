include ../util.mk
JOBS = $(shell grep -c processor /proc/cpuinfo)
PWD = $(shell pwd)
CC = ${PWD}/../include/bin/musl-gcc -static
export CC
CFLAGS = -I${PWD}/build/include -L${PWD}/build/lib \
		-I${PWD}/../kernel/out/include
export CFLAGS
LDFLAGS = -static
export LDFLAGS

E2FSPROGS_VERSION = 1.45.5

all: mkfs.ext4
	mkdir -p ${PWD}/root/sbin
	cp ${PWD}/out/sbin/mkfs.ext4 ${PWD}/root/sbin
	cp ${PWD}/out/sbin/resize2fs ${PWD}/root/sbin
	cp ${PWD}/out/sbin/e2fsck.static ${PWD}/root/sbin/e2fsck
	strip ${PWD}/root/sbin/*
	tar cf ${PWD}/out.tar -C ${PWD}/root .

mkfs.ext4: ../download/e2fsprogs-${E2FSPROGS_VERSION}.tar.gz
	tar xf ../download/e2fsprogs-${E2FSPROGS_VERSION}.tar.gz
	mv e2fsprogs-${E2FSPROGS_VERSION} e2fsprogs
	cd e2fsprogs \
	&& ./configure --prefix=/ \
	&& rm -rf scrub \
	&& make -j${JOBS} install DESTDIR=${PWD}/out \
	&& cd e2fsck \
	&& make e2fsck.static \
	&& cp e2fsck.static ${PWD}/out/sbin

$(eval $(call cache,\
https://sourceforge.net/projects/e2fsprogs/files/e2fsprogs-${E2FSPROGS_VERSION}.tar.gz/download, \
../download/e2fsprogs-${E2FSPROGS_VERSION}.tar.gz, \
91e72a2f6fee21b89624d8ece5a4b3751a17b28775d32cd048921050b4760ed9)) #e2fsprogs

clean:
	-rm -rf e2fsprogs*
