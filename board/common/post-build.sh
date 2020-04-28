#!/bin/sh

TARGET_DIR=$1

# Used for matching host and guest
platform=`echo $BR2_DEFCONFIG | sed 's/.*_\(.*\)_defconfig/\1/'`
Platform=`echo $platform | awk '{print toupper(substr($0,0,1))tolower(substr($0,2))}'`

# This is a symlink to /usr/lib/os-release, so we remove this to keep
# original Buildroot information.
rm $TARGET_DIR/etc/os-release

echo "NAME=${BR2_EXTERNAL_NAME}"             >$TARGET_DIR/etc/os-release
echo "VERSION=${BR2_EXTERNAL_VERSION}"      >>$TARGET_DIR/etc/os-release
echo "ID=${BR2_EXTERNAL_ID}"                >>$TARGET_DIR/etc/os-release
echo "VERSION_ID=${BR2_EXTERNAL_VERSION}"   >>$TARGET_DIR/etc/os-release
echo "PRETTY_NAME=\"${BR2_EXTERNAL_DESC}\"" >>$TARGET_DIR/etc/os-release
echo "VARIANT=${Platform}"                  >>$TARGET_DIR/etc/os-release
echo "VARIANT_ID=${platform}"               >>$TARGET_DIR/etc/os-release
echo "HOME_URL=${BR2_EXTERNAL_HOME}"        >>$TARGET_DIR/etc/os-release

printf "$BR2_EXTERNAL_NAME $BR2_EXTERNAL_VERSION -- `date +"%b %e %H:%M %Z %Y"`\n" > $TARGET_DIR/etc/version
