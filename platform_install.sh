DIR=/usr/lib/linux-u-boot-next-orangepizeroplus2-h5_5.70_arm64
write_uboot_platform () 
{ 
    [[ -f $1/u-boot-with-dtb.bin ]] && dd if=$1/u-boot-with-dtb.bin of=$2 bs=1k seek=8 conv=fsync > /dev/null 2>&1 || true;
    [[ -f $1/sunxi-spl.bin ]] && dd if=$1/sunxi-spl.bin of=$2 bs=8k seek=1 conv=fsync > /dev/null 2>&1;
    [[ -f $1/u-boot.itb ]] && dd if=$1/u-boot.itb of=$2 bs=8k seek=5 conv=fsync > /dev/null 2>&1 || true
}
write_uboot_platform_mtd () 
{ 
    dd if=$1/u-boot.flash of=$2 status=noxfer > /dev/null 2>&1
}
setup_write_uboot_platform () 
{ 
    if grep -q "ubootpart" /proc/cmdline; then
	DEVICE=/dev/mmcblk2
    else
        local tmp=$(cat /proc/cmdline);
        tmp="${tmp##*root=}";
        tmp="${tmp%% *}";
        [[ -n $tmp ]] && local part=$(findfs $tmp 2>/dev/null);
        [[ -n $part ]] && local dev=$(lsblk -n -o PKNAME $part 2>/dev/null);
        [[ -n $dev && $dev == mmcblk* ]] && DEVICE="/dev/$dev";
    fi
}
