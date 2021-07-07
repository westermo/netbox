#!/bin/sh
. $BR2_CONFIG 2>/dev/null

imagesh=$BR2_EXTERNAL_NETBOX_PATH/utils/image.sh
fitimagesh=$BR2_EXTERNAL_NETBOX_PATH/utils/fitimage.sh

squash=$BINARIES_DIR/rootfs.squashfs

# Type is now optional, possibly the image name should be customizable
if [ -n "$NETBOX_TYPE" ]; then
    img=$BINARIES_DIR/$NETBOX_VENDOR_ID-$NETBOX_TYPE-${NETBOX_PLAT}
else
    img=$BINARIES_DIR/$NETBOX_VENDOR_ID-${NETBOX_PLAT}
fi

# Figure out version for image files, default to -dev
err=0
ver=dev
if [ -n "$RELEASE" ]; then
    # NOTE: Must use `-f $BR2_EXTERNAL` here to get, e.g. app-demo GIT version
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
    $imagesh "$squash" "${img}.img"

    if [ "$NETBOX_IMAGE_FIT" ]; then
	$fitimagesh "$NETBOX_PLAT" "$squash" "${img}.itb"
    fi
fi

# Source functions for generating .gns3a and qemu.cfg files
. $BR2_EXTERNAL_NETBOX_PATH/board/common/gns3.sh
. $BR2_EXTERNAL_NETBOX_PATH/board/common/qemu.sh

case $BR2_ARCH in
    powerpc)
	qemucfg_generate
	;;
    arm)
	qemucfg_generate
	;;
    aarch64)
	qemucfg_generate
	;;
    x86_64)
	qemucfg_generate
	gns3a_generate		# only supported on x86_64 for now
	;;
    *)
	;;
esac

# Set TFTPDIR, in your .bashrc, or similar, to copy the resulting image
# to your FTP/TFTP server directory.  Notice the use of scp, so you can
# copy the image to another system.
if [ -n "$TFTPDIR" -a -e "${img}.img" ]; then
    fn=$(basename "$img")
    echo "xfering '$img' -> '${TFTPDIR}/$fn'"
    scp -B "${img}.img" "$TFTPDIR"
    if [ "$NETBOX_IMAGE_FIT" ]; then
        scp -B "${img}.itb" "$TFTPDIR"
    fi
fi

exit $err
