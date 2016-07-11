JOBS = $(shell grep -c processor /proc/cpuinfo)
PWD = $(shell pwd)
CC = ${PWD}/../include/bin/musl-gcc
export CC
CFLAGS = -I ${PWD}/build/include -L ${PWD}/build/lib
export CFLAGS
EXTRA_LDFLAGS = -static -L ${PWD}/build/lib
export EXTRA_LDFLAGS

DIALOG_VERSION := 1.3-20160424
NCURSES_VERSION := 6.0

all: directories dialog
	strip ${PWD}/dialog/dialog
	mkdir -p ${PWD}/root/bin
	cp ${PWD}/dialog/dialog ${PWD}/root/bin
	mkdir -p ${PWD}/root/share/terminfo/l
	cp ${PWD}/build/share/terminfo/l/linux ${PWD}/root/share/terminfo/l/
	tar cf ${PWD}/out.tar -C ${PWD}/root .

dialog: ncurses ../download/dialog.tar.gz
	tar xf ../download/dialog.tar.gz
	mv dialog-${DIALOG_VERSION} dialog
	cd dialog \
	&& ./configure --includedir="${PWD}/build/include" --libdir="${PWD}/build/lib" \
	&& echo "#define HAVE_NCURSES_NCURSES_H 1" >> dlg_config.h \
	&& make -j${JOBS} DESTDIR="${PWD}/build" install

directories:
	mkdir -p ${PWD}/build/include
	mkdir -p ${PWD}/build/lib


../download/dialog.tar.gz:
	wget ftp://invisible-island.net/dialog/dialog-${DIALOG_VERSION}.tgz \
		--progress=bar:force:noscroll -O ../download/dialog.tar.gz

ncurses: ../download/ncurses.tar.gz
	tar xf ../download/ncurses.tar.gz
	mv ncurses-${NCURSES_VERSION} ncurses
	cd ncurses \
	&& CPPFLAGS="-P" ./configure --prefix=/ --without-cxx \
	&& make -j${JOBS} DESTDIR="${PWD}/build" install
	

../download/ncurses.tar.gz:
	wget ftp://ftp.gnu.org/pub/gnu/ncurses/ncurses-${NCURSES_VERSION}.tar.gz \
		--progress=bar:force:noscroll -O ../download/ncurses.tar.gz
