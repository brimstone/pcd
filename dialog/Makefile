include ../util.mk
JOBS = $(shell grep -c processor /proc/cpuinfo)
PWD = $(shell pwd)
CC = ${PWD}/../include/bin/musl-gcc -static
export CC
CFLAGS = -I ${PWD}/build/include -L ${PWD}/build/lib
export CFLAGS
EXTRA_LDFLAGS = -static -L ${PWD}/build/lib
export EXTRA_LDFLAGS

DIALOG_VERSION := 1.3-20160828
NCURSES_VERSION := 6.0

all: directories dialog
	strip ${PWD}/dialog/dialog
	mkdir -p ${PWD}/root/bin
	cp ${PWD}/dialog/dialog ${PWD}/root/bin
	mkdir -p ${PWD}/root/share/terminfo/l
	cp ${PWD}/build/share/terminfo/l/linux ${PWD}/root/share/terminfo/l/
	tar cf ${PWD}/out.tar -C ${PWD}/root .

dialog: ncurses ../download/dialog-${DIALOG_VERSION}.tar.gz
	tar xf ../download/dialog-${DIALOG_VERSION}.tar.gz
	mv dialog-${DIALOG_VERSION} dialog
	cd dialog \
	&& ./configure --with-ncursesw --includedir="${PWD}/build/include" \
	&& make -j${JOBS} DESTDIR="${PWD}/build" install

directories:
	mkdir -p ${PWD}/build/include
	mkdir -p ${PWD}/build/lib


$(eval $(call cache,\
http://invisible-mirror.net/archives/dialog/dialog-${DIALOG_VERSION}.tgz, \
../download/dialog-${DIALOG_VERSION}.tar.gz, \
453095abaec288bfbc1ca9faced917e17742cff1ea45ec46210071ac153562f9)) #dialog

ncurses: ../download/ncurses.tar.gz
	tar xf ../download/ncurses.tar.gz
	mv ncurses-${NCURSES_VERSION} ncurses
	cd ncurses \
	&& CPPFLAGS="-P" ./configure --prefix=/ --without-cxx --enable-widec \
	&& make -j${JOBS} DESTDIR="${PWD}/build" install

$(eval $(call cache,\
ftp://ftp.gnu.org/pub/gnu/ncurses/ncurses-${NCURSES_VERSION}.tar.gz, \
../download/ncurses.tar.gz, \
f551c24b30ce8bfb6e96d9f59b42fbea30fa3a6123384172f9e7284bcf647260)) #ncurses
