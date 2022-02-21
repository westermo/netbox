export BR2_EXTERNAL := $(CURDIR)
export PATH         := $(CURDIR)/utils:$(PATH)
export M4PATH       := $(CURDIR)/configs:$(CURDIR)/configs/include:$(M4PATH)

ARCH   ?= $(shell uname -m)
O      ?= $(CURDIR)/output

config := $(O)/.config
bmake   = $(MAKE) -C buildroot O=$(O) $1


all: $(config) | buildroot/Makefile
	@+$(call bmake,$@)

$(config):
	@+$(call bmake,list-defconfigs)
	@echo "\e[7mERROR: No configuration selected.\e[0m"
	@echo "Please choose a configuration from the list above by first calling "
	@echo "> make netbox_<os|app>_<platform>_defconfig"
	@exit 1

netbox_%_defconfig: configs/netbox_%_defconfig | buildroot/Makefile
	@+$(call bmake,$@)
	@rm $<

configs/netbox_%_defconfig: configs/netbox_%_defconfig.m4 configs/include/*.m4
	@echo "\e[7m>>>   Generating temporary $(@F) to bootstrap $O/.config\e[0m"
	@gendefconfig -d $(@D) $(<F) >$@

diff-defconfig: $(config)
	@echo "\e[7m>>>   Generating defconfig diff for manual update of configs/*.m4 files ...\e[0m"
	@diffdefconfig $<

%: | buildroot/Makefile
	@+$(call bmake,$@)

buildroot/Makefile:
	@git submodule update --init

run:
	@qemu -f $(O)/images/qemu.cfg

debug:
	@[ -f $(O)/staging/.gdbinit ]    || cp $(CURDIR)/.gdbinit $(O)/staging/.gdbinit
	@[ -f $(O)/staging/.gdbinit.py ] || cp $(CURDIR)/.gdbinit.py $(O)/staging/.gdbinit.py
	@(cd $(O)/staging/ && gdb-multiarch)

.PHONY: all defconfig run
