include ../util.mk
MUSL_VERSION := 1.1.21

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
c742b66f6f49c9e5f52f64d8b79fecb5a0f6e0203fca176c70ca20f6be285f44))
