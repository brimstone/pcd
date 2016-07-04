KERNEL_VERSION := 4.5.7
GRSEC_VERSION := 3.1-4.5.7-201606302132
LOCAL_VERSION := -pcd1

PWD = $(shell pwd)
JOBS = $(shell grep -c processor /proc/cpuinfo)
export INSTALL_PATH = ${PWD}/out
export INSTALL_MOD_PATH = ${PWD}/out

${INSTALL_PATH}: linux/arch/x86_64/boot/bzImage
	mkdir ${INSTALL_PATH}
	cd linux \
	&& make install \
		modules_install \
		INSTALL_HDR_PATH=${PWD}/out headers_install
	depmod -b ${INSTALL_PATH} ${KERNEL_VERSION}-grsec${LOCAL_VERSION}
	tar -C ${INSTALL_PATH} -cf out.tar lib
	mv ${INSTALL_PATH}/vmlinuz* kernel.gz

linux/arch/x86_64/boot/bzImage: linux
	cd linux \
	&& make -j${JOBS} LOCALVERSION=${LOCAL_VERSION}

linux: linux.tar.xz grsec.patch
	tar xf linux.tar.xz
	mv linux-${KERNEL_VERSION} linux
	cp kernel.config linux/.config
	patch -d linux -p1 < grsec.patch
	
linux.tar.xz:
	wget https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-${KERNEL_VERSION}.tar.xz \
		--progress=bar:force:noscroll -O linux.tar.xz

grsec.patch:
	wget https://grsecurity.net/test/grsecurity-${GRSEC_VERSION}.patch \
		--progress=bar:force:noscroll -O grsec.patch

clean:
	-rm linux.tar.xz
	-rm -rf linux
	-rm grsec.patch
