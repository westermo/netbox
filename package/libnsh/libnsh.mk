################################################################################
#
# libnsh
#
################################################################################

LIBNSH_VERSION = 0.4
LIBNSH_PKGNAME = libnsh
LIBNSH_SITE = https://github.com/westermo/$(LIBNSH_PKGNAME)/releases/download/v$(LIBNSH_VERSION)
LIBNSH_INSTALL_STAGING = YES
LIBNSH_LICENSE = MIT
LIBNSH_LICENSE_FILES = LICENSE
LIBNSH_DEPENDENCIES = host-pkgconf netsnmp
LIBNSH_INSTALL_STAGING = YES

$(eval $(autotools-package))
