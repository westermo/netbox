#!/bin/sh
. $BR2_CONFIG 2>/dev/null

imagesh=$BR2_EXTERNAL_NETBOX_PATH/support/scripts/image.sh
fitimagesh=$BR2_EXTERNAL_NETBOX_PATH/support/scripts/fitimage.sh

# Figure out version suffix for image files, default to empty suffix for
# developer builds.  After a long discussion, this turned out to be the
# least contentious alternative to: -dev, -devel, -HEAD, etc.
err=0
ver=""
if [ -n "$RELEASE" ]; then
    # NOTE: Must use `-f $BR2_EXTERNAL` here to get, e.g. app-demo GIT version
    ver="-$($BR2_EXTERNAL_NETBOX_PATH/utils/mkversion -f $BR2_EXTERNAL)"

    if [ "-$RELEASE" != "$ver" ]; then
       echo "==============================================================================="
       echo "WARNING: Release verision $RELEASE does not match latest tag ${ver#-}!"
       echo "==============================================================================="
       err=1
    fi
fi

# Type is now optional, possibly the image name should be customizable
if [ -n "$NETBOX_TYPE" ]; then
    img=$BINARIES_DIR/$NETBOX_VENDOR_ID-$NETBOX_TYPE-${NETBOX_PLAT}${ver}.img
else
    img=$BINARIES_DIR/$NETBOX_VENDOR_ID-${NETBOX_PLAT}${ver}.img
fi

if [ "$BR2_TARGET_ROOTFS_SQUASHFS" = "y" ]; then
    if [ "$BR2_LINUX_KERNEL" = "y" ]; then
	squash=$BINARIES_DIR/rootfs.squashfs
	$imagesh "$squash" "${img}"

	if [ "$NETBOX_IMAGE_FIT" ]; then
	    itb=$(basename "${img}" .img).itb
	    $fitimagesh "$NETBOX_PLAT" "$squash" "$itb"
	fi

	rm $squash
    else
	mv $squash $img
    fi
fi

gen=""
if [ "$BR2_PACKAGE_HOST_GENIMAGE" = "y" ]; then
    gen=${BR2_EXTERNAL_NETBOX_PATH}/board/${NETBOX_PLAT}/genimage.cfg

    # create config.ext3 for Zero .gns3a and sdcard.img for Envoy, and
    # possibly other platforms with a genimage.cfg
    if [ -f "$gen" ]; then
	./support/scripts/genimage.sh "$BINARIES_DIR" -c "$gen"
    fi
fi

# Source functions for generating .gns3a and qemu.cfg files
. $BR2_EXTERNAL_NETBOX_PATH/support/scripts/gns3.sh
. $BR2_EXTERNAL_NETBOX_PATH/support/scripts/qemu.sh

if [ "$BR2_LINUX_KERNEL" = "y" ]; then
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
fi

##
# Set TFTPDIR, in your .bashrc, or similar, to copy the resulting image
# to your FTP/TFTP server directory.  Notice the use of scp, so you can
# copy the image to another system.
if [ -n "$TFTPDIR" -a -e "${img}" ]; then
    fn=$(basename "$img")
    echo "xfering '$img' -> '${TFTPDIR}/$fn'"
    scp -B "${img}" "$TFTPDIR"
    if [ "$NETBOX_IMAGE_FIT" ]; then
        scp -B "${itb}" "$TFTPDIR"
    fi
fi

##
# Cleanup of intermediate files that we don't need and don't want to
# include in the artifacts generated on GitHub
if [ "$BR2_TARGET_ROOTFS_EXT2" = "y" ]; then
    rm -f $BINARIES_DIR/rootfs.ext2
    rm -f $BINARIES_DIR/rootfs.ext4
fi
if [ "$BR2_TARGET_ROOTFS_ISO9660_HYBRID" = "y" ]; then
    rm -f $BINARIES_DIR/rootfs.cpio
fi

exit $err
