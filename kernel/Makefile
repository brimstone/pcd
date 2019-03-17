PCD_VERSION ?= $(shell git describe --tags --always --dirty)

KERNEL_VERSION ?= 5.0.2
LOCAL_VERSION ?= -${PCD_VERSION}
ARCH ?= amd64

PWD = $(shell pwd)
JOBS ?= $(shell grep -c processor /proc/cpuinfo)
export INSTALL_PATH = ${PWD}/out
export INSTALL_MOD_PATH = ${PWD}/out
export CONFIG_INITRAMFS_SOURCE = ${PWD}/../out

include ../util.mk

ifeq (${ARCH},um)
${INSTALL_PATH}: linux/linux
	cp linux/linux kernel.gz
else
${INSTALL_PATH}: linux/linux
	mkdir -p ${INSTALL_PATH}
	cd linux \
	&& make install \
		modules_install \
		INSTALL_HDR_PATH=${PWD}/out headers_install
	modules=""; \
	for f in ahci bridge br_netfilter cdrom crc16 crypto_hash ehci_hcd \
			ehci_pci ext4 iptable_nat ipt_MASQUERADE ipv6 isofs jbd2 libahci \
			libata llc mbcache mii nf_conntrack nf_conntrack_ipv4 \
			nf_defrag_ipv4 nf_nat nf_nat_ipv4 nf_nat_masquerade_ipv4 \
			ohci_hcd ohci_pci overlay r8169 scsi_mod sd_mod sr_mod stp \
			usb_common usbcore usbhid veth xhci_hcd xhci_pci xt_addrtype \
			xt_conntrack \
			binfmt_misc; do \
			if [ -z "$$(grep "/$$f.ko" out/lib/modules/${KERNEL_VERSION}${LOCAL_VERSION}/modules.*)" ] \
			&& [ -z "$$(grep "$(echo "/$$f.ko" | tr '-_' '_-')" out/lib/modules/${KERNEL_VERSION}${LOCAL_VERSION}/modules.*)" ] \
				; then \
				modules="$$modules $$f"; \
		fi; \
	done; \
	if [ -n "$$modules" ]; then \
		echo "Can't find:$$modules"; \
		exit 1; \
	fi
	depmod -b ${INSTALL_PATH} ${KERNEL_VERSION}${LOCAL_VERSION}
	cp linux/System.map ${INSTALL_PATH}
	tar -C ${INSTALL_PATH} -cf out.tar lib System.map
	mv ${INSTALL_PATH}/vmlinuz* kernel.gz
endif

linux/linux: linux
	cd linux \
	&& make -j${JOBS} LOCALVERSION=${LOCAL_VERSION}
	[ -e linux/arch/x86_64/boot/bzImage ] && mv linux/arch/x86_64/boot/bzImage linux/linux || true

linux: ../download/linux-${KERNEL_VERSION}.tar.xz
	tar xf ../download/linux-${KERNEL_VERSION}.tar.xz
	mv linux-${KERNEL_VERSION} linux
	cp ${ARCH}.config linux/.config
	cd linux; [ ! -d ../patches/${ARCH} ] || for p in ../patches/${ARCH}/*.patch; do patch -p 1 < "$$p"; done

$(eval $(call cache,\
https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-${KERNEL_VERSION}.tar.xz, \
../download/linux-${KERNEL_VERSION}.tar.xz, \
43bfea3a6b24b4e5f63190409a199bee8cb93dbea01c52ad7f017078ebdf7c9b)) #kernel

clean:
	-rm linux-${KERNEL_VERSION}.tar.xz
	-rm -rf linux
