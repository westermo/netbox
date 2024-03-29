BR2_DL_DIR="$(BR2_EXTERNAL_NETBOX_PATH)/dl"
BR2_CCACHE=y
BR2_CCACHE_DIR="$(BR2_EXTERNAL_NETBOX_PATH)/.buildroot-ccache"
BR2_ENABLE_DEBUG=y
BR2_GLOBAL_PATCH_DIR="$(BR2_EXTERNAL_NETBOX_PATH)/patches"
BR2_TARGET_GENERIC_HOSTNAME="$(NETBOX_PLAT)"
BR2_TARGET_GENERIC_ISSUE="NetBox - The Networking Toolbox"
BR2_INIT_FINIT=y
dnl Include platform-specific overlay if plat_overlay is set
format([BR2_ROOTFS_OVERLAY="$(BR2_EXTERNAL_NETBOX_PATH)/board/common/rootfs %s %s"],
	ifdef([os_rootfs_overlay], os_rootfs_overlay,),
	ifdef([os_rootfs_overlay_extra], os_rootfs_overlay_extra,))
BR2_ROOTFS_POST_BUILD_SCRIPT="$(BR2_EXTERNAL_NETBOX_PATH)/board/common/post-build.sh"
BR2_ROOTFS_POST_IMAGE_SCRIPT="$(BR2_EXTERNAL_NETBOX_PATH)/board/common/post-image.sh $(BR2_EXTERNAL_NETBOX_PATH)/board/$(NETBOX_PLAT)/post-image.sh "
BR2_PACKAGE_BUSYBOX_CONFIG="$(BR2_EXTERNAL_NETBOX_PATH)/board/common/busybox.config"
BR2_PACKAGE_BUSYBOX_SHOW_OTHERS=y
BR2_TARGET_ROOTFS_SQUASHFS=y
BR2_PACKAGE_HOST_GENIMAGE=y
BR2_PACKAGE_HOST_GENEXT2FS=y
BR2_PACKAGE_HOST_SQUASHFS=y
# BR2_TARGET_ROOTFS_TAR is not set
