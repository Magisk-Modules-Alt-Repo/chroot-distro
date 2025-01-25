if [ "$APATCH" ]; then
    ui_print "- Installing in APatch: $APATCH_VER │ $APATCH_VER_CODE"
    mode=APatch
elif [ "$KSU" ]; then
    ui_print "- Installing in KSU: $KSU_KERNEL_VER_CODE │ $KSU_VER_CODE"
    mode=KernelSU
elif [ "$MAGISK_VER_CODE" ]; then
    ui_print "- Installing in Magisk: $MAGISK_VER │ $MAGISK_VER_CODE"
    mode=Magisk
fi
[ ! -d /data/adb/modules/busybox-ndk ] && ui_print "- Warning: You are installing this module in $mode without busybox-ndk installed"
dos2unix "$MODPATH/system/bin/chroot-distro"
set_perm_recursive "$MODPATH/system" 0 0 0755 0755
ui_print "- chroot-distro installation completed"




