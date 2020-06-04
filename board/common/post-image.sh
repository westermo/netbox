#!/bin/sh
. $BR2_CONFIG 2>/dev/null

# Figure out identity for os-release
. $BR2_EXTERNAL_NETBOX_PATH/board/common/ident.rc

imagesh=$BR2_EXTERNAL_NETBOX_PATH/utils/image.sh
fitimagesh=$BR2_EXTERNAL_NETBOX_PATH/utils/fitimage.sh

squash=$BINARIES_DIR/rootfs.squashfs
img=$BINARIES_DIR/$BR2_EXTERNAL_ID-$NETBOX_TYPE-${NETBOX_PLAT}

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

$imagesh $squash $img.img

if [ "$NETBOX_IMAGE_FIT" ]; then
    $fitimagesh $NETBOX_PLAT $squash $img.itb
fi

# Set TFTPDIR, in your .bashrc, or similar, to copy the resulting image
# to your FTP/TFTP server directory.  Notice the use of scp, so you can
# copy the image to another system.
if [ -n "$TFTPDIR" ]; then
    echo "xfering '$img' -> '$TFTPDIR/$fn'"
    scp -B $img.img $TFTPDIR
fi

exit $err
