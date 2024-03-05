#!/bin/sh
#Credit : @YasserNull
chroot_distro_path="/data/local/chroot-distro"

if [ "$(whoami)" != "root" ]; then
    echo "\033[1m\033[91mRoot access required.\033[0m"
    exit
fi

if [ "$(uname -o)" != "Android" ]; then
    echo "\033[1m\033[91mAndroid operating system required.\033[0m"
    exit
fi

if [ ! -d "$chroot_distro_path/" ]; then
    mkdir $chroot_distro_path/
fi

if [ ! -d "$chroot_distro_path/list/" ]; then
    mkdir $chroot_distro_path/list/
fi

machine_hardware=$(uname -m)
arm=$(echo ${machine_hardware} | cut -c 1-3)
aarch64=$(echo ${machine_hardware} | cut -c 1-7)
x86_64=$(echo ${machine_hardware} | cut -c 1-6)
i686=$(echo ${machine_hardware} | cut -c 1-4)
machine_hardware_type=""

if [ "$arm" = "arm" ]; then
    machine_hardware_type="arm"
elif [ "$aarch64" = "aarch64" ]; then
    machine_hardware_type="aarch64"
elif [ "$x86_64" = "x86_64" ]; then
    machine_hardware_type="x86_64"
elif [ "$i686" = "i686" ]; then
    machine_hardware_type="i686"    
else
    echo "\033[1mUnsupported machine hardware: \033[91m$machine_hardware\033[0m"
    exit
fi

chroot_distro_list_() {
if [ -f "$chroot_distro_path/list/$1.tar.xz" ]; then
        echo "\033[1mDownloaded: \033[92mYes\033[0m"
    else
        echo "\033[1mDownloaded: \033[91mNo\033[0m"
    fi
    if [ -d "$chroot_distro_path/$1/" ]; then
        echo "\033[1mInstalled: \033[92mYes\033[0m\n"
    else
        echo "\033[1mInstalled: \033[91mNo\033[0m\n"
    fi
}
chroot_distro_list() {
    echo "\033[1mMachine hardware: \033[92m$machine_hardware\n"
echo "\033[0m\033[1malpine : Alpine Linux"
    chroot_distro_list_ alpine
if [ "$machine_hardware_type" = "arm" ] || [ "$machine_hardware_type" = "aarch64" ]; then
echo "\033[0m\033[1marchlinux : Arch Linux"
    chroot_distro_list_ archlinux
fi
if [ "$machine_hardware_type" = "aarch64" ]; then
echo "\033[0m\033[1martix : Artix Linux"
    chroot_distro_list_ artix
fi
echo "\033[0m\033[1mdebian : Debian"
    chroot_distro_list_ debian
if [ "$machine_hardware_type" = "x86_64" ] || [ "$machine_hardware_type" = "aarch64" ]; then
echo "\033[0m\033[1mdeepin : Deepin"
    chroot_distro_list_ deepin
fi
if [ "$machine_hardware_type" = "x86_64" ] || [ "$machine_hardware_type" = "aarch64" ]; then
echo "\033[0m\033[1mfedora : Fedora 39"
    chroot_distro_list_ fedora
fi
if [ "$machine_hardware_type" = "aarch64" ]; then
echo "\033[0m\033[1mmanjaro : Manjaro"
    chroot_distro_list_ manjaro
fi
if [ "$machine_hardware_type" = "x86_64" ] || [ "$machine_hardware_type" = "aarch64" ]; then
echo "\033[0m\033[1mopenkylin : Openkylin"
    chroot_distro_list_ openkylin
fi
echo "\033[0m\033[1mopensuse : Opensuse"
    chroot_distro_list_ opensuse
if [ "$machine_hardware_type" = "x86_64" ] || [ "$machine_hardware_type" = "aarch64" ] || [ "$machine_hardware_type" = "i686" ]; then
echo "\033[0m\033[1mpardus : Pardus"
    chroot_distro_list_ pardus
fi
if [ "$machine_hardware_type" = "x86_64" ] || [ "$machine_hardware_type" = "aarch64" ] || [ "$machine_hardware_type" = "arm" ]; then
    echo "\033[0m\033[1mubuntu : Ubuntu"
    chroot_distro_list_ ubuntu
fi
   echo "\033[0m\033[1mvoid : Void"
    chroot_distro_list_ void
}

chroot_distro_download() {
    distro="$1"
    
    if [ "$distro" = "ubuntu" ]; then
echo "\033[1m
1) ubuntu: Ubuntu (23.10)
2) ubuntu-lts: Ubuntu (22.04)
3) ubuntu-oldlts: Ubuntu (20.04)"
        while true; do
            printf "Enter a number : "
            read number
            case "$number" in
                1) distro_version="mantic"; break;;
                2) distro_version="jammy"; break;;
                3) distro_version="focal"; break;;
                *) echo "\033[0m\033[1m\033[91mUnknown option : $number";;
            esac
        done
        
        tarball_path="$chroot_distro_path/list/ubuntu.tar.xz"
        
        if [ ! -f "$tarball_path" ]; then
            wget -O "$tarball_path" "https://github.com/termux/proot-distro/releases/download/v4.8.0/ubuntu-$distro_version-$machine_hardware_type-pd-v4.8.0.tar.xz"
        else
            echo "\033[0m\033[1m\033[91mAlready downloaded."
        fi

elif [ "$distro" = "debian" ]; then
echo "\033[1m
1) debian : debian stable
2) debian-oldstable : debian old stable"
        while true; do
            printf "Enter a number : "
            read number
            case "$number" in
                1) distro_version="bookworm"; break;;
                2) distro_version="bullseye"; break;;
                *) echo "\033[0m\033[1m\033[91mUnknown option : $number";;
            esac
        done
        
        tarball_path="$chroot_distro_path/list/debian.tar.xz"
        
        if [ ! -f "$tarball_path" ]; then
            wget -O "$tarball_path" "https://github.com/termux/proot-distro/releases/download/v4.7.0/debian-$distro_version-$machine_hardware_type-pd-v4.7.0.tar.xz"
        else
            echo "\033[0m\033[1m\033[91mAlready downloaded."
        fi
elif [ "$distro" = "alpine" ]; then     
        tarball_path="$chroot_distro_path/list/alpine.tar.xz"
        
        if [ ! -f "$tarball_path" ]; then
            wget -O "$tarball_path" "https://github.com/termux/proot-distro/releases/download/v4.6.0/alpine-$machine_hardware_type-pd-v4.6.0.tar.xz"
        else
            echo "\033[0m\033[1m\033[91mAlready downloaded."
        fi
elif [ "$distro" = "archlinux" ]; then     
        tarball_path="$chroot_distro_path/list/archlinux.tar.xz"
        
        if [ ! -f "$tarball_path" ]; then
            wget -O "$tarball_path" "https://github.com/termux/proot-distro/releases/download/v4.6.0/archlinux-$machine_hardware_type-pd-v4.6.0.tar.xz"
        else
            echo "\033[0m\033[1m\033[91mAlready downloaded."
        fi
elif [ "$distro" = "artix" ]; then     
        tarball_path="$chroot_distro_path/list/artix.tar.xz"
        
        if [ ! -f "$tarball_path" ]; then
            wget -O "$tarball_path" "https://github.com/termux/proot-distro/releases/download/v4.6.0/artix-$machine_hardware_type-pd-v4.6.0.tar.xz"
        else
            echo "\033[0m\033[1m\033[91mAlready downloaded."
        fi
elif [ "$distro" = "deepin" ]; then     
        tarball_path="$chroot_distro_path/list/deepin.tar.xz"
        
        if [ ! -f "$tarball_path" ]; then
            wget -O "$tarball_path" "https://github.com/termux/proot-distro/releases/download/v4.3.1/deepin-$machine_hardware_type-pd-v4.3.1-2.tar.xz"
        else
            echo "\033[0m\033[1m\033[91mAlready downloaded."
        fi
elif [ "$distro" = "fedora" ]; then     
        tarball_path="$chroot_distro_path/list/fedora.tar.xz"
        
        if [ ! -f "$tarball_path" ]; then
            wget -O "$tarball_path" "https://github.com/termux/proot-distro/releases/download/v4.6.0/fedora-$machine_hardware_type-pd-v4.6.0.tar.xz"
        else
            echo "\033[0m\033[1m\033[91mAlready downloaded."
        fi
elif [ "$distro" = "manjaro" ]; then     
        tarball_path="$chroot_distro_path/list/manjaro.tar.xz"
        
        if [ ! -f "$tarball_path" ]; then
            wget -O "$tarball_path" "https://github.com/termux/proot-distro/releases/download/v4.6.0/manjaro-$machine_hardware_type-pd-v4.6.0.tar.xz"
        else
            echo "\033[0m\033[1m\033[91mAlready downloaded."
        fi
elif [ "$distro" = "openkylin" ]; then     
        tarball_path="$chroot_distro_path/list/openkylin.tar.xz"
        
        if [ ! -f "$tarball_path" ]; then
            wget -O "$tarball_path" "https://github.com/termux/proot-distro/releases/download/v4.6.0/openkylin-$machine_hardware_type-pd-v4.6.0.tar.xz"
        else
            echo "\033[0m\033[1m\033[91mAlready downloaded."
        fi
elif [ "$distro" = "opensuse" ]; then     
        tarball_path="$chroot_distro_path/list/opensuse.tar.xz"
        
        if [ ! -f "$tarball_path" ]; then
            wget -O "$tarball_path" "https://github.com/termux/proot-distro/releases/download/v4.6.0/opensuse-$machine_hardware_type-pd-v4.6.0.tar.xz"
        else
            echo "\033[0m\033[1m\033[91mAlready downloaded."
        fi
elif [ "$distro" = "pardus" ]; then     
        tarball_path="$chroot_distro_path/list/pardus.tar.xz"
        
        if [ ! -f "$tarball_path" ]; then
            wget -O "$tarball_path" "https://github.com/termux/proot-distro/releases/download/v4.6.0/pardus-$machine_hardware_type-pd-v4.6.0.tar.xz"
        else
            echo "\033[0m\033[1m\033[91mAlready downloaded."
        fi
elif [ "$distro" = "void" ]; then     
        tarball_path="$chroot_distro_path/list/void.tar.xz"
        
        if [ ! -f "$tarball_path" ]; then
            wget -O "$tarball_path" "https://github.com/termux/proot-distro/releases/download/v4.6.0/void-$machine_hardware_type-pd-v4.6.0.tar.xz"
        else
            echo "\033[0m\033[1m\033[91mAlready downloaded."
        fi
    else
        echo "\033[0m\033[1m\033[91mUnavailable distro: $distro"
    fi
}
chroot_distro_undownload_() {
if [ -f "$chroot_distro_path/list/$1.tar.xz" ]; then
            rm $chroot_distro_path/list/$1.tar.xz
        else
            echo "\033[0m\033[1m\033[91m$1 not downloaded"
            exit
        fi
}
chroot_distro_undownload() {
    if [ "$1" = "alpine" ] || [ "$1" = "archlinux" ] || [ "$1" = "artix" ] || [ "$1" = "debian" ] || [ "$1" = "deepin" ]  || [ "$1" = "fedora" ]  || [ "$1" = "manjaro" ]  || [ "$1" = "openkylin" ] || [ "$1" = "opensuse" ] || [ "$1" = "pardus" ] || [ "$1" = "ubuntu" ] || [ "$1" = "void" ]; then
        chroot_distro_delete_ $1      
    else
        echo "\033[0m\033[1m\033[91munavailable distro $1"
        exit
    fi    
}

chroot_distro_install_() {
     if [ -f "$chroot_distro_path/list/$1.tar.xz" ]; then
            if [ ! -d "$chroot_distro_path/$1" ]; then
                distro_path=$chroot_distro_path/$1
                tar -xf $chroot_distro_path/list/$1.tar.xz -C $chroot_distro_path/
                mv "$chroot_distro_path/$(basename $(tar -tf $chroot_distro_path/list/$1.tar.xz 2>/dev/null | head -n 1))" $chroot_distro_path/$1
                mount --bind /dev $distro_path/dev
                mount --bind /sys $distro_path/sys
                mount --bind /proc $distro_path/proc
                mount --bind /dev/pts $distro_path/dev/pts
                mkdir $distro_path/android
                mount -o bind / $distro_path/android/
                echo "nameserver 8.8.8.8" > $distro_path/etc/resolv.conf
echo "127.0.0.1 localhost" > $distro_path/etc/hosts

                chroot $distro_path /bin/su - root
            else
                echo "\033[0m\033[1m\033[91m$1 already installed"
                exit
            fi
        else
            echo "\033[0m\033[1m\033[91m$1 not downloaded" 
            exit
        fi
}
chroot_distro_install() {
    if [ "$1" = "alpine" ] || [ "$1" = "archlinux" ] || [ "$1" = "artix" ] || [ "$1" = "debian" ] || [ "$1" = "deepin" ]  || [ "$1" = "fedora" ]  || [ "$1" = "manjaro" ]  || [ "$1" = "openkylin" ] || [ "$1" = "opensuse" ] || [ "$1" = "pardus" ] || [ "$1" = "ubuntu" ] || [ "$1" = "void" ]; then
   chroot_distro_install_ $1
    else
        echo "\033[0m\033[1m\033[91munavailable distro $1"
        exit
    fi
}
chroot_distro_uninstall_() {
if [ -d "$chroot_distro_path/$1" ]; then
            umount -lf $chroot_distro_path/$1/* > /dev/null
            rm -rf $chroot_distro_path/$1
        else
            echo "\033[0m\033[1m\033[91m$1 not installed"
exit 
        fi
}
chroot_distro_uninstall() {
    if [ "$1" = "alpine" ] || [ "$1" = "archlinux" ] || [ "$1" = "artix" ] || [ "$1" = "debian" ] || [ "$1" = "deepin" ]  || [ "$1" = "fedora" ]  || [ "$1" = "manjaro" ]  || [ "$1" = "openkylin" ] || [ "$1" = "opensuse" ] || [ "$1" = "pardus" ] || [ "$1" = "ubuntu" ] || [ "$1" = "void" ]; then
        chroot_distro_uninstall_ $1
    else
        echo "\033[0m\033[1m\033[91munavailable distro $1"
        exit
    fi
}
chroot_distro_help() {
echo "\033[0m\033[1mchroot-distro : install linux distributions

usage :

chroot-distro help - \033[94mfor more information
\033[0m\033[1mchroot-distro list - \033[94mlist of available linux distributions

\033[0m\033[1mchroot-distro download <distro> - \033[94mdownload distro
\033[0m\033[1mchroot-distro redownload <distro> - \033[94mredownload distro
\033[0m\033[1mchroot-distro undownload <distro> - \033[94mundownload distro

\033[0m\033[1mchroot-distro install <distro> - \033[94minstall distro
\033[0m\033[1mchroot-distro reinstall <distro> - \033[94mreinstall distro
\033[0m\033[1mchroot-distro uninstall <distro> - \033[94muninstall distro

\033[0m\033[1mchroot-distro login <distro> - \033[94mlogin to distro
"
}

chroot_distro_login() {
    if [ "$1" = "alpine" ] || [ "$1" = "archlinux" ] || [ "$1" = "artix" ] || [ "$1" = "debian" ] || [ "$1" = "deepin" ]  || [ "$1" = "fedora" ]  || [ "$1" = "manjaro" ]  || [ "$1" = "openkylin" ] || [ "$1" = "opensuse" ] || [ "$1" = "pardus" ] || [ "$1" = "ubuntu" ] || [ "$1" = "void" ]; then
if [ -d "$chroot_distro_path/$1" ]; then
mount --bind /dev $chroot_distro_path/$1/dev
                mount --bind /sys $chroot_distro_path/$1/sys
                mount --bind /proc $chroot_distro_path/$1/proc
                mount --bind /dev/pts $chroot_distro_path/$1/dev/pts
                
                mount -o bind / $chroot_distro_path/$1/android/
chroot $chroot_distro_path/$1/ /bin/su - root
else
            echo "\033[0m\033[1m\033[91m$1 not installed" 
            exit
        fi
    else
        echo "\033[0m\033[1m\033[91munavailable distro $1"
        exit
    fi
}
if [ "$1" = "list" ]; then
    chroot_distro_list
 elif [ "$1" = "help" ]; then
    chroot_distro_help 
elif [ "$1" = "login" ]; then
    chroot_distro_login $2 
elif [ "$1" = "download" ]; then
    chroot_distro_download $2 
elif [ "$1" = "undownload" ]; then
    chroot_distro_undownload $2 
    elif [ "$1" = "redownload" ]; then
chroot_distro_undownload $2     
    chroot_distro_download $2     
elif [ "$1" = "install" ]; then
    chroot_distro_install $2 
elif [ "$1" = "uninstall" ]; then
    chroot_distro_uninstall $2 
    elif [ "$1" = "reinstall" ]; then
    chroot_distro_uninstall $2 
    chroot_distro_install $2 
else
    chroot_distro_help
fi