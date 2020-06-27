#!/bin/sh
. $BR2_CONFIG 2>/dev/null

# Figure out identity for os-release
. $BR2_EXTERNAL_NETBOX_PATH/board/common/ident.rc

imagesh=$BR2_EXTERNAL_NETBOX_PATH/utils/image.sh
fitimagesh=$BR2_EXTERNAL_NETBOX_PATH/utils/fitimage.sh

ext2=$BINARIES_DIR/rootfs.ext2
squash=$BINARIES_DIR/rootfs.squashfs
img=$BINARIES_DIR/$BR2_EXTERNAL_ID-$NETBOX_TYPE-${NETBOX_PLAT}

qemucfg="${BINARIES_DIR}/qemu.cfg"

QEMU_ARCH=""
case $BR2_ARCH in
    powerpc)
	#QEMU_ARCH=ppc
	;;
    arm)
	#QEMU_ARCH=arm
	;;
    aarch64)
	#QEMU_ARCH=arm
	;;
    x86_64)
	QEMU_ARCH=i386
	QEMU_NIC=rtl8139
	QEMU_SCSI=virtio-scsi-pci
	QEMU_MACH="q35,accel=kvm -smp 2 -watchdog i6300esb -cpu host -enable-kvm -rtc clock=host"
	;;
    *)
	;;
esac

cat <<EOF > $qemucfg
QEMU_ARCH=$QEMU_ARCH
QEMU_MACH="$QEMU_MACH"
QEMU_NIC=$QEMU_NIC
QEMU_SCSI=$QEMU_SCSI

QEMU_KERNEL=${BINARIES_DIR}/$(basename $BINARIES_DIR/*Image)
EOF

err=0
if [ -n "$RELEASE" ]; then
    # NOTE: Must use `-f €BR2_EXTERNAL` here to get, e.g. app-demo GIT version
    ver=`$BR2_EXTERNAL_NETBOX_PATH/bin/mkversion -f $BR2_EXTERNAL`
    img=$img-$ver

    if [ "$RELEASE" != "$ver" ]; then
       echo "==============================================================================="
       echo "WARNING: Release verision '$RELEASE' does not match tag '$ver'!"
       echo "==============================================================================="
       err=1
    fi
fi

if [ "$BR2_TARGET_ROOTFS_SQUASHFS" = "y" ]; then
    $imagesh $squash $img.img

    if [ "$NETBOX_IMAGE_FIT" ]; then
	$fitimagesh $NETBOX_PLAT $squash $img.itb
    fi

    echo "QEMU_INITRD=${BINARIES_DIR}/rootfs.squashfs" >>$qemucfg
fi

if [ "$BR2_TARGET_ROOTFS_EXT2" = "y" ]; then
    echo "QEMU_DISK=${BINARIES_DIR}/rootfs.ext2" >>$qemucfg
fi

# Set TFTPDIR, in your .bashrc, or similar, to copy the resulting image
# to your FTP/TFTP server directory.  Notice the use of scp, so you can
# copy the image to another system.
if [ -n "$TFTPDIR" -a -e $img.img ]; then
    echo "xfering '$img' -> '$TFTPDIR/$fn'"
    scp -B $img.img $TFTPDIR
fi

exit $err
