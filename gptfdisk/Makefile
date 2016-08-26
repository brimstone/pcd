include ../util.mk
JOBS = $(shell grep -c processor /proc/cpuinfo)
PWD = $(shell pwd)
CC = ${PWD}/../include/bin/musl-gcc
CC += -I${PWD}/../kernel/out/include
export CC
CFLAGS = -I${PWD}/build/include
export CFLAGS
CXXFLAGS = -I${PWD}/build/include
export CXXFLAGS
LDFLAGS = -static -L${PWD}/build/lib
export LDFLAGS

GPTFDISK_VERSION := 1.0.1
POPT_VERSION := 1.16
LIBUUID_VERSION := 1.0.3

all: gptfdisk
	mkdir -p ${PWD}/root/sbin
	cp ${PWD}/gptfdisk/sgdisk ${PWD}/root/sbin
	strip ${PWD}/root/sbin/sgdisk
	tar cf ${PWD}/out.tar -C ${PWD}/root .

gptfdisk: ../download/gptfdisk.tar.gz popt libuuid
	tar xf ../download/gptfdisk.tar.gz
	mv gptfdisk-${GPTFDISK_VERSION} gptfdisk
	cd gptfdisk \
	&& make \
		DESTDIR="${PWD}/out" \
		sgdisk


$(eval $(call cache, \
https://sourceforge.net/projects/gptfdisk/files/gptfdisk/${GPTFDISK_VERSION}/gptfdisk-${GPTFDISK_VERSION}.tar.gz/download, \
../download/gptfdisk.tar.gz, \
864c8aee2efdda50346804d7e6230407d5f42a8ae754df70404dd8b2fdfaeac7))

libuuid: ../download/libuuid.tar.gz
	tar xf ../download/libuuid.tar.gz
	mv libuuid-1.0.3 libuuid
	cd libuuid \
	&& ./configure --prefix=/ \
	&& make install DESTDIR=${PWD}/build

$(eval $(call cache,\
https://sourceforge.net/projects/libuuid/files/libuuid-${LIBUUID_VERSION}.tar.gz/download, \
../download/libuuid.tar.gz, \
46af3275291091009ad7f1b899de3d0cea0252737550e7919d17237997db5644))


popt: ../download/popt.tar.gz
	tar xf ../download/popt.tar.gz
	mv popt-${POPT_VERSION} popt
	cd popt \
	&& ./configure \
		--prefix=/ \
	&& make \
		DESTDIR="${PWD}/build" \
		install


$(eval $(call cache, \
http://rpm5.org/files/popt/popt-${POPT_VERSION}.tar.gz, \
../download/popt.tar.gz, \
e728ed296fe9f069a0e005003c3d6b2dde3d9cad453422a10d6558616d304cc8))

clean:
	-rm -rf libuuid*
	-rm -rf popt*
	-rm -rf gptdisk*
	-rm -rf build
