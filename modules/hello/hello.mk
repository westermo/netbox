HELLO_VERSION = local
HELLO_LICENSE = MIT
HELLO_SITE_METHOD = local
HELLO_SITE = $(BR2_EXTERNAL_NETBOX_PATH)/modules/hello



$(eval $(kernel-module))
$(eval $(generic-package))
