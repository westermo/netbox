MODULES_VERSION = local
MODULES_LICENSE = MIT
MODULES_SITE_METHOD = local
MODULES_SITE = $(BR2_EXTERNAL_NETBOX_PATH)/modules


#include $(BR2_EXTERNAL_NETBOX_PATH)/package/modules/hello/hello.mk
include $(BR2_EXTERNAL_NETBOX_PATH)/modules/*/*.mk
