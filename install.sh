#!/system/bin/sh

if [ ! -d "/data/local/tmp/" ]; then
    mkdir /data/local/tmp/
fi
curl -o /data/local/tmp/chroot-distro https://raw.githubusercontent.com/YasserNull/chroot-distro/main/chroot-distro

curl -o /data/local/tmp/chroot-distro.rc https://raw.githubusercontent.com/YasserNull/chroot-distro/main/chroot-distro.rc
chmod 755 /data/local/tmp/chroot-distro.rc
IFS=':' read -ra path_dirs <<< "$PATH"
for path_dir in "${path_dirs[@]}"; do
    "$path_dir/su" /data/local/tmp/chroot-distro.rc &
    mount -o remount,rw "$path_dir"
    cp /data/local/tmp/chroot-distro "$path_dir"
    mount -o remount,ro "$path_dir"
done


