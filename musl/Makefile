include ../util.mk
MUSL_VERSION := 1.1.23

PWD = $(shell pwd)
JOBS = $(shell grep -c processor /proc/cpuinfo)


all: ../download/musl-${MUSL_VERSION}.tar.gz
	tar xf ../download/musl-${MUSL_VERSION}.tar.gz
	cd musl-* \
	&& ./configure --prefix="${PWD}/../include" --disable-shared \
	&& make -j${JOBS} \
	&& make install

$(eval $(call cache,\
http://www.musl-libc.org/releases/musl-${MUSL_VERSION}.tar.gz, \
../download/musl-${MUSL_VERSION}.tar.gz, \
8a0feb41cef26c97dde382c014e68b9bb335c094bbc1356f6edaaf6b79bd14aa)) #musl
