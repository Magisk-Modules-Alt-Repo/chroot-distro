ui_print "[*] Checking installation environment..."

# Check environment 
if [ "$APATCH" ]; then
    ui_print "- APatch: $APATCH_VER │ $APATCH_VER_CODE"
    bin_dir="/data/adb/ap/bin"
elif [ "$KSU" ]; then
    ui_print "- KSU: $KSU_KERNEL_VER_CODE │ $KSU_VER_CODE"
    bin_dir="/data/adb/ksu/bin"
elif [ "$MAGISK_VER_CODE" ]; then
    ui_print "- Magisk: $MAGISK_VER │ $MAGISK_VER_CODE"
else
    ui_print " ! Recovery is not supported."
    abort
fi

# Copy the script
if [ "$bin_dir" ] && [ -d "$bin_dir" ]; then
    cp "$MODPATH/system/bin/chroot-distro" "$bin_dir/chroot-distro"
    chmod 755 "$bin_dir/chroot-distro"
    touch "$MODPATH/skip_mount"
fi

# Permissions
set_perm_recursive "$MODPATH/system" 0 0 0755 0755
