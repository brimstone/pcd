include ../util.mk
JOBS = $(shell grep -c processor /proc/cpuinfo)
PWD = $(shell pwd)
CC = ${PWD}/../include/bin/musl-gcc -static
CFLAGS = -I ${PWD}/build/include -L ${PWD}/build/lib
EXTRA_LDFLAGS = -static -L ${PWD}/build/lib

MTM_VERSION := 1.0.1
NCURSES_VERSION := 6.1

all: directories mtm
	strip ${PWD}/mtm/mtm
	mkdir -p ${PWD}/root/bin
	cp ${PWD}/mtm/mtm ${PWD}/root/bin
	mkdir -p ${PWD}/root/share/terminfo/l
	cp ${PWD}/build/share/terminfo/l/linux ${PWD}/root/share/terminfo/l/
	tar cf ${PWD}/out.tar -C ${PWD}/root .

mtm: ncurses ../download/mtm-${MTM_VERSION}.tar.gz
	tar xf ../download/mtm-${MTM_VERSION}.tar.gz
	mv mtm-${MTM_VERSION} mtm
	cd mtm \
	&& cp config.def.h config.h \
	&& ${CC} ${CFLAGS} ${EXTRA_LDFLAGS} -std=c99 -Wall -Wextra -pedantic -O3 -D_POSIX_C_SOURCE=200809L -D_XOPEN_SOURCE=600 -D_XOPEN_SOURCE_EXTENDED -o mtm  vtparser.c mtm.c  -lncursesw -lutil -ltinfo \
	&& cp mtm ../root/bin

directories:
	mkdir -p ${PWD}/build/include
	mkdir -p ${PWD}/build/lib
	mkdir -p ${PWD}/root/bin


$(eval $(call cache,\
https://github.com/deadpixi/mtm/archive/${MTM_VERSION}.tar.gz, \
../download/mtm-${MTM_VERSION}.tar.gz, \
cb1758d810860d25c7dc6d6d5440ad79055a22935f521be7d7d9fae40124add8)) #mtm

ncurses: ../download/ncurses-${NCURSES_VERSION}.tar.gz
	tar xf ../download/ncurses-${NCURSES_VERSION}.tar.gz
	mv ncurses-${NCURSES_VERSION} ncurses
	cd ncurses \
	&& CPPFLAGS="-P" ./configure --prefix=/ --without-cxx --enable-widec --with-termlib=tinfo \
	&& make -j${JOBS} DESTDIR="${PWD}/build" install

$(eval $(call cache,\
ftp://ftp.gnu.org/pub/gnu/ncurses/ncurses-${NCURSES_VERSION}.tar.gz, \
../download/ncurses-${NCURSES_VERSION}.tar.gz, \
aa057eeeb4a14d470101eff4597d5833dcef5965331be3528c08d99cebaa0d17)) #ncurses
