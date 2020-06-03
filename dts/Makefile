ifeq ($(PLAT),)
$(error "Platform not set.")
endif

kernel-dts := $(LINUX_DIR)/arch/$(ARCH)/boot/dts
board-dts  := $(wildcard $(PLAT)/*/device-tree.dts)
board-dtb  := $(board-dts:.dts=.dtb)
board-deps := $(wildcard include/common/*.dtsi) \
	      $(wildcard include/common/*.h) \
	      $(wildcard include/$(PLAT)/*.dtsi) \
	      $(wildcard include/$(PLAT)/*.h)

inc := include $(LINUX_DIR)/include $(kernel-dts)
ifeq ($(PLAT),coronet)
inc += $(kernel-dts)/fsl
endif

all: $(board-dtb)

%.dtb: %.dts $(board-deps)
	cpp -nostdinc -undef -x assembler-with-cpp $(addprefix -I,$(inc)) $< \
	| dtc -I dts -O dtb $(addprefix -i ,$(inc)) -o $@

install: $(board-dtb:$(PLAT)/%/device-tree.dtb=$(DESTDIR)/boot/%/device-tree.dtb)

$(DESTDIR)/boot/%/device-tree.dtb: $(PLAT)/%/device-tree.dtb
	install -D $< $@


.PHONY: all install
