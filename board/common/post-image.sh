#!/bin/sh
. $BR2_CONFIG 2>/dev/null

imagesh=$BR2_EXTERNAL_NETBOX_PATH/utils/image.sh
fitimagesh=$BR2_EXTERNAL_NETBOX_PATH/utils/fitimage.sh

ver=dev
gen=$BR2_EXTERNAL_NETBOX_PATH/board/$NETBOX_PLAT/genimage.cfg
iso=$BINARIES_DIR/rootfs.iso9660
gns3=$BR2_EXTERNAL_NETBOX_PATH/board/common/gns3.tmpl
gns3a=$BINARIES_DIR/$NETBOX_VENDOR_ID-${NETBOX_PLAT}
squash=$BINARIES_DIR/rootfs.squashfs
config=$BINARIES_DIR/config.ext3
cfg=$BINARIES_DIR/$NETBOX_VENDOR_ID-config-${NETBOX_PLAT}

# Type is now optional, possibly the image name should be customizable
if [ -n "$NETBOX_TYPE" ]; then
    img=$BINARIES_DIR/$NETBOX_VENDOR_ID-$NETBOX_TYPE-${NETBOX_PLAT}
else
    img=$BINARIES_DIR/$NETBOX_VENDOR_ID-${NETBOX_PLAT}
fi

err=0
if [ -n "$RELEASE" ]; then
    # NOTE: Must use `-f €BR2_EXTERNAL` here to get, e.g. app-demo GIT version
    ver=`$BR2_EXTERNAL_NETBOX_PATH/bin/mkversion -f $BR2_EXTERNAL`
    img=$img-$ver
    cfg=$cfg-$ver.ext3
    gns3a=$gns3a-$ver.gns3a

    if [ "$RELEASE" != "$ver" ]; then
       echo "==============================================================================="
       echo "WARNING: Release verision '$RELEASE' does not match tag '$ver'!"
       echo "==============================================================================="
       err=1
    fi
else
    cfg=$cfg.ext3
    gns3a=$gns3a.gns3a
fi

qemucfg="${BINARIES_DIR}/qemu.cfg"

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

if [ -e "$gen" ]; then
    ./support/scripts/genimage.sh "$BINARIES_DIR" -c "$gen"
fi

if [ -e "$iso" ]; then
    mv "$iso" "$img.iso"
fi

if [ -e "$config" ]; then
    mv "$config" "$cfg"
fi

if [ -e $gns3 ]; then
    sed -e "s#VENDOR_NAME#${NETBOX_VENDOR_NAME}#g" \
	-e "s#VENDOR_DESC#${NETBOX_VENDOR_DESC}#g" \
	-e "s#VENDOR_HOME#${NETBOX_VENDOR_HOME}#g" \
	-e "s#VENDOR_VERSION#${ver}#g" \
        -e "s#ROOTFS_FILE#$(basename ${img}.iso)#g" \
	-e "s#ROOTFS_SIZE#$(stat --printf='%s' ${img}.iso)#g" \
	-e "s#ROOTFS_MD5SUM#$(md5sum ${img}.iso | awk '{print $1}')#g" \
	-e "s#ROOTFS_VERSION#${ver}#g" \
	-e "s#CONFIG_FILE#$(basename ${cfg})#g" \
	-e "s#CONFIG_SIZE#$(stat --printf='%s' ${cfg})#g" \
	-e "s#CONFIG_MD5SUM#$(md5sum ${cfg} | awk '{print $1}')#g" \
	-e "s#CONFIG_VERSION#${ver}#g" \
	< ${gns3} > ${gns3a}
fi

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
    if [ "$NETBOX_IMAGE_FIT" ]; then
        scp -B $img.itb $TFTPDIR
    fi
fi

exit $err
