PCD_VERSION ?= $(shell git describe --tags --always --dirty)

KERNEL_VERSION ?= 4.7.1
GRSEC_VERSION ?= 3.1-4.7.1-201608161813
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
25583319c383826e0bd5706e04d5fdd747c6edaad8f19b7dce9ca2d509fb8136))

$(eval $(call cache,\
https://grsecurity.net/test/grsecurity-${GRSEC_VERSION}.patch,\
../download/grsec.patch, \
f2de5ba6948de3539ffd7fb1fede35acce9b2165efd8b8a49a87d6b31ff2ea5e))

clean:
	-rm linux.tar.xz
	-rm -rf linux
	-rm grsec.patch
