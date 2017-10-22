include ../util.mk
JOBS = $(shell grep -c processor /proc/cpuinfo)
PWD = $(shell pwd)
CC = ${PWD}/../include/bin/musl-gcc -static
export CC

GPG_VERSION := 2.1.17
LIBGPGERROR_VERSION := 1.26
LIBGCRYPT_VERSION := 1.7.5
LIBASSUAN_VERSION := 2.4.3
LIBKSBA_VERSION := 1.3.5
NPTH_VERSION := 1.3
ZLIB_VERSION := 1.2.11

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
		CFLAGS="-I${PWD}/support/include -L${PWD}/support/lib" \
	&& make -j${JOBS} \
		DESTDIR="${PWD}/out" \
		install
	strip out/bin/gpg2
	mkdir -p root/bin root/share/gnupg root/root/.gnupg
	chmod 700 root/root/.gnupg
	mv out/bin/gpg2 root/bin/gpg2
	mv out/share/gnupg/gpg-conf.skel root/share/gnupg/
	mv out/share/gnupg/dirmngr-conf.skel root/share/gnupg/
	ln -s gpg2 root/bin/gpg
	root/bin/gpg  --homedir root/root/.gnupg --import signingkey.pub
	tar -cf out.tar -C root .

$(eval $(call cache, \
https://gnupg.org/ftp/gcrypt/gnupg/gnupg-${GPG_VERSION}.tar.bz2, \
../download/gpg.tar.bz2, \
c5dc54db432209fa8f9bdb071c8fb60a765ff28e363150e30bdd4543160243cb)) #gpg

libgpg-error: ../download/libgpg-error.tar.bz2
	tar xf ../download/libgpg-error.tar.bz2
	mv libgpg-error-${LIBGPGERROR_VERSION} libgpg-error
	cd libgpg-error \
	&& ./configure \
		--prefix=/ \
		--enable-static \
	&& sed -i 's/mode=link $$(CCLD)/mode=link "$$(CCLD)"/' src/Makefile tests/Makefile \
	&& make -j${JOBS} \
		CFLAGS="-static" \
		DESTDIR="${PWD}/support" \
		install

$(eval $(call cache, \
https://gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-${LIBGPGERROR_VERSION}.tar.bz2, \
../download/libgpg-error.tar.bz2, \
4c4bcbc90116932e3acd37b37812d8653b1b189c1904985898e860af818aee69)) #libgpg-error

libgcrypt: ../download/libgcrypt.tar.bz2
	tar xf ../download/libgcrypt.tar.bz2
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
../download/libgcrypt.tar.bz2, \
d1fea4128beef2bb30a470af6bafabccc503ced350534fb9dd8f5a53ffbae800)) #libgcrypt

libassuan: ../download/libassuan.tar.bz2
	tar xf ../download/libassuan.tar.bz2
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
../download/libassuan.tar.bz2, \
22843a3bdb256f59be49842abf24da76700354293a066d82ade8134bb5aa2b71)) #libassuan

libksba: ../download/libksba.tar.bz2
	tar xf ../download/libksba.tar.bz2
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
../download/libksba.tar.bz2, \
41444fd7a6ff73a79ad9728f985e71c9ba8cd3e5e53358e70d5f066d35c1a340)) #libksba

npth: ../download/npth.tar.bz2
	tar xf ../download/npth.tar.bz2
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
../download/npth.tar.bz2, \
bca81940436aed0734eb8d0ff8b179e04cc8c087f5625204419f5f45d736a82a)) #npth


zlib: ../download/zlib.tar.gz
	tar xf ../download/zlib.tar.gz
	mv zlib-${ZLIB_VERSION} zlib
	cd zlib \
	&& ./configure \
		--prefix=/ \
	&& make -j${JOBS} \
		DESTDIR="${PWD}/support" \
		install

$(eval $(call cache, \
http://zlib.net/zlib-${ZLIB_VERSION}.tar.gz, \
../download/zlib.tar.gz, \
c3e5e9fdd5004dcb542feda5ee4f0ff0744628baf8ed2dd5d66f8ca1197cb1a1)) #zlib
