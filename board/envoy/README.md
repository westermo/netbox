Westermo Envoy
==============

Envoy is the collective Westermo platform name for an Arm64 CPU with a
Marvell SOHO switchcore.  Publicliy available, and supported, target
boards include the Marvell ESPRESSObin from Globalscale Technologies.

This file details how to connect to, and configure, supported boards.

You need a UART connection, using the on-board micro/type-c USB port.
All supported boards default to 115200 8N1.  The on-board serial TTL to
USB converter is either a Prolific or FTDI controller.


Marvell ESPRESSObin
-------------------

### Booting

By default, the ESPRESSObin comes with a pre-flashed U-Boot set up to
load the kernel, device-tree and rootfs from SPI NOR flash.  The board
jumpers can be changed to boot from different sources, see the quick
start guide for each board revision for details:

- ftp://downloads.globalscaletechnologies.com/Downloads/Espressobin/ESPRESSObin%20V5/
- ftp://downloads.globalscaletechnologies.com/Downloads/Espressobin/ESPRESSObin%20V7/

Note: the v5, and earlier, cannot boot from sd card, so you have to set
up the factory U-Boot to boot into Buildroot:

1. Flash rootfs image to sdcard drive, your `of=` device may differ:

        $ sudo dd if=output/images/sdcard.img of=/dev/mmcblk0 bs=1M status=progress oflag=direct
        $ sync

2. Boot board from SPI NOR, interrupt boot by pressing any key ...
3. Check with `printenv` that the default setup is OK, otherwise ensure
   the following are set, and define `bootcmd` for automatic boot.
   Notice the device tree file (.dtb), depending on the board and
   kernel, you may want see what other .dtb files are available:

        > setenv kernel_addr 0x5000000
        > setenv fdt_addr 0x1800000
        > setenv fdt_name boot/marvell/armada-3720-espressobin.dtb
        > setenv console console=ttyMV0,115200 earlycon=ar3700_uart,0xd0012000
        > setenv bootcmd 'mmc dev 0; ext4load mmc 0:1 $kernel_addr $image_name;ext4load mmc 0:1 $fdt_addr $fdt_name;setenv bootargs $console root=/dev/mmcblk0p1 ro quiet block2mtd.block2mtd=/dev/mmcblk0p2,,Config net.ifnames=0 biosdevname=0; booti $kernel_addr - $fdt_addr'

4. Optionally save the new settings for the next boot with `saveenv`
5. Call the boot command, or `reset` the board to start:

        > run bootcmd


Networking
----------

In contrast to vanilla Buildroot, NetBox comes prefconfigured with all¹
ports set up in a VLAN capable bridge, with offloading to the underlying
switchcore enabled.  On top of the bridge a VLAN interface (vlan1) is
set up which runs a DHCP client.

       vlan1     vlan2      Layer-3 :: IP Networking
            \   /        -------------------------------
             br0
          ____|____         Layer-2 :: Switching
         [#_#_#_#_#]
         /    |    \     -------------------------------
     eth0   eth1    eth2    Layer-1 :: Link layer

Adding another VLAN interface (vlan2), and/or moving physical ports to
that VLAN, is outside the scope of this README.  See, for instance, the
blog post:

https://westermo.github.io/howto/2020/03/24/linux-networking-bridge.html

____  
¹ Exceptions to the rule exist, the ESPRESSObin has two lan ports and one
wan port, only the lan ports are included in the bridge.
