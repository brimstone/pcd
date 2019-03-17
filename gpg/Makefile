include ../util.mk
JOBS = $(shell grep -c processor /proc/cpuinfo)
PWD = $(shell pwd)
CC = ${PWD}/../include/bin/musl-gcc -static
export CC

GPG_VERSION := 2.2.13
LIBGPGERROR_VERSION := 1.35
LIBGCRYPT_VERSION := 1.8.4
LIBASSUAN_VERSION := 2.5.3
LIBKSBA_VERSION := 1.3.5
NPTH_VERSION := 1.6
ZLIB_VERSION := 1.2.11

gpg: zlib libgpg-error libgcrypt libassuan libksba npth ../download/gnupg-${GPG_VERSION}.tar.bz2
	tar xf ../download/gnupg-${GPG_VERSION}.tar.bz2
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
		CFLAGS="-I${PWD}/support/include -L${PWD}/support/lib" \
	&& make -j${JOBS} \
		DESTDIR="${PWD}/out" \
		install
	strip out/bin/gpg
	mkdir -p root/bin root/share/gnupg root/root/.gnupg
	chmod 700 root/root/.gnupg
	mv out/bin/gpg root/bin/gpg
	#mv out/share/gnupg/gpg-conf.skel root/share/gnupg/
	#mv out/share/gnupg/dirmngr-conf.skel root/share/gnupg/
	root/bin/gpg  --homedir root/root/.gnupg --import signingkey.pub
	tar -cf out.tar -C root .

$(eval $(call cache, \
https://gnupg.org/ftp/gcrypt/gnupg/gnupg-${GPG_VERSION}.tar.bz2, \
../download/gnupg-${GPG_VERSION}.tar.bz2, \
76c787a955f9e6e0ead47c9be700bfb9d454f955a7b7c7e697aa719bac7b11d8)) #gpg

libgpg-error: ../download/libgpg-error-${LIBGPGERROR_VERSION}.tar.bz2
	tar xf ../download/libgpg-error-${LIBGPGERROR_VERSION}.tar.bz2
	mv libgpg-error-${LIBGPGERROR_VERSION} libgpg-error
	cd libgpg-error \
	&& ./configure \
		--prefix=/ \
		--enable-static \
		--disable-doc \
	&& sed -i 's/mode=link $$(CCLD)/mode=link "$$(CCLD)"/' src/Makefile tests/Makefile \
	&& make -j${JOBS} \
		CFLAGS="-static" \
		DESTDIR="${PWD}/support" \
		install

$(eval $(call cache, \
https://gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-${LIBGPGERROR_VERSION}.tar.bz2, \
../download/libgpg-error-${LIBGPGERROR_VERSION}.tar.bz2, \
cbd5ee62a8a8c88d48c158fff4fc9ead4132aacd1b4a56eb791f9f997d07e067)) #libgpg-error

libgcrypt: ../download/libgcrypt-${LIBGCRYPT_VERSION}.tar.bz2
	tar xf ../download/libgcrypt-${LIBGCRYPT_VERSION}.tar.bz2
	mv libgcrypt-${LIBGCRYPT_VERSION} libgcrypt
	cd libgcrypt \
	&& ./configure \
		--prefix=/ \
		--with-libgpg-error-prefix="${PWD}/support" \
		CFLAGS="-I${PWD}/support/include -L${PWD}/support/lib" \
	&& sed -i 's/mode=link $$(CCLD)/mode=link "$$(CCLD)"/' mpi/Makefile src/Makefile tests/Makefile \
	&& sed -i 's/$$(AM_V_lt) $$(AM_LIBTOOLFLAGS)/$$(AM_V_lt) --tag=CC $$(AM_LIBTOOLFLAGS)/' mpi/Makefile cipher/Makefile \
	&& make -j${JOBS} \
		DESTDIR="${PWD}/support" \
		CFLAGS="-static -I${PWD}/support/include -L${PWD}/support/lib" \
		install

$(eval $(call cache, \
https://gnupg.org/ftp/gcrypt/libgcrypt/libgcrypt-${LIBGCRYPT_VERSION}.tar.bz2, \
../download/libgcrypt-${LIBGCRYPT_VERSION}.tar.bz2, \
f638143a0672628fde0cad745e9b14deb85dffb175709cacc1f4fe24b93f2227)) #libgcrypt

libassuan: ../download/libassuan-${LIBASSUAN_VERSION}.tar.bz2
	tar xf ../download/libassuan-${LIBASSUAN_VERSION}.tar.bz2
	mv libassuan-${LIBASSUAN_VERSION} libassuan
	cd libassuan \
	&& ./configure \
		--prefix=/ \
		--with-libgpg-error-prefix="${PWD}/support" \
		CFLAGS="-I${PWD}/support/include -L${PWD}/support/lib" \
	&& sed -i 's/mode=link $$(CCLD)/mode=link "$$(CCLD)"/' tests/Makefile \
	&& make -j${JOBS} \
		DESTDIR="${PWD}/support" \
		install

$(eval $(call cache, \
https://gnupg.org/ftp/gcrypt/libassuan/libassuan-${LIBASSUAN_VERSION}.tar.bz2, \
../download/libassuan-${LIBASSUAN_VERSION}.tar.bz2, \
91bcb0403866b4e7c4bc1cc52ed4c364a9b5414b3994f718c70303f7f765e702)) #libassuan

libksba: ../download/libksba-${LIBKSBA_VERSION}.tar.bz2
	tar xf ../download/libksba-${LIBKSBA_VERSION}.tar.bz2
	mv libksba-${LIBKSBA_VERSION} libksba
	cd libksba \
	&& ./configure \
		--prefix=/ \
		--with-libgpg-error-prefix="${PWD}/support" \
		CFLAGS="-I${PWD}/support/include -L${PWD}/support/lib" \
	&& sed -i 's/mode=link $$(CCLD)/mode=link "$$(CCLD)"/' src/Makefile tests/Makefile \
	&& make -j${JOBS} \
		DESTDIR="${PWD}/support" \
		CFLAGS="-static -I${PWD}/support/include -L${PWD}/support/lib" \
		install

$(eval $(call cache, \
https://gnupg.org/ftp/gcrypt/libksba/libksba-${LIBKSBA_VERSION}.tar.bz2, \
../download/libksba-${LIBKSBA_VERSION}.tar.bz2, \
41444fd7a6ff73a79ad9728f985e71c9ba8cd3e5e53358e70d5f066d35c1a340)) #libksba

npth: ../download/npth-${NPTH_VERSION}.tar.bz2
	tar xf ../download/npth-${NPTH_VERSION}.tar.bz2
	mv npth-${NPTH_VERSION} npth
	cd npth \
	&& ./configure \
		--prefix=/ \
		CFLAGS="-I${PWD}/support/include -L${PWD}/support/lib" \
	&& sed -i 's/mode=link $$(CCLD)/mode=link "$$(CCLD)"/' tests/Makefile \
	&& make -j${JOBS} \
		DESTDIR="${PWD}/support" \
		install

$(eval $(call cache, \
https://gnupg.org/ftp/gcrypt/npth/npth-${NPTH_VERSION}.tar.bz2, \
../download/npth-${NPTH_VERSION}.tar.bz2, \
1393abd9adcf0762d34798dc34fdcf4d0d22a8410721e76f1e3afcd1daa4e2d1)) #npth


zlib: ../download/zlib-${ZLIB_VERSION}.tar.gz
	tar xf ../download/zlib-${ZLIB_VERSION}.tar.gz
	mv zlib-${ZLIB_VERSION} zlib
	cd zlib \
	&& ./configure \
		--prefix=/ \
	&& make -j${JOBS} \
		DESTDIR="${PWD}/support" \
		install

$(eval $(call cache, \
http://zlib.net/zlib-${ZLIB_VERSION}.tar.gz, \
../download/zlib-${ZLIB_VERSION}.tar.gz, \
c3e5e9fdd5004dcb542feda5ee4f0ff0744628baf8ed2dd5d66f8ca1197cb1a1)) #zlib
