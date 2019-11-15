include ../util.mk
MUSL_VERSION := 1.1.24

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
1370c9a812b2cf2a7d92802510cca0058cc37e66a7bedd70051f0a34015022a3)) #musl
