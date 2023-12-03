#!/bin/sh
. $BR2_CONFIG 2>/dev/null

imagesh=$BR2_EXTERNAL_NETBOX_PATH/support/scripts/image.sh
fitimagesh=$BR2_EXTERNAL_NETBOX_PATH/support/scripts/fitimage.sh
fitimagesh_legacy=$BR2_EXTERNAL_NETBOX_PATH/support/scripts/fitimage_legacy.sh

md5()
{
    dir=$(dirname "$1")
    fn=$(basename "$1")

    cd "$dir" || return
    md5sum "$fn" > "$fn".md5
    cd -
}

# Figure out version suffix for image files, default to empty suffix for
# developer builds.  After a long discussion, this turned out to be the
# least contentious alternative to: -dev, -devel, -HEAD, etc.
err=0
ver=""
if [ -n "$RELEASE" ]; then
    # NOTE: Must use `-f $BR2_EXTERNAL` here to get, e.g. app-demo GIT version
    ver="-$($BR2_EXTERNAL_NETBOX_PATH/utils/mkversion -f $BR2_EXTERNAL)"

    if [ "-$RELEASE" != "$ver" -a -z "$FORCE_RELEASE" ]; then
       echo "==============================================================================="
       echo "WARNING: Release verision $RELEASE does not match latest tag ${ver#-}!"
       echo "==============================================================================="
       err=1
    fi
fi

# Type is now optional, possibly the image name should be customizable
# The following files, for different use-cases, are root filesystem
# image files:
# img : squashfs initramfs image for qemu or for flashing to MTD flash
# ext : ext2 disk image for qemu or writing to a disk partition
# iso : boot cd for running in gns3 (qemu)
# cfg : config disk image for gns3 (qemu)
# sdc : sdcard image name for some targets
# gns : gns3 appliance name (zero)
if [ -n "$NETBOX_TYPE" ]; then
    img=$BINARIES_DIR/$NETBOX_VENDOR_ID-$NETBOX_TYPE-${NETBOX_PLAT}${ver}.img
    ext=$BINARIES_DIR/$NETBOX_VENDOR_ID-$NETBOX_TYPE-${NETBOX_PLAT}${ver}.ext2
    iso=$BINARIES_DIR/$NETBOX_VENDOR_ID-$NETBOX_TYPE-${NETBOX_PLAT}${ver}.iso
else
    img=$BINARIES_DIR/$NETBOX_VENDOR_ID-${NETBOX_PLAT}${ver}.img
    ext=$BINARIES_DIR/$NETBOX_VENDOR_ID-${NETBOX_PLAT}${ver}.ext2
    iso=$BINARIES_DIR/$NETBOX_VENDOR_ID-${NETBOX_PLAT}${ver}.iso
fi

# These two are only relevant for os profiles, no type needed
cfg=$BINARIES_DIR/$NETBOX_VENDOR_ID-config-${NETBOX_PLAT}${ver}.ext3
sdc=$BINARIES_DIR/$NETBOX_VENDOR_ID-sdcard-${NETBOX_PLAT}${ver}.img
gns=$BINARIES_DIR/$NETBOX_VENDOR_ID-${NETBOX_PLAT}${ver}.gns3a

# Note: currently this is an either/or situation, either the
#       platform supports squashfs root, or needs an ext2
if [ "$BR2_TARGET_ROOTFS_SQUASHFS" = "y" ]; then
    squash=$BINARIES_DIR/rootfs.squashfs
    if [ "$BR2_LINUX_KERNEL" = "y" ]; then
	$imagesh "$squash" "$img"
	md5 "$img"

	if [ "$NETBOX_IMAGE_FIT_LEGACY" ]; then
	    itb=$(dirname "${img}")/$(basename "${img}" .img).itb
	    $fitimagesh_legacy "$NETBOX_PLAT" "$squash" "$itb"
	    md5 "$itb"
	fi

	if [ "$NETBOX_IMAGE_FIT" ]; then
	    itb=$(dirname "${img}")/$(basename "${img}" .img).itb
	    $fitimagesh "$NETBOX_PLAT" "$squash" "$itb"
	    md5 "$itb"
	fi

	rm "$squash"
    else
	mv "$squash" "$img"
	md5 "$img"
    fi
elif [ "$BR2_TARGET_ROOTFS_EXT2" = "y" ]; then
    mv "$BINARIES_DIR/rootfs.ext2" "$ext"
    md5 "$ext"

    # override img for qemucfg_generate below
    img=$ext
fi

if [ "$BR2_TARGET_ROOTFS_ISO9660_HYBRID" = "y" ]; then
    mv "${BINARIES_DIR}/rootfs.iso9660" "$iso"
    md5 "$iso"
fi

if [ "$BR2_PACKAGE_HOST_GENIMAGE" = "y" ]; then
    gen=${BR2_EXTERNAL_NETBOX_PATH}/board/${NETBOX_PLAT}/genimage.cfg

    # create config.ext3 for Zero .gns3a and sdcard.img for Envoy, and
    # possibly other platforms with a genimage.cfg
    if [ -f "$gen" ]; then
	./support/scripts/genimage.sh "$BINARIES_DIR" -c "$gen"
    fi
fi

if [ -f "$BINARIES_DIR/sdcard.img" ]; then
    mv "$BINARIES_DIR/sdcard.img" "$sdc"
    md5 "$sdc"
fi

# Source functions for generating .gns3a and qemu.cfg files
. $BR2_EXTERNAL_NETBOX_PATH/support/scripts/gns3.sh
. $BR2_EXTERNAL_NETBOX_PATH/support/scripts/qemu.sh

if [ "$BR2_LINUX_KERNEL" = "y" ]; then
    if [ -n "$RELEASE" ]; then
	dir=""
	fn=$(basename "$img")
    else
	dir="$BINARIES_DIR"
	fn="$img"
    fi

    case $BR2_ARCH in
	powerpc)
	    qemucfg_generate "$fn" "$dir"
	    ;;
	arm)
	    qemucfg_generate "$fn" "$dir"
	    ;;
	aarch64)
	    qemucfg_generate "$fn" "$dir"
	    ;;
	x86_64)
	    qemucfg_generate "$fn" "$dir"
	    gns3a_generate "$iso" "$cfg" "$gns"
	    ;;
	*)
	    ;;
    esac
fi

# Release builds enter here
if [ -n "$RELEASE" ]; then
    # Strip paths to images and .dtb files to run stand-alone
    if [ -f "$BINARIES_DIR/qemu.cfg" ]; then
	cp "$BR2_EXTERNAL_NETBOX_PATH/utils/qemu" "$BINARIES_DIR/"

	# Have qemu.cfg == os build, provide more info if avail.
	if [ -f "$BR2_EXTERNAL_NETBOX_PATH/board/$NETBOX_PLAT/README.md" ]; then
	    cp "$BR2_EXTERNAL_NETBOX_PATH/board/$NETBOX_PLAT/README.md" "$BINARIES_DIR/"
	fi
    fi
fi

##
# Set TFTPDIR, in your .bashrc, or similar, to copy the resulting image
# to your FTP/TFTP server directory.  Notice the use of scp, so you can
# copy the image to another system.
if [ -n "$TFTPDIR" -a -e "$img" ]; then
    fn=$(basename "$img")
    echo "xfering '$img' -> '$TFTPDIR/$fn'"
    scp -B "$img" "$TFTPDIR"
    [ "$NETBOX_IMAGE_FIT" ] && scp -B "$itb" "$TFTPDIR"
fi

##
# Cleanup of intermediate files that we don't need and don't want to
# include in the artifacts generated on GitHub
if [ "$BR2_TARGET_ROOTFS_EXT2" = "y" ]; then
    # some builds may want to use this instead of initrd to boot
    # but those who build a squashfs get initrd qemu boot
    if [ "$BR2_TARGET_ROOTFS_SQUASHFS" = "y" ]; then
	rm -f "$BINARIES_DIR/rootfs.ext2"
	rm -f "$BINARIES_DIR/rootfs.ext4"
    fi
fi
if [ "$BR2_TARGET_ROOTFS_ISO9660_HYBRID" = "y" ]; then
    rm -f "$BINARIES_DIR/rootfs.cpio"
fi

exit $err
