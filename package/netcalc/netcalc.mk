################################################################################
#
# netcalc
#
################################################################################

NETCALC_VERSION = 2.1.6
NETCALC_SOURCE = netcalc-$(NETCALC_VERSION).tar.gz
NETCALC_SITE = https://github.com/troglobit/netcalc/releases/download/v$(NETCALC_VERSION)
NETCALC_LICENSE = BSD-3-Clause
NETCALC_LICENSE_FILES = LICENSE

$(eval $(autotools-package))
