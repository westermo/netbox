################################################################################
#
# watchdogd
#
################################################################################

WATCHDOGD_VERSION = 3.3
WATCHDOGD_SOURCE = watchdogd-$(WATCHDOGD_VERSION).tar.xz
WATCHDOGD_SITE = https://github.com/troglobit/watchdogd/releases/download/$(WATCHDOGD_VERSION)
WATCHDOGD_LICENSE = ISC
WATCHDOGD_LICENSE_FILES = LICENSE
WATCHDOGD_DEPENDENCIES = host-pkgconf libconfuse libite libuev

$(eval $(autotools-package))
