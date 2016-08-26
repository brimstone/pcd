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

E2FSPROGS_VERSION = 1.43.1

all: mkfs.ext4
	mkdir -p ${PWD}/root/sbin
	cp ${PWD}/out/sbin/mkfs.ext4 ${PWD}/root/sbin
	strip ${PWD}/root/sbin/mkfs.ext4
	tar cf ${PWD}/out.tar -C ${PWD}/root .

mkfs.ext4: ../download/e2fsprogs.tar.gz
	tar xf ../download/e2fsprogs.tar.gz
	mv e2fsprogs-${E2FSPROGS_VERSION} e2fsprogs
	cd e2fsprogs \
	&& ./configure --prefix=/ \
	&& make install DESTDIR=${PWD}/out

$(eval $(call cache,\
https://sourceforge.net/projects/e2fsprogs/files/e2fsprogs-${E2FSPROGS_VERSION}.tar.gz/download, \
../download/e2fsprogs.tar.gz, \
83dba1d96dfdba06f1ca0da6a77d539c22391b99fbd9bd733699689ca25dbebc))

clean:
	-rm -rf e2fsprogs*