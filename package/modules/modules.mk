MODULES_VERSION = local
MODULES_LICENSE = MIT
MODULES_SITE_METHOD = local
MODULES_SITE = $(BR2_EXTERNAL_NETBOX_PATH)/modules

# Map relevant config options to directories. For example,
# BR2_PACKAGE_MODULES_HELLO is mapped to "hello".
MODULES_MODULE_SUBDIRS = $(shell echo \
	$(subst BR2_PACKAGE_MODULES_,,$(filter BR2_PACKAGE_MODULES_%,$(.VARIABLES))) \
	| tr 'A-Z_' 'a-z-')

MODULES_MODULE_MAKE_OPTS = W=1

$(eval $(kernel-module))
$(eval $(generic-package))
