#!/bin/sh
# To be sourced from NetBox common post-image.sh and called for targets
# where .gns3a appliance files are supported.

iso=${BINARIES_DIR}/rootfs.iso9660

config=${BINARIES_DIR}/config.ext3
cfg=${BINARIES_DIR}/${NETBOX_VENDOR_ID}-config-${NETBOX_PLAT}${ver}.ext3

gns3_template=${BR2_EXTERNAL_NETBOX_PATH}/board/common/gns3.tmpl
gns3_appliance=${BINARIES_DIR}/${NETBOX_VENDOR_ID}-${NETBOX_PLAT}${ver}.gns3a

gns3a_generate()
{
    # Strip any leading dash if ver is set
    VERSION=${ver#-}

    if [ -e "$gns3_template" ]; then
	if [ -e "$config" ]; then
	    mv "$config" "$cfg"
	    cfg_sz=$(stat --printf='%s' "${cfg}")
	    cfg_md5=$(md5sum "${cfg}" | awk '{print $1}')
	fi
	if [ "$BR2_TARGET_ROOTFS_ISO9660_HYBRID" = "y" ]; then
	    dir=$(dirname "$img")
	    fn="$dir"/$(basename "$img" .img).iso
	    mv "$iso" "$fn"
	    iso="$fn"
	    iso_sz=$(stat --printf='%s' "${iso}")
	    iso_md5=$(md5sum "${iso}" | awk '{print $1}')
	fi

	sed -e "s#VENDOR_NAME#${NETBOX_VENDOR_NAME}#g" \
	    -e "s#VENDOR_DESC#${NETBOX_VENDOR_DESC}#g" \
	    -e "s#VENDOR_HOME#${NETBOX_VENDOR_HOME}#g" \
	    -e "s#VENDOR_VERSION#${VERSION}#g" \
            -e "s#ROOTFS_FILE#$(basename "${iso}")#g" \
	    -e "s#ROOTFS_SIZE#${iso_sz}#g" \
	    -e "s#ROOTFS_MD5SUM#${iso_md5}#g" \
	    -e "s#ROOTFS_VERSION#${VERSION}#g" \
	    -e "s#CONFIG_FILE#$(basename "${cfg}")#g" \
	    -e "s#CONFIG_SIZE#${cfg_sz}#g" \
	    -e "s#CONFIG_MD5SUM#${cfg_md5}#g" \
	    -e "s#CONFIG_VERSION#${VERSION}#g" \
	    < "${gns3_template}" > "${gns3_appliance}"
    fi
}
