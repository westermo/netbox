include(`plat-zero.m4')dnl
include(`base.m4')dnl
include(`os.m4')dnl
BR2_LINUX_KERNEL_NEEDS_HOST_LIBELF=y

dnl Used to create an .iso image with isolinux for the GNS3 appliance and live CD/USB
BR2_TARGET_ROOTFS_EXT2=y
BR2_TARGET_ROOTFS_ISO9660=y
BR2_TARGET_ROOTFS_ISO9660_BOOT_MENU="$(BR2_EXTERNAL_NETBOX_PATH)/board/zero/isolinux.cfg"
BR2_TARGET_ROOTFS_ISO9660_HYBRID=y
BR2_TARGET_SYSLINUX=y
BR2_TARGET_SYSLINUX_ISOLINUX=y
BR2_TARGET_SYSLINUX_MBR=y
BR2_TARGET_SYSLINUX_C32="dmi.c32 libcom32.c32 libgpl.c32 liblua.c32 libutil.c32 lua.c32 menu.c32 syslinux.c32"
