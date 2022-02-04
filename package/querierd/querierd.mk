################################################################################
#
# querierd
#
################################################################################

QUERIERD_VERSION = 0.2
QUERIERD_SITE    = \
	https://github.com/westermo/querierd/releases/download/v$(QUERIERD_VERSION)
QUERIERD_LICENSE = BSD-3-Clause
QUERIERD_LICENSE_FILES = LICENSE

$(eval $(autotools-package))
