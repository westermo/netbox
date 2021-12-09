export BR2_EXTERNAL := $(CURDIR)
export PATH         := $(CURDIR)/utils:$(PATH)
export M4FLAGS      := -I include $(M4FLAGS)

ARCH ?= $(shell uname -m)
O    ?= $(CURDIR)/output

config := $(O)/.config
bmake   = $(MAKE) -C buildroot O=$(O) $1


all: $(config) | buildroot/Makefile
	@+$(call bmake,$@)

$(config):
	@+$(call bmake,list-defconfigs)
	@echo "ERROR: No configuration selected."
	@echo "Please choose a configuration from the list above by first calling "
	@echo "> make netbox_<os|app>_<platform>_defconfig"
	@exit 1

netbox_%_defconfig: configs/netbox_%_defconfig | buildroot/Makefile
	@+$(call bmake,$@)
	@rm $<

configs/netbox_%_defconfig: configs/netbox_%_defconfig.m4 configs/include/*.m4
	@echo "\e[7m>>>   Generating temporary $(@F) to bootstrap $O/.config\e[0m"
	@gendefconfig -d $(@D) $(<F) >$@

%: | buildroot/Makefile
	@+$(call bmake,$@)

buildroot/Makefile:
	@git submodule update --init

run:
	@echo "Starting Qemu  ::  Ctrl-a x -- exit | Ctrl-a c -- toggle console/monitor"
	@qemu -f $(O)/images/qemu.cfg

.PHONY: all defconfig run
