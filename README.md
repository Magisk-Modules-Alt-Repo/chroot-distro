# chroot-distro
chroot-distro :
  Install linux distributions on android

+ chroot-distro path : /data/local/chroot-distro/

## Installing

### Installation requirements

Reasonably new Busybox-ndk magisk module version installed (1.36.1 is known to work, 1.32.1 is known to not work). If new enough version is not installed it may lead to problems with downloading rootfs.

### Android paths on distributions :
+ /dev 
+ /sys
+ /proc
+ /dev/pts
+ /sdcard 
+ /system
+ /storage
+ /data

## Using

### Available commands

+ help
```
chroot-distro help
```
+ list of available linux distributions
```
chroot-distro list
```

+ download rootfs
```
chroot-distro download <distro>
```
+ redownload rootfs
```
chroot-distro redownload <distro>
```
+ delete rootfs 
```
chroot-distro delete <distro>
```

+ install distro
  + By default does not mount `/data` folder, use -d or --data to mount it
```
chroot-distro install [-d|--data] <distro>
```
+ reinstall distro
  + By default does not mount `/data` folder, use -d or --data to mount it
```
chroot-distro reinstall [-d|--data] <distro>
```
+ uninstall distro
```
chroot-distro uninstall <distro>
```

+ backup distro
  + If path given, then backup saved at that path
```
chroot-distro backup <distro> [<path>]
```
+ delete default backup
```
chroot-distro unbackup <distro>
```
+ restore distro
  + By default restores as is, use -d or --default to reset to default settings (note: only those set during install)
  + If path given, then backup restored from that path
```
chroot-distro restore [-d|--default] <distro> [<path>]
```

+ unmount system mount points
```
chroot-distro unmount <distro>
```

+ run command
  + By default runs command from under `/bin`, use --as-is to run any command but then path needs to be supplied
  + If command is quoted then can pass parameters to command, for example `"ping 127.0.0.1"`
```
chroot-distro command <distro> [--as-is] <command>
```
+ login to distro
```
chroot-distro login <distro> 
```

### example
```
chroot-distro download ubuntu
chroot-distro install ubuntu
chroot-distro login ubuntu
```

### supported distributions

Note: right side is used as distro identifier, and it needs to be lowercase for it to be properly identified.

+ Kali Linux : kali
+ Parrot OS : parrot
+ Alpine Linux : alpine
+ Arch Linux : archlinux
+ BackBox : backbox
+ Centos : centos
+ Centos Stream : centos_stream
+ Artix Linux : artix
+ Debian : debian
+ Deepin : deepin
+ Fedora 39 : fedora
+ Manjaro : manjaro
+ OpenKylin : openkylin
+ OpenSUSE : opensuse
+ Pardus : pardus
+ Ubuntu : ubuntu
+ Void Linux : void

### best features :
you can use chroot-distro on any terminal
like mt manager , termux , twrp , Android terminal emulator...

![Debian console](screenshot/debian.png)

![Kali Linux console](screenshot/kali-linux.png)

## How to enable ...

### vnc

![Debian GUI over VNC](screenshot/debian_vnc.png)

![Ubuntu GUI over VNC](screenshot/ubuntu.png)

your can use any vnc app , tutorial (tested on ubuntu and debian)
```
apt update
apt upgrade
apt install tightvncserver nano dbus-x11 xfce4 xfce4-goodies xfce4-terminal
update-alternatives --config x-terminal-emulator
vncserver
vncserver -kill :1
echo 'startxfce4 &' >> ~/.vnc/xstartup
```
start server : 
```
vncserver
```
stop server :
```
vncserver -kill :1
```

### sudo

Be default Android prevents suid usage under `/data` folder. This will prevent using `sudo` inside the rootfs. There is a few alternatives how this can be solved:

+ remount `/data` for the current process with needed capabilities (needs to be run once for every session)
```sh
su -c mount -o remount,dev,suid /data
```
+ create an image to be mounted at `/data/local/chroot-distro`
```sh
# use whatever size you want
su -c truncate -S 15G /data/local/distros.img
su -c mke2fs -t ext4 /data/local/distros.img
# following command needs to be run every time device is rebooted
su -c mount /data/local/distros.img /data/local/chroot-distro
```
+ Format SD card with ext4
  + Follow the instructions on [how to mount ext4 SD card](https://xdaforums.com/t/mount-ext4-formatted-sd-card.3769344/)
  + Mount point should be `/data/local/chroot-distro` instead of `/storage/sdcard1` mentioned in the post
  + Mounting will need to be done every time device is rebooted

From security perspective the second and third one are the better as there is less of chance to accidentally running something which you did not intend. The third one (and second one if the image is created to SD card) helps preventing the internal storage from running out and also helps lessen the amount of writes done to internal storage (thus prolonging the use of the device). Note that when using third alternative you can't use it for android stuff (at least by default).

## Install chroot-distro

+ [module](https://github.com/YasserNull/chroot-distro/releases/tag/module)

## License

[GNU GPL v3](LICENSE)
