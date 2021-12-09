include([plat-envoy.m4])
include([base.m4])
include([toolchain-bootlin.m4])
define([os_plat_overlay], [y])
include([os.m4])

dnl Copy DTS files from kernel, keep vendor prefix directory
BR2_LINUX_KERNEL_DTS_SUPPORT=y
BR2_LINUX_KERNEL_INTREE_DTS_NAME="marvell/armada-3720-espressobin marvell/armada-3720-espressobin-emmc marvell/armada-3720-espressobin-v7 marvell/armada-3720-espressobin-v7-emmc marvell/armada-8040-mcbin marvell/armada-8040-mcbin-singleshot"
BR2_LINUX_KERNEL_DTB_KEEP_DIRNAME=y
BR2_LINUX_KERNEL_DTB_OVERLAY_SUPPORT=y

dnl Needed for Espressobin SD card
BR2_TARGET_ROOTFS_EXT2=y
BR2_TARGET_ROOTFS_EXT2_4=y
BR2_TARGET_ROOTFS_EXT2_SIZE="120M"

dnl Build FIT image for U-Boot, useful on all Envoy builds
NETBOX_IMAGE_FIT=y
