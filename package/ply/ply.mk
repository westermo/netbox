################################################################################
#
# ply
#
################################################################################

PLY_VERSION = 2.1.1
PLY_SOURCE  = ply-$(PLY_VERSION).tar.gz
PLY_SITE    = https://github.com/wkz/ply/releases/download/$(PLY_VERSION)
PLY_LICENSE = GPL-2.0
PLY_LICENSE_FILES = COPYING

$(eval $(autotools-package))
