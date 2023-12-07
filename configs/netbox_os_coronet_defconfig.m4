include([plat-coronet.m4])
include([base.m4])
include([os.m4])

dnl Linux insists on building an uImage as part of "make all",
dnl which requires mkimage.
BR2_PACKAGE_HOST_UBOOT_TOOLS=y
BR2_LINUX_KERNEL_ZIMAGE=y

dnl Build FIT image for U-Boot, useful on all Envoy builds
NETBOX_IMAGE_FIT=y
