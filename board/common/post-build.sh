#!/bin/sh
. $BR2_CONFIG 2>/dev/null

TARGET_DIR=$1

# Used for matching host and guest
platform=$NETBOX_PLAT
Platform=`echo $platform | awk '{print toupper(substr($0,0,1))tolower(substr($0,2))}'`

# This is a symlink to /usr/lib/os-release, so we remove this to keep
# original Buildroot information.
rm $TARGET_DIR/etc/os-release

echo "NAME=${NETBOX_VENDOR_NAME}"             >$TARGET_DIR/etc/os-release
echo "VERSION=${NETBOX_VENDOR_VERSION}"      >>$TARGET_DIR/etc/os-release
echo "ID=${NETBOX_VENDOR_ID}"                >>$TARGET_DIR/etc/os-release
echo "VERSION_ID=${NETBOX_VENDOR_VERSION}"   >>$TARGET_DIR/etc/os-release
echo "PRETTY_NAME=\"${NETBOX_VENDOR_DESC}\"" >>$TARGET_DIR/etc/os-release
echo "VARIANT=${Platform}"                   >>$TARGET_DIR/etc/os-release
echo "VARIANT_ID=${platform}"                >>$TARGET_DIR/etc/os-release
echo "HOME_URL=${NETBOX_VENDOR_HOME}"        >>$TARGET_DIR/etc/os-release

printf "$NETBOX_VENDOR_NAME $NETBOX_VENDOR_VERSION -- `date +"%b %e %H:%M %Z %Y"`\n" > $TARGET_DIR/etc/version

# Default buildroot is a symlink to /var/run/dropbear, meaning
#  1. the /var/run/dropbear directory must be created at boot
#  2. the host key will be regenerated every boot == annoying
# NetBox has writable overlayfs for /etc, so let's use that.
rm    $TARGET_DIR/etc/dropbear
mkdir $TARGET_DIR/etc/dropbear

if [ "$NETBOX_PLAT" != "app" ]; then
    kernel=$(basename $TARGET_DIR/boot/*Image)

    for board in $(find $TARGET_DIR/boot -mindepth 1 -type d); do
	if [ -f $board/kernel ]; then
	    continue
	fi

	ln -s ../$kernel $board/kernel
    done
fi
