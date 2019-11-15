SHELL = /bin/bash
PWD = $(shell pwd)
PCD_VERSION ?= $(shell git describe --tags --always --dirty)
export PCD_VERSION
KBUILD_BUILD_USER ?= brimstone
export KBUILD_BUILD_USER
KBUILD_BUILD_HOST ?= the.narro.ws
export KBUILD_BUILD_HOST

LOG ?= >/dev/null 2>/dev/null
ifdef VERBOSE
export VERBOSE
LOG = >&2
endif

ifneq ($(CACHE),)
PATH := /usr/lib/ccache:${PATH}
export PATH
cachedir := -v /tmp/pcd/download:/buildroot/download
CCACHE_DIR := /buildroot/download/ccache
export CCACHE_DIR
endif

ifneq ($(shell which docker),)
DOCKER ?= docker
endif

PACKERDEBUG=
ifdef DEBUG
	PACKERDEBUG=-var 'boot_debug=docker exec -it ssh /bin/sh<enter><wait10><wait10><wait10><wait10>touch /tmp/ssh.log; tail -f /tmp/ssh.log&'
endif

KVMSERIAL=-nographic
ifdef GUI
	KVMSERIAL=-serial stdio
endif

KVMSOURCE=-cdrom output/pcd-${PCD_VERSION}.iso -boot d
ifdef KERNEL
	KVMSOURCE=-kernel output/pcd-${PCD_VERSION}.vmlinuz -append "console=ttyS0 initcall_debug url=http://10.0.2.2:8000/config.yaml"
endif

.DEFAULT_GOAL := help
.PHONY: help
help:
	@awk 'BEGIN { \
		FS = ":.*##"; \
		printf "\nUsage:\n  make \033[36m<target>\033[0m\n"\
	} \
	/^[a-zA-Z_-]+:.*?##/ { \
		printf "  \033[36m%-17s\033[0m %s\n", $$1, $$2 \
	} \
	/^##@/ { \
		printf "\n\033[1m%s\033[0m\n", substr($$0, 5) \
	} ' $(MAKEFILE_LIST)

##@ Build targets

.PHONY: all
all: box gce ## Produce the iso, raw kernel file, vagrant box, and GCE disk image

iso: output/pcd-${PCD_VERSION}.iso ## Produce an iso

ifneq (${DOCKER},)
output/pcd-${PCD_VERSION}.iso:
	$(MAKE) docker

.PHONY: docker_image docker
docker_image:
	@${DOCKER} build -t pcd:${PCD_VERSION} . ${LOG}

docker: docker_image
	@echo "Building with docker"
	@${DOCKER} run --rm -i \
		-e PCD_VERSION \
		-e KBUILD_BUILD_USER \
		-e KBUILD_BUILD_HOST \
		-e VERBOSE \
		-e CACHE \
		-e ARCH \
		$(cachedir) \
		pcd:${PCD_VERSION} make tar | tee /tmp/pcd.tar | tar -xC output
	@iso-read -i output/pcd-${PCD_VERSION}.iso -e primary -o output/pcd-${PCD_VERSION}.vmlinuz

shell: docker_image
	${DOCKER} run --rm -it \
		-e PCD_VERSION \
		$(cachedir) \
		pcd:${PCD_VERSION}
else
output/pcd-${PCD_VERSION}.iso: kernel.lz
	@rm -rf iso >&2
	@mkdir iso >&2
	@cp syslinux/syslinux/bios/core/isolinux.bin iso/ >&2
	@cp syslinux/syslinux/bios/com32/elflink/ldlinux/ldlinux.c32 iso/ >&2
	@cp kernel.lz iso/primary >&2
	@cp installer iso >&2
	@cd iso; sha256sum primary  installer >sha256sum
	@if [ -e signingkey.priv ]; then \
		cd iso \
		&& notminisign sign -i sha256sum -s ../signingkey.priv -o sha256sum.sig >&2 \
		; fi
	@echo "default pcd" > iso/isolinux.cfg
	@echo "label pcd" >> iso/isolinux.cfg
	@echo "      kernel primary" >> iso/isolinux.cfg
	@mkdir output
	@genisoimage -o output/pcd-${PCD_VERSION}.iso \
		-b isolinux.bin -no-emul-boot -boot-load-size 4 -boot-info-table \
		-J -V pcd iso/ >&2
endif

.PHONY: box
box: output/pcd-${PCD_VERSION}.box ## Produce a vagrant box

output/pcd-${PCD_VERSION}.box: output/pcd-${PCD_VERSION}.iso
	cd packer \
	; packer build \
	${PACKERDEBUG} \
	-var 'iso=${PWD}/output/pcd-${PCD_VERSION}.iso' \
	-var 'version=${PCD_VERSION}' \
	packer.json

.PHONY: img
img: output/pcd-${PCD_VERSION}.img ## Produce a raw disk image
output/pcd-${PCD_VERSION}.img: output/pcd-${PCD_VERSION}.iso output/pcd-${PCD_VERSION}.vmlinuz
	dd if=/dev/zero of=$@ bs=4M count=256 conv=sparse
	python -m SimpleHTTPServer & \
	spid=$$! \
    && kvm -m 1024 -nographic -cdrom output/pcd-${PCD_VERSION}.iso \
		-kernel output/pcd-${PCD_VERSION}.vmlinuz \
		-append 'console=ttyS0 url=http://10.0.2.2:8000/install.yaml' \
	$@ \
	&& kill $$spid

.PHONY: gce
gce: output/pcd-${PCD_VERSION}.gce.tar.gz ## Produce the GCE image
output/pcd-${PCD_VERSION}.gce.tar.gz: output/pcd-${PCD_VERSION}.img
	cp $< output/disk.raw
	tar -Sczvf $@ -C output disk.raw
	rm output/disk.raw

##@ Helper targets
.PHONY: kernel
kernel:
	@echo "$$(date) Building kernel" >&2
	@cd kernel && make </dev/null ${LOG}

ifeq (${ARCH},um)
kernel.lz: kernel out
	@cd kernel/linux \
	&& make CONFIG_INITRAMFS_SOURCE=${PWD}/out LOCALVERSION=-${PCD_VERSION} ${LOG} \
	&& ls -l kernel ${LOG}
else
kernel.lz: kernel out
	@cd kernel/linux \
	&& make CONFIG_INITRAMFS_SOURCE=${PWD}/out LOCALVERSION=-${PCD_VERSION} ${LOG} \
	&& cp arch/x86/boot/bzImage ../../kernel.lz ${LOG}
endif

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
	@mksquashfs out out.squash -comp zstd -Xcompression-level 22 >&2
	@cd out; find . \
		! -path ./bin/busybox \
		-a ! -path ./init \
		-a ! -path ./dev/console \
		-a ! -path ./dev/null \
		-delete || true
	@mv out.squash out/squash
	@find out ! -type d -ls >&2


.PHONY: tar
tar: output/pcd-${PCD_VERSION}.iso
	@echo "Extracting output files" >&2
	@tar -cf - -C output pcd-${PCD_VERSION}.iso
	@echo "Export complete" >&2

.PHONY: clean
clean: ## Clean output directory
	-rm output/pcd-*

.PHONY: dist-clean
dist-clean: clean
ifneq ($(CACHE),)
	-docker run $(cachedir) --rm -i busybox rm -rf /buildroot/download/\*
endif


kvm: pcd.qcow2 ## Start a debug session in a kvm environment
	kvm -m 1024 \
	${KVMSERIAL} \
	${KVMSOURCE} \
	-usb \
	-device usb-ehci \
	-device usb-kbd \
	-netdev user,id=net,hostfwd=tcp::2375-:2375 \
	-device e1000,netdev=net \
	pcd.qcow2 || true

pcd.qcow2:
	qemu-img create -f qcow2 pcd.qcow2 20G

reload-box:
	-vagrant box remove -f pcd
	vagrant box add pcd.box --name pcd

.PHONY: vagrant-service
vagrant-service:
	docker build -t vagrant vagrant-service
	docker save vagrant > packer/http/vagrant.tar

ifneq ($(shell which docker),)
debug: docker_image
	docker run --rm -it \
		-e PCD_VERSION \
		-e KBUILD_BUILD_USER \
		-e KBUILD_BUILD_HOST \
		-e VERBOSE \
		-e ARCH \
		$(cachedir) \
		pcd:${PCD_VERSION} \
		/bin/bash -c 'make debug; /bin/bash'
else
debug: ## Start a debug session in the build environment
	# uncomment these to debug components
	make kernel libc
	make -C e2fsprogs
endif

.PHONY: versions
versions: ## Show versions of components used
	@grep -E '^[A-Z]*_VERSION :' */Makefile -h | sort | uniq | sed 's/_VERSION//;s/ :=/:/;s/[A-Z]/\L&/g'

.PHONY: update
update:
	@for f in */update; do pushd $$(dirname "$$f") >/dev/null; ./update; popd >/dev/null; done
