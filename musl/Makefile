include ../util.mk
MUSL_VERSION := 1.1.16

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
937185a5e5d721050306cf106507a006c3f1f86d86cd550024ea7be909071011))
