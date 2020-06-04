#!/bin/sh

die() {
    echo "$1" >&2
    rm -rf $workdir
    exit 1
}

plat=$1
squash=$2
out=$3

workdir=$(mktemp -d)
unsquashfs -f -d $workdir $squash boot || die "Invalid SquashFS"

kernel=$(echo $workdir/boot/*Image | cut -d\  -f1)
[ "$kernel" ] || die "No kernel found"

dtbs=$workdir/boot/*/device-tree.dtb

# mkimage will only align images to 4 bytes, but U-Boot will leave
# both DTB and ramdisk in place when starting the kernel. So we pad
# all components up to a 4k boundary.
truncate -s %4k $kernel $dtbs

case $plat in
    coronet)
	arch="powerpc"
	;;
    dagger)
	arch="arm"
	;;
    envoy)
	arch="arm64"
	extra="-a 0x80080000"
	;;
    zero)
	arch="x86_64"
	;;
    *)
	arch="$plat"
	;;
esac

# add -b option prefix to each DTB.
dtbs=$(echo $dtbs | sed -e 's/\([^ ]*\)/-b \1/g')

mkimage \
    -E -p 0x1000 \
    -f auto -A $arch -O linux -T kernel -C none $extra \
    -d $kernel $dtbs -i $squash $out \
    || die "Unable to create FIT image"

rm -rf $workdir
