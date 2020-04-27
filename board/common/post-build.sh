#!/bin/sh

TARGET_DIR=$1

# This is a symlink to /usr/lib/os-release, so we remove this to keep
# original Buildroot information.
rm $TARGET_DIR/etc/os-release

echo "NAME=$BR2_EXTERNAL_NAME"                                     >$TARGET_DIR/etc/os-release
echo "VERSION=$BR2_EXTERNAL_VERSION"                              >>$TARGET_DIR/etc/os-release
echo "ID=$BR2_EXTERNAL_ID"                                        >>$TARGET_DIR/etc/os-release
echo "VERSION_ID=$BR2_EXTERNAL_VERSION"                           >>$TARGET_DIR/etc/os-release
echo "PRETTY_NAME=\"$BR2_EXTERNAL_NAME v$BR2_EXTERNAL_VERSION\""  >>$TARGET_DIR/etc/os-release

printf "$BR2_EXTERNAL_NAME v$BR2_EXTERNAL_VERSION -- `date +"%b %e %H:%M %Z %Y"`\n" > $TARGET_DIR/etc/version
