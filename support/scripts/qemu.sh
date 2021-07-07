#!/bin/sh

qemucfg="${BINARIES_DIR}/qemu.cfg"

qemucfg_generate()
{
    QEMU_ARCH=""
    case $BR2_ARCH in
	powerpc)
	    QEMU_ARCH=ppc64
	    QEMU_NIC=rtl8139
	    QEMU_SCSI=virtio-scsi-pci
	    QEMU_MACH="ppce500 -smp 2 -watchdog i6300esb -cpu e5500 -rtc clock=host"
	    ;;
	arm)
	    QEMU_ARCH=$BR2_ARCH
	    QEMU_NIC=virtio-net-pci
	    QEMU_SCSI=virtio-scsi-pci
	    QEMU_MACH="versatilepb -watchdog i6300esb -dtb ${BINARIES_DIR}/versatile-pb.dtb"
	    ;;
	aarch64)
	    QEMU_ARCH=$BR2_ARCH
	    QEMU_NIC=virtio-net-pci
	    QEMU_SCSI=virtio-scsi-pci
	    QEMU_MACH="virt -cpu cortex-a53 -watchdog i6300esb -rtc clock=host"
	    ;;
	x86_64)
	    QEMU_ARCH=$BR2_ARCH
	    QEMU_NIC=virtio-net-pci
	    QEMU_SCSI=virtio-scsi-pci
	    QEMU_MACH="q35,accel=kvm -smp 2 -watchdog i6300esb -cpu host -enable-kvm -rtc clock=host"
	    ;;
	*)
	    ;;
    esac

    cat <<EOF > $qemucfg
# Westermo NetBox target emulation using Qemu
NETBOX_PLAT=$NETBOX_PLAT
QEMU_ARCH=$QEMU_ARCH
QEMU_MACH="$QEMU_MACH"
QEMU_NIC=$QEMU_NIC
QEMU_SCSI=$QEMU_SCSI

QEMU_KERNEL=${BINARIES_DIR}/$(basename $BINARIES_DIR/*Image)
EOF

    if [ "$BR2_TARGET_ROOTFS_SQUASHFS" = "y" ]; then
	echo "QEMU_INITRD=${BINARIES_DIR}/rootfs.squashfs" >>$qemucfg
    fi

    if [ "$BR2_TARGET_ROOTFS_EXT2" = "y" ]; then
	echo "QEMU_DISK=${BINARIES_DIR}/rootfs.ext2" >>$qemucfg
    fi
}
