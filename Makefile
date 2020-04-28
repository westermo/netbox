export BR2_EXTERNAL          = $(CURDIR)
export BR2_EXTERNAL_NAME     = NetBox
export BR2_EXTERNAL_DESC     = $(BR2_EXTERNAL_NAME) - The Networking Toolbox
export BR2_EXTERNAL_HOME     = https://github.com/westermo/netbox/
export BR2_EXTERNAL_ID       = netbox
export BR2_EXTERNAL_VERSION := $(shell $(BR2_EXTERNAL)/bin/mkversion)

ARCH ?= $(shell uname -m)
O    ?= $(CURDIR)/output

config := $(O)/.config
bmake   = $(MAKE) -C buildroot O=$(O) $1


all: $(config) buildroot/Makefile
	@+$(call bmake,$@)

$(config):
	@+$(call bmake,list-defconfigs)
	@echo "ERROR: No configuration selected."
	@echo "Please choose a configuration from the list above by running"
	@echo "'make <board>_defconfig' before building an image."
	@exit 1

%: buildroot/Makefile
	@+$(call bmake,$@)

buildroot/Makefile:
	@git submodule update --init

.PHONY: all defconfig
