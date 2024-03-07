#!/system/bin/sh

if [ ! -d "/data/local/tmp/" ]; then
    mkdir /data/local/tmp/
fi
busybox wget -O /data/local/tmp/chroot-distro https://raw.githubusercontent.com/YasserNull/chroot-distro/main/chroot-distro

mount -o remount,rw /system/bin
cp /data/local/tmp/chroot-distro /system/bin
dos2unix /system/bin/chroot-distro
chmod +x /system/bin/chroot-distro
mount -o remount,ro /system/bin
