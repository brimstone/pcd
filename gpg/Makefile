include ../util.mk
JOBS = $(shell grep -c processor /proc/cpuinfo)
PWD = $(shell pwd)
CC = ${PWD}/../include/bin/musl-gcc
export CC
CFLAGS = -static
export CFLAGS

GPG_VERSION := 2.1.14
LIBGPGERROR_VERSION := 1.24
LIBGCRYPT_VERSION := 1.7.2
LIBASSUAN_VERSION := 2.4.3
LIBKSBA_VERSION := 1.3.4
NPTH_VERSION := 1.2
ZLIB_VERSION := 1.2.8

gpg: zlib libgpg-error libgcrypt libassuan libksba npth ../download/gpg.tar.bz2
	tar xf ../download/gpg.tar.bz2
	mv gnupg-${GPG_VERSION} gnupg
	cd gnupg \
	&& ./configure \
		--prefix=/ \
		--with-libgpg-error-prefix="${PWD}/support" \
		--with-libgcrypt-prefix="${PWD}/support" \
		--with-libassuan-prefix="${PWD}/support" \
		--with-ksba-prefix="${PWD}/support" \
		--with-npth-prefix="${PWD}/support" \
		--with-zlib="${PWD}/support" \
		CFLAGS="-static -I${PWD}/support/include -L${PWD}/support/lib" \
	&& make \
		DESTDIR="${PWD}/out" \
		install
	strip out/bin/gpg2
	mkdir -p root/bin root/share/gnupg root/root/.gnupg
	mv out/bin/gpg2 root/bin/gpg2
	mv out/share/gnupg/gpg-conf.skel root/share/gnupg/
	mv out/share/gnupg/dirmngr-conf.skel root/share/gnupg/
	ln -s gpg2 root/bin/gpg
	gpg --import signingkey.pub
	cp ${HOME}/.gnupg/pubring.kbx root/root/.gnupg/
	tar -cf out.tar -C root .

$(eval $(call cache, \
https://gnupg.org/ftp/gcrypt/gnupg/gnupg-${GPG_VERSION}.tar.bz2, \
../download/gpg.tar.bz2, \
9450dee9693b6a12bf0c374dae77b66c30f69ff8f35fc9266ab8dd76998eba42))

libgpg-error: ../download/libgpg-error.tar.bz2
	tar xf ../download/libgpg-error.tar.bz2
	mv libgpg-error-${LIBGPGERROR_VERSION} libgpg-error
	cd libgpg-error \
	&& ./configure \
		--prefix=/ \
	&& make \
		DESTDIR="${PWD}/support" \
		install

$(eval $(call cache, \
https://gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-${LIBGPGERROR_VERSION}.tar.bz2, \
../download/libgpg-error.tar.bz2, \
9268e1cc487de5e6e4460fca612a06e4f383072ac43ae90603e5e46783d3e540))

libgcrypt: ../download/libgcrypt.tar.bz2
	tar xf ../download/libgcrypt.tar.bz2
	mv libgcrypt-${LIBGCRYPT_VERSION} libgcrypt
	cd libgcrypt \
	&& ./configure \
		--prefix=/ \
		--with-libgpg-error-prefix="${PWD}/support" \
		CFLAGS="-static -I${PWD}/support/include -L${PWD}/support/lib" \
	&& make \
		DESTDIR="${PWD}/support" \
		install

$(eval $(call cache, \
https://gnupg.org/ftp/gcrypt/libgcrypt/libgcrypt-${LIBGCRYPT_VERSION}.tar.bz2, \
../download/libgcrypt.tar.bz2, \
3d35df906d6eab354504c05d749a9b021944cb29ff5f65c8ef9c3dd5f7b6689f))

libassuan: ../download/libassuan.tar.bz2
	tar xf ../download/libassuan.tar.bz2
	mv libassuan-${LIBASSUAN_VERSION} libassuan
	cd libassuan \
	&& ./configure \
		--prefix=/ \
		--with-libgpg-error-prefix="${PWD}/support" \
		CFLAGS="-static -I${PWD}/support/include -L${PWD}/support/lib" \
	&& make \
		DESTDIR="${PWD}/support" \
		install

$(eval $(call cache, \
https://gnupg.org/ftp/gcrypt/libassuan/libassuan-${LIBASSUAN_VERSION}.tar.bz2, \
../download/libassuan.tar.bz2, \
22843a3bdb256f59be49842abf24da76700354293a066d82ade8134bb5aa2b71))

libksba: ../download/libksba.tar.bz2
	tar xf ../download/libksba.tar.bz2
	mv libksba-${LIBKSBA_VERSION} libksba
	cd libksba \
	&& ./configure \
		--prefix=/ \
		--with-libgpg-error-prefix="${PWD}/support" \
		CFLAGS="-static -I${PWD}/support/include -L${PWD}/support/lib" \
	&& make \
		DESTDIR="${PWD}/support" \
		install

$(eval $(call cache, \
https://gnupg.org/ftp/gcrypt/libksba/libksba-${LIBKSBA_VERSION}.tar.bz2, \
../download/libksba.tar.bz2, \
f6c2883cebec5608692d8730843d87f237c0964d923bbe7aa89c05f20558ad4f))

npth: ../download/npth.tar.bz2
	tar xf ../download/npth.tar.bz2
	mv npth-${NPTH_VERSION} npth
	cd npth \
	&& ./configure \
		--prefix=/ \
		CFLAGS="-static -I${PWD}/support/include -L${PWD}/support/lib" \
	&& make \
		DESTDIR="${PWD}/support" \
		install

$(eval $(call cache, \
https://gnupg.org/ftp/gcrypt/npth/npth-${NPTH_VERSION}.tar.bz2, \
../download/npth.tar.bz2, \
6ddbdddb2cf49a4723f9d1ad6563c480d6760dcb63cb7726b8fc3bc2e1b6c08a))


zlib: ../download/zlib.tar.gz
	tar xf ../download/zlib.tar.gz
	mv zlib-${ZLIB_VERSION} zlib
	cd zlib \
	&& ./configure \
		--prefix=/ \
	&& make \
		DESTDIR="${PWD}/support" \
		install


$(eval $(call cache, \
http://zlib.net/zlib-${ZLIB_VERSION}.tar.gz, \
../download/zlib.tar.gz, \
36658cb768a54c1d4dec43c3116c27ed893e88b02ecfcb44f2166f9c0b7f2a0d))
