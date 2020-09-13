
#define _mv6_port_common(_reg, _label, _mode)		\
	reg = <_reg>;					\
	label = _label;					\
	local-mac-address = [00 00 00 00 00 00];	\
	phy-mode = _mode

#define mv6_port(_reg, _label, _phy, _mode)		 \
	port@_reg {					 \
		phy-handle = <_phy>;			 \
		_mv6_port_common(_reg, _label, _mode);	 \
	}

#define mv6_port_sfp(_reg, _label, _sfp, _mode)		 \
	port@_reg {					 \
		managed = "in-band-status";		 \
		sfp = <_sfp>;				 \
		_mv6_port_common(_reg, _label, _mode);	 \
	}

#define mv6_phy(_reg)					\
	ethernet-phy@_reg {				\
		reg = <_reg>;				\
		interrupts = <_reg IRQ_TYPE_LEVEL_LOW>;	\
	}
