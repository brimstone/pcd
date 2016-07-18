PCD_VERSION ?= $(shell git describe --tags --always --dirty)

KERNEL_VERSION ?= 4.6.4
GRSEC_VERSION ?= 3.1-4.6.4-201607112205
LOCAL_VERSION ?= -${PCD_VERSION}

PWD = $(shell pwd)
JOBS = $(shell grep -c processor /proc/cpuinfo)
export INSTALL_PATH = ${PWD}/out
export INSTALL_MOD_PATH = ${PWD}/out

include ../util.mk

${INSTALL_PATH}: linux/arch/x86_64/boot/bzImage
	mkdir ${INSTALL_PATH}
	cd linux \
	&& make install \
		modules_install \
		INSTALL_HDR_PATH=${PWD}/out headers_install
	depmod -b ${INSTALL_PATH} ${KERNEL_VERSION}-grsec${LOCAL_VERSION}
	cp linux/System.map ${INSTALL_PATH}
	tar -C ${INSTALL_PATH} -cf out.tar lib System.map
	mv ${INSTALL_PATH}/vmlinuz* kernel.gz

linux/arch/x86_64/boot/bzImage: linux
	cd linux \
	&& make -j${JOBS} LOCALVERSION=${LOCAL_VERSION}

linux: ../download/linux.tar.xz ../download/grsec.patch
	tar xf ../download/linux.tar.xz
	mv linux-${KERNEL_VERSION} linux
	cp kernel.config linux/.config
	patch -d linux -p1 < ../download/grsec.patch

$(eval $(call cache,\
https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-${KERNEL_VERSION}.tar.xz, \
../download/linux.tar.xz, \
8568d41c7104e941989b14a380d167129f83db42c04e950d8d9337fe6012ff7e))

$(eval $(call cache,\
https://grsecurity.net/test/grsecurity-${GRSEC_VERSION}.patch,\
../download/grsec.patch, \
9c0bdc13683f8951e8a228446f4f32c4c3e59d4374d210e9f625faa3300e409a))

clean:
	-rm linux.tar.xz
	-rm -rf linux
	-rm grsec.patch
