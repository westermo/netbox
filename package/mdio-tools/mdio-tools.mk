################################################################################
#
# mdio-tools
#
################################################################################

MDIO_TOOLS_VERSION = 1.0.0-beta1
MDIO_TOOLS_SOURCE  = $(MDIO_TOOLS_VERSION).tar.gz
MDIO_TOOLS_SITE    = https://github.com/wkz/mdio-tools/archive/refs/tags
MDIO_TOOLS_LICENSE = GPL-2.0
MDIO_TOOLS_LICENSE_FILES = COPYING
MDIO_TOOLS_AUTORECONF = YES

MDIO_TOOLS_MODULE_SUBDIRS = kernel
MDIO_TOOLS_MODULE_MAKE_OPTS = KDIR=$(LINUX_DIR)

$(eval $(kernel-module))
$(eval $(autotools-package))
