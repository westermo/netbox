include([plat-viper408.m4])
include([base.m4])
include([os.m4])
BR2_LINUX_KERNEL_ZIMAGE=y
BR2_LINUX_KERNEL_DTS_SUPPORT=y
BR2_LINUX_KERNEL_INTREE_DTS_NAME="versatile-pb"

dnl Build FIT image for U-Boot, useful on all Viper408 builds
NETBOX_IMAGE_FIT=y

NETBOX_PLAT_viper408=y

