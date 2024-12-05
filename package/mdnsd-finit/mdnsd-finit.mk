################################################################################
#
# mdnsd-finit
#
################################################################################

MDNSD_FINIT_VERSION = 0.12
MDNSD_FINIT_SITE =
MDNSD_FINIT_SOURCE =
MDNSD_FINIT_LICENSE = ISC
MDNSD_FINIT_LICENSE_FILES = LICENSE
MDNSD_FINIT_DEPENDENCIES = host-pkgconf avahi
MDNSD_FINIT_INSTALL_STAGING = YES

define MDNSD_FINIT_INSTALL_FINIT_SVC
	@echo "#### MDNSD_INSTALL_FINIT_SVC"
	$(INSTALL) -D -m 0644 $(BR2_EXTERNAL_NETBOX_PATH)/package/mdnsd-finit/mdnsd-finit.svc \
		$(FINIT_D)/available/mdnsd.conf
endef
MDNSD_FINIT_POST_INSTALL_TARGET_HOOKS += MDNSD_FINIT_INSTALL_FINIT_SVC

$(eval $(generic-package))
