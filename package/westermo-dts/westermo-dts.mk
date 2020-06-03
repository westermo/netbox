################################################################################
#
# westermo-dts
#
################################################################################

WESTERMO_DTS_VERSION = local
WESTERMO_DTS_LICENSE = MIT
WESTERMO_DTS_DEPENDENCIES = host-dtc linux
WESTERMO_DTS_SITE_METHOD = local
WESTERMO_DTS_SITE = $(BR2_EXTERNAL_NETBOX_PATH)/dts

define WESTERMO_DTS_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) \
		PLAT=$(NETBOX_PLAT) ARCH=$(ARCH) LINUX_DIR="$(LINUX_DIR)"
endef

define WESTERMO_DTS_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) \
		PLAT=$(NETBOX_PLAT) DESTDIR="$(TARGET_DIR)" install
endef

$(eval $(generic-package))
