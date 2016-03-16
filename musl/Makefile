MUSL_VERSION := 1.1.14

PWD = $(shell pwd)
JOBS = $(shell grep -c processor /proc/cpuinfo)


all: musl.tar.gz
	tar xf musl.tar.gz
	cd musl-* \
	&& ./configure --prefix="${PWD}/../include" \
	&& make -j${JOBS} \
	&& make install

musl.tar.gz:
	wget http://www.musl-libc.org/releases/musl-1.1.14.tar.gz \
	-O musl.tar.gz
