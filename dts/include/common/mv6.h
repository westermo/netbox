
#define mv6_port(_reg, _label, _phy, _mode)		 \
	port@_reg {					 \
		reg = <_reg>;				 \
		label = _label;				 \
		local-mac-address = [00 00 00 00 00 00]; \
		phy-handle = <_phy>;			 \
		phy-mode = _mode;			 \
	}

#define mv6_phy(_reg)					\
	ethernet-phy@_reg {				\
		reg = <_reg>;				\
		interrupts = <_reg IRQ_TYPE_LEVEL_LOW>;	\
	}
