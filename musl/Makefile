include ../util.mk
MUSL_VERSION := 1.1.14

PWD = $(shell pwd)
JOBS = $(shell grep -c processor /proc/cpuinfo)


all: ../download/musl.tar.gz
	tar xf ../download/musl.tar.gz
	cd musl-* \
	&& ./configure --prefix="${PWD}/../include" --disable-shared \
	&& make -j${JOBS} \
	&& make install

$(eval $(call cache,\
http://www.musl-libc.org/releases/musl-${MUSL_VERSION}.tar.gz, \
../download/musl.tar.gz, \
35f6c00c84a6091bd5dab29eedde7508dae755ead92dcc0239f3677d1055b9b5))
