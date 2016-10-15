PWD = $(shell pwd)
PCD_VERSION ?= $(shell git describe --tags --always --dirty)
export PCD_VERSION

ifneq ($(CACHE),)
cachedir := -v /tmp/pcd/download:/buildroot/download
endif

ifneq ($(shell which docker),)
DOCKER ?= docker
endif

PACKERDEBUG=
ifdef DEBUG
	PACKERDEBUG=-var 'boot_debug=docker exec -it ssh /bin/sh<enter><wait10><wait10><wait10><wait10>touch /tmp/ssh.log; tail -f /tmp/ssh.log&'
endif

ifneq (${DOCKER},)
.DEFAULT_GOAL := docker
.PHONY: docker_image docker
docker_image:
	${DOCKER} build -t pcd:${PCD_VERSION} . >&2

docker: docker_image
	@echo "Building with docker"
	${DOCKER} run --rm -i \
		-e PCD_VERSION \
		$(cachedir) \
		pcd:${PCD_VERSION} make tar | tar -xC output
	@iso-read -i output/pcd-${PCD_VERSION}.iso -e primary -o output/pcd-${PCD_VERSION}

debug: docker_image
	${DOCKER} run --rm -it \
		-e PCD_VERSION \
		$(cachedir) \
		pcd:${PCD_VERSION}
endif

KVMSERIAL=-nographic
ifdef GUI
	KVMSERIAL=-serial stdio
endif

KVMSOURCE=-cdrom output/pcd-${PCD_VERSION}.iso -boot d
ifdef KERNEL
	KVMSOURCE=-kernel output/pcd-${PCD_VERSION} -append "console=ttyS0 initcall_debug"
endif

LOG ?= >/dev/null 2>/dev/null
ifdef VERBOSE
LOG = >&2
endif

.PHONY: all
all: kernel.lz

.PHONY: kernel
kernel:
	@echo "$$(date) Building kernel" >&2
	@cd kernel && make </dev/null ${LOG}

kernel.lz: kernel out
	@cd kernel/linux \
	&& make CONFIG_INITRAMFS_SOURCE=${PWD}/out LOCALVERSION=-${PCD_VERSION} ${LOG} \
	&& cp arch/x86/boot/bzImage ../../kernel.lz >&2

.PHONY: libc
libc:
	@echo "$$(date) Building musl" >&2
	@cd musl && make ${LOG}

.PHONY: components
components: libc kernel
	@for dir in */Makefile; do \
		[ "$$dir" = "kernel/Makefile" ] && continue; \
		[ "$$dir" = "musl/Makefile" ] && continue; \
		echo "$$(date) Building $$(dirname "$$dir")" >&2; \
		make -C "$$(dirname "$$dir")" ${LOG} || exit $$?; \
	done

out: components
	@echo "Extracting compiled modules to output directory" >&2
	@mkdir -p out/dev >&2
	@mknod out/dev/console c 136 0 >&2
	@mknod out/dev/null c 1 3 >&2
	@tar -xf kernel/out.tar -C out >&2
	@tar -xf busybox/out.tar -C out >&2
	@for tar in */out.tar; do \
		[ "$$tar" = "kernel/out.tar" ] && continue; \
		[ "$$tar" = "busybox/out.tar" ] && continue; \
		tar -xf "$$tar" -C out >&2; \
	done
	@cat out/etc/ssl/certs/* > out/etc/ssl/certs/ca-certificates.crt

initrd: out
	@echo "$$(date) Building initrd" >&2
	@cd out && find . | cpio --create --format='newc' > ../initrd

initrd.xz: initrd
	@echo "$$(date) Compressing initrd" >&2
	@xz --check=crc32 -9 --keep initrd >&2

.PHONY: tar
tar: iso
	@echo "Extracting output files" >&2
	@tar -cf - pcd-${PCD_VERSION}.iso
	@echo "Export complete" >&2

.PHONY: clean
clean:
	-rm initrd.xz
	-rm kernel.lz
	-rm out.tar
	-rm pcd-${PCD_VERSION}.box
	-rm output/pcd-${PCD_VERSION}
	-rm output/pcd-${PCD_VERSION}.iso

iso: all
	@rm -rf iso >&2
	@mkdir iso >&2
	@cp syslinux/syslinux/bios/core/isolinux.bin iso/ >&2
	@cp syslinux/syslinux/bios/com32/elflink/ldlinux/ldlinux.c32 iso/ >&2
	@cp kernel.lz iso/primary >&2
	@cp installer iso >&2
	@cd iso; sha256sum primary  installer >sha256sum
	@if [ -e signingkey.priv ]; then \
		gpg --import signingkey.priv >&2 \
		&& cd iso \
		&& gpg --sign sha256sum >&2\
		; fi
	@echo "default pcd" > iso/isolinux.cfg
	@echo "label pcd" >> iso/isolinux.cfg
	@echo "      kernel primary" >> iso/isolinux.cfg
	@genisoimage -o pcd-${PCD_VERSION}.iso \
		-b isolinux.bin -no-emul-boot -boot-load-size 4 -boot-info-table \
		-J -V pcd iso/ >&2

kvm: pcd.qcow2
	kvm -m 1024 \
	${KVMSERIAL} \
	${KVMSOURCE} \
	-no-kvm \
	-usb \
	-device usb-ehci \
	-device usb-kbd \
	pcd.qcow2 || true

pcd.qcow2:
	qemu-img create -f qcow2 pcd.qcow2 20G

.PHONY: pcd.box
pcd.box: pcd-${PCD_VERSION}.box

pcd-${PCD_VERSION}.box:
	cd packer \
	; ~/local/go/src/github.com/mitchellh/packer/bin/packer build \
	${PACKERDEBUG} \
	-var 'iso=${PWD}/output/pcd-${PCD_VERSION}.iso' \
	-var 'version=${PCD_VERSION}' \
	packer.json

reload-box:
	-vagrant box remove -f pcd
	vagrant box add pcd.box --name pcd

.PHONY: vagrant-service
vagrant-service:
	docker build -t vagrant vagrant-service
	docker save vagrant > packer/http/vagrant.tar
