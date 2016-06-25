KERNEL_VERSION := 4.5.7
GRSEC_VERSION := 3.1-4.5.7-201606222150

PWD = $(shell pwd)
JOBS = $(shell grep -c processor /proc/cpuinfo)
export INSTALL_PATH = ${PWD}/out
export INSTALL_MOD_PATH = ${PWD}/out

${INSTALL_PATH}: linux-${KERNEL_VERSION}/arch/x86_64/boot/bzImage
	mkdir ${INSTALL_PATH}
	cd linux-${KERNEL_VERSION} \
	&& $(MAKE) install modules_install
	tar -C ${INSTALL_PATH} -cf modules.tar lib
	mv ${INSTALL_PATH}/vmlinuz* kernel.gz

linux-${KERNEL_VERSION}/arch/x86_64/boot/bzImage: linux-${KERNEL_VERSION}
	cd linux-${KERNEL_VERSION} \
	&& make -j${JOBS}

linux-${KERNEL_VERSION}: linux.tar.xz grsec.patch
	tar xf linux.tar.xz
	cp kernel.config linux-${KERNEL_VERSION}/.config
	patch -d linux-${KERNEL_VERSION} -p1 < grsec.patch
	
linux.tar.xz:
	wget https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-${KERNEL_VERSION}.tar.xz \
		-O linux.tar.xz

grsec.patch:
	wget https://grsecurity.net/test/grsecurity-${GRSEC_VERSION}.patch \
		-O grsec.patch

clean:
	-rm linux.tar.xz
	-rm -rf linux-${KERNEL_VERSION}
	-rm grsec.patch
