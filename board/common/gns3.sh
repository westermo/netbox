#!/bin/sh
# To be sourced from NetBox common post-image.sh and called for targets
# where .gns3a appliance files are supported.

gen=${BR2_EXTERNAL_NETBOX_PATH}/board/${NETBOX_PLAT}/genimage.cfg

iso=${BINARIES_DIR}/rootfs.iso9660

config=${BINARIES_DIR}/config.ext3
cfg=${BINARIES_DIR}/${NETBOX_VENDOR_ID}-config-${NETBOX_PLAT}-${ver}.ext3

gns3=${BR2_EXTERNAL_NETBOX_PATH}/board/common/gns3.tmpl
gns3a=${BINARIES_DIR}/${NETBOX_VENDOR_ID}-${NETBOX_PLAT}-${ver}.gns3a

gns3a_generate()
{
    if [ -e "$gns3" ]; then
	if [ -e "$gen" ]; then
	    # create config.ext3 and rename it
	    ./support/scripts/genimage.sh "$BINARIES_DIR" -c "$gen"
	    [ -e "$config" ] && mv "$config" "$cfg"
	fi
	[ -e "$iso" ] && mv "$iso" "${img}.iso"

	sed -e "s#VENDOR_NAME#${NETBOX_VENDOR_NAME}#g" \
	    -e "s#VENDOR_DESC#${NETBOX_VENDOR_DESC}#g" \
	    -e "s#VENDOR_HOME#${NETBOX_VENDOR_HOME}#g" \
	    -e "s#VENDOR_VERSION#${ver}#g" \
            -e "s#ROOTFS_FILE#$(basename ${img}.iso)#g" \
	    -e "s#ROOTFS_SIZE#$(stat --printf='%s' ${img}.iso)#g" \
	    -e "s#ROOTFS_MD5SUM#$(md5sum ${img}.iso | awk '{print $1}')#g" \
	    -e "s#ROOTFS_VERSION#${ver}#g" \
	    -e "s#CONFIG_FILE#$(basename ${cfg})#g" \
	    -e "s#CONFIG_SIZE#$(stat --printf='%s' ${cfg})#g" \
	    -e "s#CONFIG_MD5SUM#$(md5sum ${cfg} | awk '{print $1}')#g" \
	    -e "s#CONFIG_VERSION#${ver}#g" \
	    < ${gns3} > ${gns3a}
    fi
}
