PCD_VERSION := 0.3

ifdef WITH_DOCKER
.DEFAULT_GOAL := docker
.PHONY: docker_image docker
docker_image:
	docker build -t pcd:${PCD_VERSION} . >&2

docker: docker_image
	@echo "Building with docker"
	docker run --rm -i pcd:${PCD_VERSION} make tar | tar -xC output

docker_debug: docker_image
	docker run --rm -it pcd:${PCD_VERSION}
endif

KVMSERIAL=-nographic
ifdef GUI
	KVMSERIAL=-serial stdio
endif

KVMSOURCE=-cdrom output/pcd.iso -boot d
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
	@cd busybox && make >&2

out: kernel.gz components
	@echo "Extracting compiled modules to output directory" >&2
	@mkdir -p out/dev/pts >&2
	@mknod out/dev/console c 5 1 >&2
	@# TODO loop over every directory in $PWD
	@tar -xf kernel/*.tar -C out >&2
	@tar -xf busybox/*.tar -C out >&2

initrd: out
	@echo "Building initrd" >&2
	@cd out && find . | cpio --create --format='newc' > ../initrd

initrd.xz: initrd
	@echo "Compressing initrd" >&2
	@xz --check=crc32 -9 --keep initrd >&2

.PHONY: tar	
tar: iso
	@echo "Extracting output files" >&2
	@tar -cf - pcd.iso
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
	@genisoimage -o pcd.iso -b isolinux.bin -no-emul-boot -boot-load-size 4 -boot-info-table -J -V pcd iso/ >&2

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

