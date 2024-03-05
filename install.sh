if [ ! -d "/data/local/tmp/" ]; then
    mkdir /data/local/tmp/
fi
curl -o /data/local/tmp/chroot-distro https://raw.githubusercontent.com/YasserNull/chroot-distro/main/chroot-distro
if [ ! -d "/system/etc/init.d/" ]; then
    mkdir /system/etc/init.d/
fi
curl -o /system/etc/init.d/chroot-distro.rc https://raw.githubusercontent.com/YasserNull/chroot-distro/main/chroot-distro.rc
