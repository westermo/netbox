################################################################################
#
# watchdogd
#
################################################################################

WATCHDOGD_VERSION = 3.3
WATCHDOGD_SOURCE = watchdogd-$(WATCHDOGD_VERSION).tar.xz
WATCHDOGD_SITE = https://github.com/troglobit/watchdogd/releases/download/$(WATCHDOGD_VERSION)
WATCHDOGD_LICENSE = ISC
WATCHDOGD_LICENSE_FILES = LICENSE
WATCHDOGD_DEPENDENCIES = host-pkgconf libconfuse libite libuev

define WATCHDOGD_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 0644 $(BR2_EXTERNAL_NETBOX_PATH)/package/watchdogd/watchdogd.service \
		$(TARGET_DIR)/usr/lib/systemd/system/watchdogd.service
endef

define WATCHDOGD_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 $(BR2_EXTERNAL_NETBOX_PATH)/package/watchdogd/S01watchdogd \
		$(TARGET_DIR)/etc/init.d/S01watchdogd
endef

WATCHDOGD_CONF_OPTS =				\
	--with-generic				\
	--with-loadavg				\
	--with-filenr				\
	--with-meminfo

$(eval $(autotools-package))
