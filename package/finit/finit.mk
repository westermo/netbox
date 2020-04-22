################################################################################
#
# finit
#
################################################################################

#FINIT_VERSION = 3.2
#FINIT_SOURCE = finit-$(FINIT_VERSION).tar.xz
#FINIT_SITE = https://github.com/troglobit/finit/releases/download/$(FINIT_VERSION)
FINIT_LICENSE = MIT
FINIT_LICENSE_FILES = LICENSE
FINIT_INSTALL_STAGING = YES
FINIT_DEPENDENCIES = host-pkgconf libite libuev
FINIT_D = $(TARGET_DIR)/etc/finit.d

# Create configure script using autoreconf when building from git
FINIT_VERSION = 70c0a38
FINIT_SITE = git://github.com/troglobit/finit.git
FINIT_AUTORECONF = YES
FINIT_DEPENDENCIES += host-automake host-autoconf host-libtool

FINIT_CONF_OPTS =				\
	--prefix=/				\
	--exec-prefix=/				\
	--disable-docs				\
	--disable-contrib			\
	--enable-fallback-shell			\
	--enable-progress			\
	--enable-watchdog			\
	--enable-inetd-chargen-plugin		\
	--enable-inetd-echo-plugin		\
	--enable-inetd-time-plugin		\
	--enable-x11-common-plugin		\
	$(if $(SKELETON_INIT_COMMON_ISSUE),--with-heading="$(SKELETON_INIT_COMMON_ISSUE)") \
	$(if $(SKELETON_INIT_COMMON_HOSTNAME),--with-hostname="$(SKELETON_INIT_COMMON_HOSTNAME)") \
	$(if $(BR2_PACKAGE_ALSA_UTILS),--enable-alsa-utils-plugin) \
	$(if $(BR2_PACKAGE_DBUS),--enable-dbus-plugin)

$(eval $(autotools-package))
