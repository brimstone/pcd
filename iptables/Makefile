include ../util.mk
IPTABLES_VERSION := 1.6.0
LIBNFTNL_VERSION := 1.0.7
LIBMNL_VERSION := 1.0.4

JOBS = $(shell grep -c processor /proc/cpuinfo)
PWD = $(shell pwd)
CC = ${PWD}/../include/bin/musl-gcc -static
export CC

all: iptables

iptables: libnftnl ../download/iptables.tar.bz2
	tar xf ../download/iptables.tar.bz2
	mv iptables-${IPTABLES_VERSION} iptables
	cd iptables \
	&& ./configure \
		CFLAGS="-I${PWD}/../kernel/out/include" \
		--prefix=${PWD}/out \
		--enable-static \
		--disable-shared \
		--with-ksource=${PWD}/../kernel/linux \
		--with-kbuild=${PWD}/../kernel/out \
		libnftnl_CFLAGS="-I${PWD}/support/include" \
		libnftnl_LIBS="${PWD}/support/lib/libnftnl.a" \
		libmnl_CFLAGS="-I${PWD}/support/include" \
		libmnl_LIBS="${PWD}/support/lib/libmnl.a" \
	&& sed -i 's/mode=link $$(CCLD)/mode=link "$$(CCLD)"/' iptables/Makefile \
	&& make \
		V=1 \
		all install
	strip ${PWD}/out/sbin/xtables*
	mkdir ${PWD}/root/sbin -p
	mv ${PWD}/out/sbin/* ${PWD}/root/sbin/
	tar -cf out.tar -C root .

$(eval $(call cache,\
http://www.netfilter.org/projects/iptables/files/iptables-${IPTABLES_VERSION}.tar.bz2, \
../download/iptables.tar.bz2, \
4bb72a0a0b18b5a9e79e87631ddc4084528e5df236bc7624472dcaa8480f1c60)) #iptables

libnftnl: libmnl ../download/libnftnl-${LIBNFTNL_VERSION}.tar.bz2
	tar xf ../download/libnftnl-${LIBNFTNL_VERSION}.tar.bz2
	mv libnftnl-${LIBNFTNL_VERSION} libnftnl
	cd libnftnl \
	&& ./configure \
		--prefix="/" \
		--enable-static \
		--disable-shared \
		LIBMNL_CFLAGS="-I${PWD}/support/include" \
		LIBMNL_LIBS="${PWD}/support" \
	&& make \
		CFLAGS="-I${PWD}/../kernel/out/include" \
		DESTDIR="${PWD}/support" \
		V=1 \
		all install

$(eval $(call cache,\
http://netfilter.org/projects/libnftnl/files/libnftnl-${LIBNFTNL_VERSION}.tar.bz2, \
../download/libnftnl-${LIBNFTNL_VERSION}.tar.bz2, \
9bb66ecbc64b8508249402f0093829f44177770ad99f6042b86b3a467d963982)) #libnftnl

libmnl: ../download/libmnl.tar.bz2
	tar xf ../download/libmnl.tar.bz2
	mv libmnl-${LIBMNL_VERSION} libmnl
	cd libmnl \
	&& ./configure \
		--prefix="/" \
		--enable-static \
		--disable-shared \
	&& make \
		CFLAGS="-I${PWD}/../kernel/out/include" \
		DESTDIR="${PWD}/support" \
		V=1 \
		all install

$(eval $(call cache,\
http://netfilter.org/projects/libmnl/files/libmnl-${LIBMNL_VERSION}.tar.bz2, \
../download/libmnl.tar.bz2, \
171f89699f286a5854b72b91d06e8f8e3683064c5901fb09d954a9ab6f551f81)) #libmnl
