################################################################################
#
# mdio-tools
#
################################################################################

MDIO_TOOLS_VERSION = 1.1.1
MDIO_TOOLS_SOURCE  = mdio-tools-$(MDIO_TOOLS_VERSION).tar.gz
MDIO_TOOLS_SITE    = https://github.com/wkz/mdio-tools/releases/download/$(MDIO_TOOLS_VERSION)
MDIO_TOOLS_LICENSE = GPL-2.0
MDIO_TOOLS_LICENSE_FILES = COPYING
MDIO_TOOLS_INSTALL_STAGING = YES

MDIO_TOOLS_MODULE_SUBDIRS = kernel
MDIO_TOOLS_MODULE_MAKE_OPTS = KDIR=$(LINUX_DIR)

$(eval $(kernel-module))
$(eval $(autotools-package))
