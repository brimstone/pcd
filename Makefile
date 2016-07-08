PCD_VERSION ?= $(shell git describe --tags --always --dirty)
export PCD_VERSION

ifneq ($(shell which docker),)
.DEFAULT_GOAL := docker
.PHONY: docker_image docker
docker_image:
	docker build -t pcd:${PCD_VERSION} . >&2

docker: docker_image
	@echo "Building with docker"
	docker run --rm -i \
		-e PCD_VERSION \
		-v /tmp/pcd/download:/buildroot/download \
		pcd:${PCD_VERSION} make tar | tar -xC output

docker_debug: docker_image
	docker run --rm -it \
		-e PCD_VERSION \
		-v /tmp/pcd/download:/buildroot/download \
		pcd:${PCD_VERSION}
endif

KVMSERIAL=-nographic
ifdef GUI
	KVMSERIAL=-serial stdio
endif

KVMSOURCE=-cdrom output/pcd-${PCD_VERSION}.iso -boot d
ifdef KERNEL
	KVMSOURCE=-kernel output/kernel.gz -initrd output/initrd.xz -append "console=ttyS0"
endif

.PHONY: all
all: kernel.gz components initrd.xz

kernel.gz:
	@echo "Building kernel" >&2
	@cd kernel && make >&2
	@cp kernel/kernel.gz . >&2

libc:
	@cd musl && make >&2

.PHONY: components
components: libc
	@for dir in */Makefile; do \
		[ "$$dir" = "kernel/Makefile" ] && continue; \
		[ "$$dir" = "musl/Makefile" ] && continue; \
		make -C "$$(dirname "$$dir")" >&2 || exit $$?; \
	done

out: kernel.gz components
	@echo "Extracting compiled modules to output directory" >&2
	@mkdir -p out/dev/pts >&2
	@mknod out/dev/console c 5 1 >&2
	@# TODO loop over every directory in $PWD
	@tar -xf kernel/out.tar -C out >&2
	@tar -xf busybox/out.tar -C out >&2
	@for tar in */out.tar; do \
		[ "$$tar" = "kernel/out.tar" ] && continue; \
		[ "$$tar" = "busybox/out.tar" ] && continue; \
		tar -xf "$$tar" -C out >&2; \
	done
	@cat out/etc/ssl/certs/* > out/etc/ssl/certs/ca-certificates.crt

initrd: out
	@echo "Building initrd" >&2
	@cd out && find . | cpio --create --format='newc' > ../initrd

initrd.xz: initrd
	@echo "Compressing initrd" >&2
	@xz --check=crc32 -9 --keep initrd >&2

.PHONY: tar	
tar: iso
	@echo "Extracting output files" >&2
	@tar -cf - pcd-${PCD_VERSION}.iso
	@echo "Export complete" >&2

.PHONY: clean
clean:
	-rm initrd.xz
	-rm kernel.gz
	-rm out.tar

iso: all
	@rm -rf iso >&2
	@mkdir iso >&2
	@cp /usr/lib/ISOLINUX/isolinux.bin iso/ >&2
	@cp /usr/lib/syslinux/modules/bios/ldlinux.c32 iso/ >&2
	@cp initrd.xz iso/initrd.xz >&2
	@cp kernel.gz iso/kernel.gz >&2
	@cp installer iso >&2
	@cd iso; sha256sum initrd.xz kernel.gz installer > sha256sum >&2
	@cd iso; gpg --sign sha256sum >&2 || true
	@echo "default pcd" > iso/isolinux.cfg
	@echo "label pcd" >> iso/isolinux.cfg
	@echo "      kernel kernel.gz" >> iso/isolinux.cfg
	@echo "      initrd initrd.xz" >> iso/isolinux.cfg
	@echo "      append audit=1" >> iso/isolinux.cfg
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

