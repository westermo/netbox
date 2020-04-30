################################################################################
#
# mg
#
################################################################################

MG_VERSION = 3.3
MG_SOURCE = mg-$(MG_VERSION).tar.gz
MG_SITE = https://github.com/troglobit/mg/releases/download/v$(MG_VERSION)
MG_LICENSE = Unlicense
MG_LICENSE_FILES = UNLICENSE
MG_DEPENDENCIES = ncurses

$(eval $(autotools-package))
