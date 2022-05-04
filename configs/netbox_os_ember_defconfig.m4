include([plat-ember.m4])
include([base.m4])
include([toolchain-bootlin.m4])
include([os.m4])

dnl Build FIT image for U-Boot, useful on all Ember builds
NETBOX_IMAGE_FIT=y


NETBOX_PLAT_ember=y

BR2_PACKAGE_LINUXPTP=y
