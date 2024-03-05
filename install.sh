#!/system/bin/sh

if [ ! -d "/data/local/tmp/" ]; then
    mkdir /data/local/tmp/
fi
curl -o /data/local/tmp/chroot-distro https://raw.githubusercontent.com/YasserNull/chroot-distro/main/chroot-distro

curl -o /data/local/tmp/chroot-distro.rc https://raw.githubusercontent.com/YasserNull/chroot-distro/main/chroot-distro.rc
chmod 755 /data/local/tmp/chroot-distro.rc
while IFS= read -r line; do
$line/su /data/local/tmp/chroot-distro.rc &
    mount -o remount,rw $line
   cp /data/local/tmp/chroot-distro $line
   mount -o remount,rw $line
done <<< "$PATH | tr ':' '\n'"
