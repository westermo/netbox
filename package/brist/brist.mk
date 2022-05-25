################################################################################
#
# brist
#
################################################################################

BRIST_VERSION = 1.1
BRIST_SOURCE = brist-$(BRIST_VERSION).tar.gz
BRIST_SITE = https://github.com/westermo/brist/releases/download/$(BRIST_VERSION)
BRIST_LICENSE = MIT
BRIST_LICENSE_FILES = LICENSE

define BRIST_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) prefix=/usr DESTDIR="$(TARGET_DIR)" install
	chmod +x $(TARGET_DIR)/usr/lib/brist/brist.sh
endef

$(eval $(generic-package))
