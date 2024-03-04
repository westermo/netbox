#!/bin/bash

die() {
    echo "$1" >&2
    rm -rf $workdir
    exit 1
}

plat=$1
squash=$2
out=$3
opts=""
kernelcomp="gzip"
dtbcomp="gzip"

case $plat in
    basis)
	arch="arm"
	load="0x20000000"
	opts="-E -p 0x1000"
	kernelcomp="none"
	dtbcomp="none"
	;;
    byron)
	arch="arm"
	;;
    coronet)
	arch="powerpc"
	;;
    dagger)
	arch="arm"
	;;
    envoy)
	arch="arm64"
	;;
    ember)
	arch="arm64"
	load="0x40000000"
	opts="-E -p 0x1000"
	kernelcomp="none"
	dtbcomp="none"
	;;
    zero)
	arch="x86_64"
	kernelcomp="none"
	dtbcomp="none"
	;;
    *)
	arch="$plat"
	kernelcomp="none"
	dtbcomp="none"
	;;
esac

workdir=$(mktemp -d)
unsquashfs -f -d $workdir $squash boot || die "Invalid SquashFS"

kernel=$(echo $workdir/boot/*Image | cut -d\  -f1)
[ "$kernel" ] || die "No kernel found"

case ${kernelcomp} in
    "gzip")
        gzip -c -9 ${kernel} > ${workdir}/boot/$(basename ${kernel}).${kernelcomp}
        ;;
    "xz")
        xz --check=crc32 -c ${kernel} > ${workdir}/boot/$(basename ${kernel}).${kernelcomp}
        ;;
    "zstd")
        zstd -19 --stdout ${kernel} > ${workdir}/boot/$(basename ${kernel}).${kernelcomp}
        ;;
    "none")
        ;;
esac

if [ "${kernelcomp}" != "none" ]; then
	kernel=$(echo $workdir/boot/*Image.${kernelcomp} | cut -d\  -f1)
	[ "$kernel" ] || die "No kernel found"
fi

dtbs=$workdir/boot/*/device-tree.dtb
dtbs_default=$(echo ${dtbs} | cut -d "-" -f1 | cut -d "/" -f5)

# If not specified, set dtbcomp to same method as kernelcomp.
if [ -z "${dtbcomp}" ]; then
    dtbcomp=${kernelcomp}
fi

# mkimage will only align images to 4 bytes, but U-Boot will leave
# both DTB and ramdisk in place when starting the kernel. So we pad
# all components up to a 4k boundary.
truncate -s %4k $kernel $dtbs

for dtb in $dtbs; do
    name=$(basename $(dirname $dtb) | cut -d "-" -f1)

    case ${dtbcomp} in
        "gzip")
            gzip -c -9 ${dtb} > ${workdir}/boot/$(basename ${dtb}).${dtbcomp}
            ;;
        "xz")
            xz --check=crc32 -c ${dtb} > ${workdir}/boot/$(basename ${dtb}).${dtbcomp}
            ;;
        "zstd")
            zstd -19 --stdout ${dtb} > ${workdir}/boot/$(basename ${dtb}).${dtbcomp}
            ;;
        "none")
            ;;
    esac

    cat <<EOF >>$workdir/netbox-dtbs.itsi
		fdt-$name {
			description = "dtb";
			type = "flat_dt";
			arch = "$arch";
			compression = "$dtbcomp";
			data = /incbin/("${workdir}/boot/$(basename ${dtb}).${dtbcomp}");
			hash {
				algo = "sha256";
			};
		};
EOF
    cat <<EOF >>$workdir/netbox-cfgs.itsi
		$name {
			description = "$name";
			compatible = "$name";
			kernel = "kernel-1";
			ramdisk = "ramdisk-1";
			fdt = "fdt-$name";
			hash {
				algo = "sha256";
			};
		};
EOF
done

cat <<EOF >$workdir/netbox.its
/dts-v1/;

/ {
	timestamp = <$(date +%s)>;
	description = "${plat^}/Standard";
	creator = "netbox";
	#address-cells = <0x1>;

	images {
		kernel-1 {
			description = "kernel";
			type = "kernel";
			arch = "$arch";
			os = "linux";
			compression = "$kernelcomp";
			data = /incbin/("$kernel");
			hash {
				algo = "sha256";
			};
		};

		ramdisk-1 {
			description = "ramdisk";
			type = "ramdisk";
			os = "linux";
			arch = "$arch";
			compression = "none";
			data = /incbin/("$squash");
			hash {
				algo = "sha256";
			};
		};

$(cat $workdir/netbox-dtbs.itsi)
	};

	configurations {
		default = "$dtbs_default";

$(cat $workdir/netbox-cfgs.itsi)
	};
};
EOF

mkimage \
	${opts} \
	-f $workdir/netbox.its $out \
	|| die "Unable to create FIT image"

rm -rf $workdir

