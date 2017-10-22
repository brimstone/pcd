include ../util.mk
MUSL_VERSION := 1.1.17

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
c8aa51c747a600704bed169340bf3e03742ceee027ea0051dd4b6cc3c5f51464))
