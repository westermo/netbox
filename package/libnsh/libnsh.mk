################################################################################
#
# libnsh
#
################################################################################

LIBNSH_VERSION = 0.4
LIBNSH_PKGNAME = libnsh
LIBNSH_SOURCE = $(LIBNSH_PKGNAME)-$(LIBNSH_VERSION).tar.gz
# This looks like a typo, but the 'v' needs to be there
LIBNSH_SITE = https://github.com/westermo/$(LIBNSH_PKGNAME)/releases/download/v$(LIBNSH_VERSION)
LIBNSH_INSTALL_STAGING = YES
LIBNSH_AUTORECONF = YES
LIBNSH_LICENSE = MIT
LIBNSH_LICENSE_FILES = LICENSE
#LIBNSH_CONF_OPTS =
LIBNSH_DEPENDENCIES = host-pkgconf netsnmp

$(eval $(autotools-package))
