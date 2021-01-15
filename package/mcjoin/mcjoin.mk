################################################################################
#
# mcjoin
#
################################################################################

MCJOIN_VERSION = 2.9
MCJOIN_SOURCE  = mcjoin-$(MCJOIN_VERSION).tar.gz
MCJOIN_SITE    = https://github.com/troglobit/mcjoin/releases/download/v$(MCJOIN_VERSION)
MCJOIN_LICENSE = ISC
MCJOIN_LICENSE_FILES = LICENSE

$(eval $(autotools-package))
