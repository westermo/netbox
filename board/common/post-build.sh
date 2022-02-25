#!/bin/sh
. $BR2_CONFIG 2>/dev/null

TARGET_DIR=$1

# Used for matching host and guest
platform=$NETBOX_PLAT
Platform=`echo $platform | awk '{print toupper(substr($0,0,1))tolower(substr($0,2))}'`

# This is a symlink to /usr/lib/os-release, so we remove this to keep
# original Buildroot information.
rm $TARGET_DIR/etc/os-release

echo "NAME=\"${NETBOX_VENDOR_NAME}\""         >$TARGET_DIR/etc/os-release
echo "VERSION=${NETBOX_VENDOR_VERSION}"      >>$TARGET_DIR/etc/os-release
echo "ID=${NETBOX_VENDOR_ID}"                >>$TARGET_DIR/etc/os-release
echo "VERSION_ID=${NETBOX_VENDOR_VERSION}"   >>$TARGET_DIR/etc/os-release
echo "PRETTY_NAME=\"${NETBOX_VENDOR_DESC}\"" >>$TARGET_DIR/etc/os-release
echo "VARIANT=${Platform}"                   >>$TARGET_DIR/etc/os-release
echo "VARIANT_ID=${platform}"                >>$TARGET_DIR/etc/os-release
echo "HOME_URL=${NETBOX_VENDOR_HOME}"        >>$TARGET_DIR/etc/os-release

printf "$NETBOX_VENDOR_NAME $NETBOX_VENDOR_VERSION -- `date +"%b %e %H:%M %Z %Y"`\n" > $TARGET_DIR/etc/version
cat $TARGET_DIR/etc/version                                          >> $TARGET_DIR/etc/motd
printf "Type: 'help' for help with commands, 'exit' to log out.\n\n" >> $TARGET_DIR/etc/motd

# Default buildroot is a symlink to /var/run/dropbear, meaning
#  1. the /var/run/dropbear directory must be created at boot
#  2. the host key will be regenerated every boot == annoying
# NetBox has writable overlayfs for /etc, so let's use that.
if [ -h $TARGET_DIR/etc/dropbear ]; then
    rm    $TARGET_DIR/etc/dropbear
    mkdir $TARGET_DIR/etc/dropbear
fi

# Make sure we have /sbin/bridge-stp and /etc/default/mstpd set up
if [ "$BR2_PACKAGE_MSTPD" = "y" ]; then
    [ -e "$TARGET_DIR/sbin/bridge-stp" ]   || ln -s ../usr/sbin/bridge-stp "$TARGET_DIR/sbin/"
    [ -e "$TARGET_DIR/etc/default/mstpd" ] || ln -s ../bridge-stp.conf "$TARGET_DIR/etc/default/mstpd"

    grep -qE "^MSTP_BRIDGES=.*" "$TARGET_DIR/etc/bridge-stp.conf" || \
	echo "MSTP_BRIDGES=br0" >> "$TARGET_DIR/etc/bridge-stp.conf"
fi

if [ "$NETBOX_PLAT" != "app" ]; then
    kernel=$(basename $TARGET_DIR/boot/*Image)

    for board in $(find $TARGET_DIR/boot -mindepth 1 -type d); do
	if [ -f $board/kernel ]; then
	    continue
	fi

	ln -s ../$kernel $board/kernel
    done

    # If we've enabled kselftests, add writable forwarding.config symlink
    if [ -d $TARGET_DIR/usr/lib/kselftests/net/forwarding/ ]; then
	ln -sf /tmp/forwarding.config $TARGET_DIR/usr/lib/kselftests/net/forwarding/
    fi
fi
