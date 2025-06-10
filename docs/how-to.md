## TODO: How-to Instructions

### Fixing Sudo

By default Android prevents suid usage under `/data` folder. This will prevent using `sudo` inside the rootfs. There is a few alternatives how this can be solved:

1. fix-suid (automatic)
The fix-suid feature is enabled automatically. It tries to remount /data with the correct suid and dev options, so sudo can work out of the box.
If you want to disable this and use another method, you can run:
```bash
chroot-distro fix-suid <enable|disable>
```
- enable : Forces enabling suid handling.
- disable: Disables automatic remount logic.

2. Image File Method
```bash
# Create image (adjust size as needed)
su -c truncate -S 15G /data/local/distros.img
su -c mke2fs -t ext4 /data/local/distros.img

# Mount after each reboot
su -c mount /data/local/distros.img /data/local/chroot-distro
```

3. SD Card Method  
https://xdaforums.com/t/mount-ext4-formatted-sd-card.3769344/
```
1. Format SD card with ext4
2. Mount to `/data/local/chroot-distro`
3. Remount after each reboot
```
Overall Note:
- Methods 2 & 3 are safer (prevent accidental command execution)
- SD Card Method advantages:
  - Saves internal storage space
  - Reduces wear on internal storage
  - Extends device lifespan
  - Note: You can't use it for Android stuff (at least by default)

### Custom Distribution Setup

1. **Add Distribution**  
   ```bash
   chroot-distro add <distro_name>
   ```

2. **Download Distribution**  
   ```bash
   chroot-distro download <distro_name> <download_link>
   ```

3. **Install Distribution**  
   ```bash
   chroot-distro install <distro_name>
   ```

4. **Login to Distribution**  
   ```bash
   chroot-distro login <distro_name>
   ```

### chroot-distro on GNU/Linux

Install the chroot-distro script on your GNU/Linux system using the following commands:

```bash
curl "https://raw.githubusercontent.com/Magisk-Modules-Alt-Repo/chroot-distro/refs/heads/main/system/bin/chroot-distro" > /bin/chroot-distro
dos2unix /bin/chroot-distro && chmod +x /bin/chroot-distro
sed -i '1s/\/system//g' /bin/chroot-distro
sudo CHROOT_DISTRO_MOUNT=false chroot-distro android-bind disable && sudo CHROOT_DISTRO_MOUNT=false chroot-distro fix-suid disable
```
