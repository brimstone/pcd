IPTABLES_VERSION := 1.6.0
LIBNFTNL_VERSION := 1.0.6
LIBMNL_VERSION := 1.0.4

PWD = $(shell pwd)
CC = ${PWD}/../include/bin/musl-gcc
export CC

all: iptables

iptables: libnftnl iptables.tar.bz2
	tar xf iptables.tar.bz2
	mv iptables-${IPTABLES_VERSION} iptables
	cd iptables \
	&& ./configure \
		--prefix=${PWD}/out \
		--enable-static \
		--disable-shared \
		--with-ksource=${PWD}/../kernel/linux \
		--with-kbuild=${PWD}/../kernel/out \
		libnftnl_CFLAGS="-I${PWD}/support/include" \
		libnftnl_LIBS="${PWD}/support/lib/libnftnl.a" \
		libmnl_CFLAGS="-I${PWD}/support/include" \
		libmnl_LIBS="${PWD}/support/lib/libmnl.a" \
	&& make \
		V=1 \
		all install
	strip ${PWD}/out/sbin/xtables*
	mkdir ${PWD}/root/sbin -p
	mv ${PWD}/out/sbin/* ${PWD}/root/sbin/
	tar -cf out.tar -C root .

iptables.tar.bz2:
	wget http://www.netfilter.org/projects/iptables/files/iptables-${IPTABLES_VERSION}.tar.bz2 \
		--progress=bar:force:noscroll -O iptables.tar.bz2

libnftnl: libmnl libnftnl.tar.bz2
	tar xf libnftnl.tar.bz2
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

libnftnl.tar.bz2:
	wget http://netfilter.org/projects/libnftnl/files/libnftnl-${LIBNFTNL_VERSION}.tar.bz2 \
		--progress=bar:force:noscroll -O libnftnl.tar.bz2

libmnl: libmnl.tar.bz2
	tar xf libmnl.tar.bz2
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

libmnl.tar.bz2:
	wget http://netfilter.org/projects/libmnl/files/libmnl-${LIBMNL_VERSION}.tar.bz2 \
		--progress=bar:force:noscroll -O libmnl.tar.bz2
