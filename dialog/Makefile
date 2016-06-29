JOBS = $(shell grep -c processor /proc/cpuinfo)

PWD = $(shell pwd)

CC = ${PWD}/../include/bin/musl-gcc
export CC
CFLAGS = -I ${PWD}/build/include -L ${PWD}/build/lib
export CFLAGS
EXTRA_LDFLAGS = -static -L ${PWD}/build/lib
export EXTRA_LDFLAGS

#LDFLAGS = -static
#export LDFLAGS

# make build/include/ncurses dialog.tar.gz && tar xf dialog.tar.gz
# LDFLAGS=-s CFLAGS="-I $PWD/../build/include -L $PWD/../build/lib" CC=/buildroot/include/bin/musl-gcc ./configure --prefix=$PWD/../build

all: directories dialog
	strip ${PWD}/build/bin/dialog
	cp ${PWD}/build/bin/dialog ${PWD}/root/bin
	tar cf ${PWD}/out.tar -C ${PWD}/root .

directories:
	mkdir -p ${PWD}/build/include
	mkdir -p ${PWD}/build/lib

dialog: build/include/ncurses dialog.tar.gz
	tar xf dialog.tar.gz
	cd dialog-* \
	&& ./configure --prefix=${PWD}/build --libdir="${PWD}/build/lib" \
	&& echo "#define HAVE_NCURSES_NCURSES_H 1" >> dlg_config.h \
	&& make -j${JOBS} install

dialog.tar.gz:
	wget http://invisible-island.net/datafiles/release/dialog.tar.gz \
		--progress=bar:force:noscroll -O dialog.tar.gz

build/include/ncurses: ncurses.tar.gz
	tar -zxvf ncurses.tar.gz
	cd ncurses-* \
	&& echo CC: $$CC \
	&& CPPFLAGS="-P" ./configure --prefix="${PWD}/build" --without-cxx \
	&& make -j${JOBS} install

ncurses.tar.gz:
	wget https://ftp.gnu.org/gnu/ncurses/ncurses-6.0.tar.gz \
		--progress=bar:force:noscroll -O ncurses.tar.gz

