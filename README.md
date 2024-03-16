# chroot-distro
chroot-distro :
  Install linux distributions on android

+ chroot-distro path : /data/local/chroot-distro/

### Android paths on distributions :
+ /dev 
+ /sys
+ /proc
+ /dev/pts
+ /sdcard 
+ /system
+ /storage
+ /data

### usage
![Screenshot of a comment on a GitHub issue showing an image, added in the Markdown, of an Octocat smiling and raising a tentacle.](https://github.com/YasserNull/chroot-distro/blob/main/screenshot/help.png)

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
```
chroot-distro install <distro>
```
+ reinstall distro
```
chroot-distro reinstall <distro>
```
+ uninstall distro
```
chroot-distro uninstall <distro>
```

+ backup distro
```
chroot-distro backup <distro>
```
+ backup distro with custom path
```
chroot-distro backup <distro> <path>
```
+ delete backup
```
chroot-distro unbackup <distro>
```
+ restore distro
```
chroot-distro restore <distro>
```
+ restore distro with custom path
```
chroot-distro restore <distro> <path>
```

+ run command
```
chroot-distro command <distro>
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
+ kali : Kali Linux
+ parrot : Parrot OS
+ alpine : Alpine Linux
+ archlinux : Arch Linux
+ BackBox : backbox
+ Centos : centos
+ Centos Stream : centos_stream
+ artix : Artix Linux
+ debian : Debian
+ deepin : Deepin
+ fedora : Fedora 39
+ manjaro : Manjaro 
+ openkylin : OpenKylin 
+ opensuse : OpenSUSE
+ pardus : Pardus 
+ ubuntu : Ubuntu
+ void : Void Linux

### best features :
you can use chroot-distro on any terminal
like mt manger , termux , twrp , Android terminal emulator...
![Screenshot of a comment on a GitHub issue showing an image, added in the Markdown, of an Octocat smiling and raising a tentacle.](https://github.com/YasserNull/chroot-distro/blob/main/screenshot/debian.png)
![Screenshot of a comment on a GitHub issue showing an image, added in the Markdown, of an Octocat smiling and raising a tentacle.](https://github.com/YasserNull/chroot-distro/blob/main/screenshot/kali-linux.png)
### vnc
![Screenshot of a comment on a GitHub issue showing an image, added in the Markdown, of an Octocat smiling and raising a tentacle.](https://github.com/YasserNull/chroot-distro/blob/main/screenshot/debian_vnc.png)
![Screenshot of a comment on a GitHub issue showing an image, added in the Markdown, of an Octocat smiling and raising a tentacle.](https://github.com/YasserNull/chroot-distro/blob/main/screenshot/ubuntu.png)
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
### Install chroot-distro

+ [module](https://github.com/YasserNull/chroot-distro/releases/tag/module)
