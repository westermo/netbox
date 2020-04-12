################################################################################
#
# libuEv
#
################################################################################

LIBUEV_VERSION = 2.3.1
LIBUEV_SOURCE = libuev-$(LIBUEV_VERSION).tar.xz
LIBUEV_SITE = https://github.com/troglobit/libuev/releases/download/v$(LIBUEV_VERSION)
LIBUEV_LICENSE = MIT
LIBUEV_LICENSE_FILES = LICENSE
LIBUEV_INSTALL_STAGING = YES

$(eval $(autotools-package))
