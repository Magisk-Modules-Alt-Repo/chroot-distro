#!/system/bin/sh

if [ ! -d "/data/local/tmp/" ]; then
    mkdir /data/local/tmp/
fi
curl -o /data/local/tmp/chroot-distro https://raw.githubusercontent.com/YasserNull/chroot-distro/main/chroot-distro

curl -o /data/local/tmp/chroot-distro.rc https://raw.githubusercontent.com/YasserNull/chroot-distro/main/chroot-distro.rc
chmod +x /data/local/tmp/chroot-distro.rc
/system/bin/su /data/local/tmp/chroot-distro.rc &
mount -o remount,rw /system/bin
cp /data/local/tmp/chroot-distro /system/bin
chmod +x /system/bin/chroot-distro
dos2unix chroot-distro
mount -o remount,ro /system/bin
