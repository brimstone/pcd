include ../util.mk
JOBS = $(shell grep -c processor /proc/cpuinfo)
PWD = $(shell pwd)
CC = ${PWD}/../include/bin/musl-gcc -static
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
	&& ./configure --with-ncursesw --includedir="${PWD}/build/include" \
	&& make -j${JOBS} DESTDIR="${PWD}/build" install

directories:
	mkdir -p ${PWD}/build/include
	mkdir -p ${PWD}/build/lib


$(eval $(call cache,\
ftp://invisible-island.net/dialog/dialog-${DIALOG_VERSION}.tgz, \
../download/dialog.tar.gz, \
47f5870876e778aa2902f2e91b4070418d4651b647e1a67a94127cb8aab5b5eb))

ncurses: ../download/ncurses.tar.gz
	tar xf ../download/ncurses.tar.gz
	mv ncurses-${NCURSES_VERSION} ncurses
	cd ncurses \
	&& CPPFLAGS="-P" ./configure --prefix=/ --without-cxx --enable-widec \
	&& make -j${JOBS} DESTDIR="${PWD}/build" install

$(eval $(call cache,\
ftp://ftp.gnu.org/pub/gnu/ncurses/ncurses-${NCURSES_VERSION}.tar.gz, \
../download/ncurses.tar.gz, \
f551c24b30ce8bfb6e96d9f59b42fbea30fa3a6123384172f9e7284bcf647260))
