################################################################################
#
# ssdp-responder
#
################################################################################

SSDP_RESPONDER_VERSION = 1.7
SSDP_RESPONDER_SOURCE = ssdp-responder-$(SSDP_RESPONDER_VERSION).tar.gz
SSDP_RESPONDER_SITE = https://github.com/troglobit/ssdp-responder/releases/download/v$(SSDP_RESPONDER_VERSION)
SSDP_RESPONDER_LICENSE = ISC
SSDP_RESPONDER_LICENSE_FILES = LICENSE

define SSDP_RESPONDER_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 0644 package/ssdp-responder/ssdpd.service \
		$(TARGET_DIR)/usr/lib/systemd/system/ssdpd.service
endef

define SSDP_RESPONDER_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 package/ssdp-responder/S02ssdpd $(TARGET_DIR)/etc/init.d/S02ssdpd
endef

$(eval $(autotools-package))
