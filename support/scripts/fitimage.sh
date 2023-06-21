#!/bin/sh

die() {
    echo "$1" >&2
    rm -rf $workdir
    exit 1
}

plat=$1
squash=$2
out=$3
load=0

case $plat in
    basis)
	arch="arm"
	load="0x20000000"
	;;
    byron)
	arch="arm"
	load="0x20000000"
	;;
    coronet)
	arch="powerpc"
	;;
    dagger)
	arch="arm"
	;;
    envoy)
	arch="arm64"
	load="0x40000000"
	;;
    ember)
	arch="arm64"
	load="0x40000000"
	;;
    viper408)
	arch="arm"
	load="0x20000000"
	;;
    zero)
	arch="x86_64"
	;;
    *)
	arch="$plat"
	;;
esac

workdir=$(mktemp -d)
unsquashfs -f -d $workdir $squash boot || die "Invalid SquashFS"

kernel=$(echo $workdir/boot/*Image | cut -d\  -f1)
[ "$kernel" ] || die "No kernel found"

dtbs=$workdir/boot/*/device-tree.dtb

# mkimage will only align images to 4 bytes, but U-Boot will leave
# both DTB and ramdisk in place when starting the kernel. So we pad
# all components up to a 4k boundary.
truncate -s %4k $kernel $dtbs

for dtb in $dtbs; do
    name=$(basename $(dirname $dtb))

    cat <<EOF >>$workdir/netbox-dtbs.itsi
		$name {
			description = "$name";
			type = "flat_dt";
			arch = "$arch";
			compression = "none";
			data = /incbin/("$dtb");
		};
EOF
    cat <<EOF >>$workdir/netbox-cfgs.itsi
		$name {
			description = "$name";
			kernel = "kernel";
			ramdisk = "ramdisk";
			fdt = "$name";
		};
EOF
done

cat <<EOF >$workdir/netbox.its
/dts-v1/;

/ {
	timestamp = <$(date +%s)>;
	description = "Netbox ($plat)";
	creator = "netbox";
	#address-cells = <0x1>;

	images {

		kernel {
			description = "Linux";
			type = "kernel";
			arch = "$arch";
			os = "linux";
			load = <$load>;
			entry = <$load>;
			compression = "none";
			data = /incbin/("$kernel");
		};

		ramdisk {
			description = "Netbox";
			type = "ramdisk";
			os = "linux";
			arch = "$arch";
			compression = "none";
			data = /incbin/("$squash");
		};

$(cat $workdir/netbox-dtbs.itsi)

	};

	configurations {
$(cat $workdir/netbox-cfgs.itsi)
	};
};
EOF

mkimage \
    -E -p 0x1000 \
    -f $workdir/netbox.its $out \
    || die "Unable to create FIT image"

rm -rf $workdir
