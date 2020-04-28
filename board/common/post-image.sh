#!/bin/sh
# Source .config in case we're building from distclean
. $BR2_EXTERNAL/output/.config

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
