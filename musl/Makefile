MUSL_VERSION := 1.1.14

PWD = $(shell pwd)
JOBS = $(shell grep -c processor /proc/cpuinfo)


all: ../download/musl.tar.gz
	tar xf ../download/musl.tar.gz
	cd musl-* \
	&& ./configure --prefix="${PWD}/../include" --disable-shared \
	&& make -j${JOBS} \
	&& make install

../download/musl.tar.gz:
	wget http://www.musl-libc.org/releases/musl-1.1.14.tar.gz \
		--progress=bar:force:noscroll -O ../download/musl.tar.gz
