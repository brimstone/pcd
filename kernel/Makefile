KERNEL_VERSION := 4.6.3
GRSEC_VERSION := 3.1-4.6.3-201607060823
LOCAL_VERSION := _${GRSEC}-pcd_0.3-$(shell date --utc +"%Y%d%mT%H%M%SZ")

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

linux: ../download/linux.tar.xz ../download/grsec.patch
	tar xf ../download/linux.tar.xz
	mv linux-${KERNEL_VERSION} linux
	cp kernel.config linux/.config
	patch -d linux -p1 < ../download/grsec.patch
	
../download/linux.tar.xz:
	wget https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-${KERNEL_VERSION}.tar.xz \
		--progress=bar:force:noscroll -O ../download/linux.tar.xz

../download/grsec.patch:
	wget https://grsecurity.net/test/grsecurity-${GRSEC_VERSION}.patch \
		--progress=bar:force:noscroll -O ../download/grsec.patch

clean:
	-rm linux.tar.xz
	-rm -rf linux
	-rm grsec.patch
