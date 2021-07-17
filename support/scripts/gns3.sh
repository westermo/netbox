#!/bin/sh
# To be sourced from NetBox common post-image.sh and called for targets
# where .gns3a appliance files are supported.

gns3a_generate()
{
    tmpl=${BR2_EXTERNAL_NETBOX_PATH}/board/common/gns3.tmpl
    iso=$1
    cfg=$2
    out=$3

    # Strip any leading dash if ver is set
    VERSION=${ver#-}

    if [ -e "$tmpl" ]; then
	if [ -e "${BINARIES_DIR}/config.ext3" ]; then
	    mv "${BINARIES_DIR}/config.ext3" "$cfg"
	    cfg_sz=$(stat --printf='%s' "${cfg}")
	    cfg_md5=$(md5sum "${cfg}" | awk '{print $1}')
	fi
	if [ "$BR2_TARGET_ROOTFS_ISO9660_HYBRID" = "y" ]; then
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
	    < "${tmpl}" > "${out}"
    fi
}
