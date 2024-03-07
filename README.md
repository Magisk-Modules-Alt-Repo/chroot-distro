# chroot-distro
chroot-distro : 
  Install linux distributions on android    with chroot
> warning : this work only on rooted android devices
### usage
![Screenshot of a comment on a GitHub issue showing an image, added in the Markdown, of an Octocat smiling and raising a tentacle.](https://github.com/YasserNull/chroot-distro/blob/main/screenshot/help.png)
### examples
download distro file

`chroot-distro download alpine`

install 

`chroot-distro install alpine`

login

`chroot-distro login alpine`

### supported distributions
+ alpine: Alpine Linux
+ archlinux: Arch Linux
+ artix: Artix Linux
+ debian: Debian
+ deepin: Deepin
+ fedora: Fedora 39
+ manjaro: Manjaro 
+ openkylin: OpenKylin 
+ opensuse: OpenSUSE
+ pardus: Pardus 
+ ubuntu: Ubuntu
+ void: Void Linux

### best features :
you can use chroot-distro on any terminal
like mt manger , termux , twrp , Android terminal emulator...
![Screenshot of a comment on a GitHub issue showing an image, added in the Markdown, of an Octocat smiling and raising a tentacle.](https://github.com/YasserNull/chroot-distro/blob/main/screenshot/terminal.png)
### required :
+ android os
+ root
+ chroot
+ amount

### Install chroot-distro

+ magisk module
+ commands

### install with commands

install
```
busybox wget -O - https://github.com/YasserNull/chroot-distro/raw/main/install.sh | sh
```

if you restart your device :
```
mount -o remount,rw /system/bin && cp /data/local/tmp/chroot-distro /system/bin && dos2unix /system/bin/chroot-distro && chmod +x /system/bin/chroot-distro && mount -o remount,ro /system/bin
```
