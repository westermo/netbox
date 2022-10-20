ifeq ($(PLAT),)
$(error "Platform not set.")
endif

# Unfortunately this is not always the same as ARCH
karch-basis   := arm
karch-byron   := arm
karch-coronet := powerpc
karch-dagger  := arm
karch-envoy   := arm64
karch-ember   := arm64
karch-zero    := x86_64
karch := $(karch-$(PLAT))

default-board-dagger := 0000-needle
default-board := $(default-board-$(PLAT))

kernel-dts := $(LINUX_DIR)/arch/$(karch)/boot/dts
board-dts  := $(wildcard $(PLAT)/*/device-tree.dts)
board-dtb  := $(board-dts:.dts=.dtb)
target-dtb := $(board-dtb:$(PLAT)/%/device-tree.dtb=$(DESTDIR)/boot/%/device-tree.dtb)
board-deps := $(wildcard include/common/*.dtsi) \
	      $(wildcard include/common/*.h) \
	      $(wildcard include/$(PLAT)/*.dtsi) \
	      $(wildcard include/$(PLAT)/*.h)

default-dtb := $(DESTDIR)/boot/default/device-tree.dtb
install-dtb := $(target-dtb) $(if $(default-board),$(default-dtb))

inc := include $(LINUX_DIR)/include $(kernel-dts)
ifeq ($(PLAT),coronet)
inc += $(kernel-dts)/fsl
endif

all: $(board-dtb)

%.dtb: %.dts $(board-deps)
	cpp -nostdinc -undef -x assembler-with-cpp $(addprefix -I,$(inc)) $< \
	| dtc -I dts -O dtb $(addprefix -i ,$(inc)) -o $@

install: $(install-dtb)

$(default-dtb):
	mkdir -p $(@D) && ln -sf ../$(default-board)/device-tree.dtb $@

$(DESTDIR)/boot/%/device-tree.dtb: $(PLAT)/%/device-tree.dtb
	install -D $< $@


.PHONY: all install
