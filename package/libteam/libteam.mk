################################################################################
#
# libteam
#
################################################################################

LIBTEAM_VERSION = 1.30
LIBTEAM_SOURCE = v$(LIBTEAM_VERSION).tar.gz
LIBTEAM_SITE = https://github.com/jpirko/libteam/archive
LIBTEAM_LICENSE = LGPL-2.1+
LIBTEAM_LICENSE_FILES = COPYING
LIBTEAM_DEPENDENCIES = host-pkgconf jansson libdaemon libnl
LIBTEAM_AUTORECONF = YES
LIBTEAM_INSTALL_STAGING = YES

$(eval $(autotools-package))
