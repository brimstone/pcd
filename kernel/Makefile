PCD_VERSION ?= $(shell git describe --tags --always --dirty)

KERNEL_VERSION ?= 4.7.10
GRSEC_VERSION ?= 3.1-4.7.10-201611011946
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
	modules=""; \
	for f in ahci bridge br_netfilter cdrom crc16 crypto_hash ehci_hcd \
			ehci_pci ext4 iptable_nat ipt_MASQUERADE ipv6 isofs jbd2 libahci \
			libata llc mbcache mii nf_conntrack nf_conntrack_ipv4 \
			nf_defrag_ipv4 nf_nat nf_nat_ipv4 nf_nat_masquerade_ipv4 \
			ohci_hcd ohci_pci overlay r8169 scsi_mod sd_mod sr_mod stp \
			usb_common usbcore usbhid veth xhci_hcd xhci_pci xt_addrtype \
			xt_conntrack \
			binfmt_misc; do \
			if [ -z "$$(grep "/$$f.ko" out/lib/modules/${KERNEL_VERSION}-grsec${LOCAL_VERSION}/modules.*)" ] \
			&& [ -z "$$(grep "$(echo "/$$f.ko" | tr '-_' '_-')" out/lib/modules/${KERNEL_VERSION}-grsec${LOCAL_VERSION}/modules.*)" ] \
				; then \
				modules="$$modules $$f"; \
		fi; \
	done; \
	if [ -n "$$modules" ]; then \
		echo "Can't find:$$modules"; \
		exit 1; \
	fi
	depmod -b ${INSTALL_PATH} ${KERNEL_VERSION}-grsec${LOCAL_VERSION}
	cp linux/System.map ${INSTALL_PATH}
	tar -C ${INSTALL_PATH} -cf out.tar lib System.map
	mv ${INSTALL_PATH}/vmlinuz* kernel.gz

linux/arch/x86_64/boot/bzImage: linux
	cd linux \
	&& make -j${JOBS} LOCALVERSION=${LOCAL_VERSION}

linux: ../download/linux-${KERNEL_VERSION}.tar.xz ../download/grsec-${GRSEC_VERSION}.patch
	tar xf ../download/linux-${KERNEL_VERSION}.tar.xz
	mv linux-${KERNEL_VERSION} linux
	cp kernel.config linux/.config
	patch -d linux -p1 < ../download/grsec-${GRSEC_VERSION}.patch

$(eval $(call cache,\
https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-${KERNEL_VERSION}.tar.xz, \
../download/linux-${KERNEL_VERSION}.tar.xz, \
92459ba55210522ac96408c0049ca2a9a3147e7a690c70fb4b536526412b59dc)) #kernel

$(eval $(call cache,\
https://grsecurity.net/test/grsecurity-${GRSEC_VERSION}.patch,\
../download/grsec-${GRSEC_VERSION}.patch, \
14430c58f81e5edca07d544e11354a6b7f8f50db7d51f73ba350937c00086a5b)) #grsec

clean:
	-rm linux-${KERNEL_VERSION}.tar.xz
	-rm -rf linux
	-rm grsec-${GRSEC_VERSION}.patch
