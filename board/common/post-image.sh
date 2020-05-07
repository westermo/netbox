#!/bin/sh

# Source .config for BR2_DEFCONFIG to figure out platform name
. $BR2_CONFIG 2>/dev/null

# Figure out identity for os-release
. $BR2_EXTERNAL_NETBOX_PATH/board/common/ident.rc

err=0
plf=`echo $BR2_DEFCONFIG | sed 's/.*_\(.*\)_defconfig.*$/\1/'`

if [ -n "$RELEASE" ]; then
    ver=`$BR2_EXTERNAL/bin/mkversion -f $BR2_EXTERNAL`
    img=$BINARIES_DIR/$BR2_EXTERNAL_ID-$plf-$ver.img

    if [ "$RELEASE" != "$ver" ]; then
       echo "==============================================================================="
       echo "WARNING: Release verision '$RELEASE' does not match tag '$ver'!"
       echo "==============================================================================="
       err=1
    fi
else
    img=$BINARIES_DIR/$BR2_EXTERNAL_ID-$plf.img
fi

mv -v $BINARIES_DIR/rootfs.squashfs $img

# Set TFTPDIR, in your .bashrc, or similar, to copy the resulting image
# to your FTP/TFTP server directory.  Notice the use of scp, so you can
# copy the image to another system.
if [ -n "$TFTPDIR" ]; then
    echo "xfering '$img' -> '$TFTPDIR/$fn'"
    scp -B $img $TFTPDIR
fi

exit $err
