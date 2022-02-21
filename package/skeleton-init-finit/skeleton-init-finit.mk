################################################################################
#
# skeleton-init-finit
#
################################################################################

# The skeleton can't depend on the toolchain, since all packages depends on the
# skeleton and the toolchain is a target package, as is skeleton.
# Hence, skeleton would depends on the toolchain and the toolchain would depend
# on skeleton.
SKELETON_INIT_FINIT_ADD_TOOLCHAIN_DEPENDENCY = NO
SKELETON_INIT_FINIT_ADD_SKELETON_DEPENDENCY = NO
SKELETON_INIT_FINIT_TMPFILE := $(shell mktemp)
SKELETON_INIT_FINIT_DEPENDENCIES = skeleton-init-common

# Enable when BR2_INIT_FINT
#SKELETON_INIT_FINIT_PROVIDES = skeleton

# Prefer Finit built-in getty unless options are set, squash zero baudrate
define SKELETON_INIT_FINIT_GETTY
	if [ -z "$(SYSTEM_GETTY_OPTIONS)" ]; then \
		if [ $(SYSTEM_GETTY_BAUDRATE) -eq 0 ]; then \
			SYSTEM_GETTY_BAUDRATE=""; \
		fi; \
		echo "tty [12345789] $(SYSTEM_GETTY_PORT) $(SYSTEM_GETTY_BAUDRATE) $(SYSTEM_GETTY_TERM) noclear"; \
	else \
		echo "tty [12345789] /sbin/getty -L $(SYSTEM_GETTY_OPTIONS) $(SYSTEM_GETTY_BAUDRATE) $(SYSTEM_GETTY_PORT) $(SYSTEM_GETTY_TERM)"; \
	fi
endef

define SKELETON_INIT_FINIT_SET_GENERIC_GETTY
	$(SKELETON_INIT_FINIT_GETTY) > $(SKELETON_INIT_FINIT_TMPFILE)
	grep -qxF "`cat $(SKELETON_INIT_FINIT_TMPFILE)`" $(FINIT_D)/available/getty.conf \
		|| cat $(SKELETON_INIT_FINIT_TMPFILE) >> $(FINIT_D)/available/getty.conf
	rm $(SKELETON_INIT_FINIT_TMPFILE)
	ln -sf ../available/getty.conf $(FINIT_D)/enabled/getty.conf
endef
SKELETON_INIT_FINIT_TARGET_FINALIZE_HOOKS += SKELETON_INIT_FINIT_SET_GENERIC_GETTY

# Dropbear SSH
ifeq ($(BR2_PACKAGE_DROPBEAR),y)
define SKELETON_INIT_FINIT_SET_DROPBEAR
	ln -sf ../available/dropbear.conf $(FINIT_D)/enabled/dropbear.conf
endef
SKELETON_INIT_FINIT_TARGET_FINALIZE_HOOKS += SKELETON_INIT_FINIT_SET_DROPBEAR
endif

# mstpd provides RSTP on the default bridge
ifeq ($(BR2_PACKAGE_MSTPD),y)
define SKELETON_INIT_FINIT_SET_MSTPD
	ln -sf ../available/mstpd.conf $(FINIT_D)/enabled/mstpd.conf
endef
SKELETON_INIT_FINIT_TARGET_FINALIZE_HOOKS += SKELETON_INIT_FINIT_SET_MSTPD
endif

# Enable Busybox syslogd unless sysklogd is enabled
ifeq ($(BR2_PACKAGE_SYSKLOGD),y)
define SKELETON_INIT_FINIT_SET_SYSLOGD
	ln -sf ../available/sysklogd.conf $(FINIT_D)/enabled/sysklogd.conf
endef
else
define SKELETON_INIT_FINIT_SET_SYSLOGD
	ln -sf ../available/syslogd.conf $(FINIT_D)/enabled/syslogd.conf
endef
endif
SKELETON_INIT_FINIT_TARGET_FINALIZE_HOOKS += SKELETON_INIT_FINIT_SET_SYSLOGD

# SSDP Responder
ifeq ($(BR2_PACKAGE_SSDP_RESPONDER),y)
define SKELETON_INIT_FINIT_SET_SSDP_RESPONDER
	ln -sf ../available/ssdp-responder.conf $(FINIT_D)/enabled/ssdp-responder.conf
endef
SKELETON_INIT_FINIT_TARGET_FINALIZE_HOOKS += SKELETON_INIT_FINIT_SET_SSDP_RESPONDER
endif

# Watchdogd
ifeq ($(BR2_PACKAGE_WATCHDOGD),y)
define SKELETON_INIT_FINIT_SET_WATCHDOGD
	ln -sf ../available/watchdogd.conf $(FINIT_D)/enabled/watchdogd.conf
endef
SKELETON_INIT_FINIT_TARGET_FINALIZE_HOOKS += SKELETON_INIT_FINIT_SET_WATCHDOGD
endif

# Workaround, should be in ifupdown-scripts package
ifeq ($(BR2_PACKAGE_IFUPDOWN_SCRIPTS),y)
define SKELETON_INIT_FINIT_IFUPDOWN_WORKAROUND
	$(IFUPDOWN_SCRIPTS_PREAMBLE)
	$(IFUPDOWN_SCRIPTS_LOCALHOST)
        $(IFUPDOWN_SCRIPTS_DHCP)
endef
SKELETON_INIT_FINIT_TARGET_FINALIZE_HOOKS += SKELETON_INIT_FINIT_IFUPDOWN_WORKAROUND
endif


ifeq ($(BR2_TARGET_GENERIC_REMOUNT_ROOTFS_RW),y)
# Uncomment /dev/root entry in fstab to allow Finit to remount it rw
define SKELETON_INIT_FINIT_ROOT_RO_OR_RW
	$(SED) '\:^#[[:blank:]]*/dev/root[[:blank:]]:s/^# //' $(TARGET_DIR)/etc/fstab
endef
else
# Comment out /dev/root entry to prevent Finit from remounting it rw
define SKELETON_INIT_FINIT_ROOT_RO_OR_RW
	$(SED) '\:^/dev/root[[:blank:]]:s/^/# /' $(TARGET_DIR)/etc/fstab
endef
endif

define SKELETON_INIT_FINIT_INSTALL_TARGET_CMDS
	$(call SYSTEM_RSYNC,$(SKELETON_INIT_FINIT_PKGDIR)/skeleton,$(TARGET_DIR))
	mkdir -p $(TARGET_DIR)/home
	mkdir -p $(TARGET_DIR)/srv
	mkdir -p $(TARGET_DIR)/var
	[ -L $(TARGET_DIR)/var/run ] || ln -s ../run $(TARGET_DIR)/var/run
	$(SKELETON_INIT_FINIT_ROOT_RO_OR_RW)
endef

$(eval $(generic-package))
