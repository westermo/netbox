include([plat-basis.m4])
include([base.m4])
include([toolchain-bootlin.m4])
include([os.m4])
BR2_LINUX_KERNEL_ZIMAGE=y
BR2_LINUX_KERNEL_DTS_SUPPORT=y
BR2_LINUX_KERNEL_INTREE_DTS_NAME="versatile-pb"
