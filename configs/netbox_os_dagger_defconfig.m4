include(`plat-dagger.m4')dnl
include(`base.m4')dnl
BR2_PIC_PIE=y
include(`toolchain-bootlin.m4')dnl
include(`os.m4')dnl
# Linux insists on building an uImage as part of "make all", which
# requires mkimage.
BR2_PACKAGE_HOST_UBOOT_TOOLS=y
BR2_LINUX_KERNEL_ZIMAGE=y
