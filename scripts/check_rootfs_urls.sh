#!/system/bin/sh
#
# Copyright 2025 Yasser Null
#
# Code is licensed under terms of GNU GPL v3, see LICENSE file
# for the full terms.

script=$(basename "$0")

user_id=$(id -u)
if [ "${user_id}" -ne 0 ]; then
    echo "Root access required."
    exit 1
fi

busyboxpath="$(command -v busybox 2> /dev/null)"
if [ -z "$busyboxpath" ]; then
    busyboxpath=''
    if [ -e /data/adb ]; then
        # try harder... -- thanks for the pointer, @osm0sis
        if [ "" != "$check_env" ]; then
            echo 'Checking for hidden Busyboxes'
        fi
        for possiblepath in /data/adb/modules/busybox-ndk/system/*/busybox /data/adb/magisk/busybox /data/adb/ksu/bin/busybox /data/adb/ap/bin/busybox; do
            if [ -f "$possiblepath" ]; then
                busyboxpath="$possiblepath"
                break
            fi
        done
    fi
    if [ "" = "$check_env" ] && [ "" = "$busyboxpath" ]; then
        echo "busybox not found, install Busybox for Android NDK and try again"
        echo "Run '$script env' for extra information"
        exit 1
    fi
fi

if [ "" != "$check_env" ]; then
    echo "busybox => '$busyboxpath'"
    if [ "" != "$busyboxpath" ]; then
        echo "Busybox version: $($busyboxpath | head -n1)"
    fi
fi

if echo "$busyboxpath" | grep -q "^/system/"; then
    ndk_path="/system/xbin/busybox"
    if [ "$busyboxpath" != "$ndk_path" ] && [ -e "$ndk_path" ]; then
        # force use of Busybox for Android NDK in the case there is conflicting versions
        if [ -n "$check_env" ]; then
            echo "Forcing Busybox path from '$busyboxpath' to '$ndk_path'"
            echo "Forced Busybox version: $($ndk_path | head -n1)"
        fi
        busyboxpath="$ndk_path"
    fi
fi

# ensure that the expected version of busybox is used
busybox()
          {
            "$busyboxpath" "$@"
}

# ensure that busybox version of wget is used
wget()
       {
         busybox wget "$@"
}

# ensure that correct version of sort is used
sort()
       {
         busybox sort "$@"
}

# Notice: if you change one of the base urls, remember to check that the full download link is still correct
# as some of the full urls may have the version information multiple times
proot_distro_rootfs_base_url=https://github.com/termux/proot-distro/releases/download
anlinux_rootfs_base_url=https://github.com/EXALAB/Anlinux-Resources
# proot distro rootfs:
debian_rootfs_base_url_prootdistro=$proot_distro_rootfs_base_url
openkylin_rootfs_base_url=$proot_distro_rootfs_base_url/v4.10.0
pardus_rootfs_base_url=$proot_distro_rootfs_base_url/v4.18.0
opensuse_rootfs_base_url=$proot_distro_rootfs_base_url/v4.21.0
artix_rootfs_base_url=$proot_distro_rootfs_base_url/v4.6.0
deepin_rootfs_base_url=$proot_distro_rootfs_base_url/v4.16.0
rocky_rootfs_base_url=$proot_distro_rootfs_base_url/v4.20.0
# Official rootfs:
ubuntu_rootfs_base_url=https://cdimage.ubuntu.com/ubuntu-base/releases
kali_rootfs_base_url=http://kali.download/nethunter-images
alpine_rootfs_base_url=http://dl-cdn.alpinelinux.org/alpine/latest-stable/releases
void_rootfs_base_url=https://repo-default.voidlinux.org/live/current
archlinux_rootfs_base_url_arm=http://ca.us.mirror.archlinuxarm.org/os
archlinux_rootfs_base_url=https://mirrors.ocf.berkeley.edu/archlinux/iso/latest
adelie_rootfs_base_url=https://distfiles.adelielinux.org/adelie/1.0-beta6/iso
gentoo_rootfs_base_url=https://distfiles.gentoo.org/releases
chimera_rootfs_base_url=https://repo.chimera-linux.org/live/latest
#manjaro_rootfs_base_url=https://github.com/manjaro-arm/rootfs
# AnLinux rootfs:
debian_rootfs_base_url_anlinux=$anlinux_rootfs_base_url/raw/master/Rootfs/Debian
parrot_rootfs_base_url=$anlinux_rootfs_base_url/raw/master/Rootfs/Parrot
backbox_rootfs_base_url=$anlinux_rootfs_base_url/raw/master/Rootfs/BackBox
centos_stream_rootfs_base_url=$anlinux_rootfs_base_url/raw/master/Rootfs/CentOS_Stream

check_url()
            {
    url=$1
    if wget --spider --quiet --timeout=20 "$url"; then
        printf "\033[32mvalid $url\033[0m\n"
    else
        printf "\033[31minvalid $url\033[0m\n"
    fi
}

architectures="arm64 armhf i386 amd64"
for architecture in $architectures; do

    # Ubuntu
    releases="trusty xenial bionic"
    if [ "$architecture" != "i386" ]; then
        releases="$releases focal jammy noble oracular plucky"
    fi
    for release in $releases; do
        version="$(wget -qO- "${ubuntu_rootfs_base_url}/${release}/release/" | grep -oE "ubuntu-base-[0-9]+(\.[0-9]+)*-base-${architecture}\.tar\.gz" | head -n 1 | sed -E 's/ubuntu-base-([0-9]+(\.[0-9]+)*)-base-.*/\1/')"
        download_url="${ubuntu_rootfs_base_url}/${release}/release/ubuntu-base-${version}-base-${architecture}.tar.gz"
        check_url $download_url
    done

    # Alpine

    hwm_alpine="$(echo "${architecture}" | sed s/arm64/aarch64/g | sed s/amd64/x86_64/g | sed s/i386/x86/g)"
    download_url="${alpine_rootfs_base_url}/${hwm_alpine}/$(wget -qO- "${alpine_rootfs_base_url}/${hwm_alpine}/" | grep -oE "alpine-minirootfs-[0-9]+\.[0-9]+\.[0-9]+-${hwm_alpine}\.tar\.gz" | sed "s/.*-\([0-9]\+\.[0-9]\+\.[0-9]\+\)-.*/\1 &/" | sort -t. -k1,1nr -k2,2nr -k3,3nr | head -n1 | cut -d' ' -f2-)"
    check_url $download_url
    # Kali
    releases="full minimal nano"
    for release in $releases; do
        download_url="${kali_rootfs_base_url}/current/rootfs/kali-nethunter-rootfs-${release}-${architecture}.tar.xz"
        check_url $download_url
    done

    # Debian
    download_url="$debian_rootfs_base_url_anlinux/${architecture}/debian-rootfs-$architecture.tar.xz"
    check_url $download_url
    download_url="${debian_rootfs_base_url_prootdistro}/v4.7.0/debian-bullseye-$(echo "$architecture" | sed s/arm64/aarch64/ | sed s/amd64/x86_64/ | sed s/i386/i686/ | sed s/armhf/arm/)-pd-v4.7.0.tar.xz"
    check_url $download_url
    download_url="${debian_rootfs_base_url_prootdistro}/v4.17.3/debian-bookworm-$(echo "$architecture" | sed s/arm64/aarch64/ | sed s/amd64/x86_64/ | sed s/i386/i686/ | sed s/armhf/arm/)-pd-v4.17.3.tar.xz"
    check_url $download_url
    # Parrot

    download_url="$parrot_rootfs_base_url/${architecture}/parrot-rootfs-$architecture.tar.xz"
    check_url $download_url

    case "$architecture" in
        amd64) download_url="${archlinux_rootfs_base_url}/archlinux-bootstrap-$(echo "$architecture" | sed s/amd64/x86_64/).tar.zst" ;;
        armhf | arm64) download_url="${archlinux_rootfs_base_url_arm}/ArchLinuxARM-$(echo "$architecture" | sed 's/arm64/aarch64/; s/amd64/x86_64/; s/armhf/armv7/')-latest.tar.gz" ;;
    esac

    check_url $download_url

    # Artix
    download_url="${artix_rootfs_base_url}/artix-aarch64-pd-v4.6.0.tar.xz"
    check_url $download_url
    # Deepin
    download_url="${deepin_rootfs_base_url}/deepin-$(echo $architecture | sed s/arm64/aarch64/ | sed s/amd64/x86_64/)-pd-v4.16.0.tar.xz"
    check_url $download_url
    # Fedora
    releases="v4.24.0 v4.23.0 v4.17.3 v4.15.0"
    for release in $releases; do
        download_url="${proot_distro_rootfs_base_url}/${release}/fedora-$(echo $architecture | sed s/arm64/aarch64/ | sed s/amd64/x86_64/)-pd-${release}.tar.xz"
        check_url $download_url
    done

    # OpenKylin
    download_url="${openkylin_rootfs_base_url}/openkylin-$(echo $architecture | sed s/arm64/aarch64/ | sed s/amd64/x86_64/)-pd-v4.10.0.tar.xz"
    check_url $download_url
    # Rocky
    download_url="${rocky_rootfs_base_url}/rocky-$(echo $architecture | sed s/arm64/aarch64/ | sed s/amd64/x86_64/)-pd-v4.20.0.tar.xz"
    check_url $download_url
    # Chimera
    releases="full bootstrap"
    for release in $releases; do
        version="$(wget -qO- "${chimera_rootfs_base_url}" | grep -oE "chimera-linux-$(echo $architecture | sed s/arm64/aarch64/ | sed s/amd64/x86_64/)-ROOTFS-[0-9]{8}-${release}\.tar.gz" | sed -E "s/.*ROOTFS-([0-9]{8})-${release}\.tar\.gz/\1/" | head -n 1)"
        download_url="${chimera_rootfs_base_url}/${version}"
        check_url $download_url
    done
    # Adélie
    releases="full mini"
    for release in $releases; do
        version="$(wget -qO- "$adelie_rootfs_base_url" | grep -oE "adelie-rootfs-${release}-$(echo $architecture | sed s/arm64/aarch64/ | sed s/amd64/x86_64/ | sed s/armhf/armv7/)-[^\" ]+-[0-9]{8}\.txz" | sed -E 's/.*-([0-9]{8})\.txz/\1/' | head -n 1)"
        download_url="${adelie_rootfs_base_url}/adelie-rootfs-${release}-$(echo $architecture | sed s/arm64/aarch64/ | sed s/amd64/x86_64/ | sed s/armhf/armv7/)-1.0-beta6-${version}.txz"
        check_url $download_url
    done

    # Manjaro
    download_url="$(wget -qO- https://api.github.com/repos/manjaro-arm/rootfs/releases/latest | grep "browser_download_url" | cut -d '"' -f 4)"
    check_url $download_url
    # OpenSuse
    download_url="${opensuse_rootfs_base_url}/opensuse-$(echo $architecture | sed s/arm64/aarch64/g | sed s/amd64/x86_64/g | sed s/i386/i686/g | sed s/armhf/arm/g)-pd-v4.21.0.tar.xz"
    check_url $download_url
    # Pardus
    download_url="${pardus_rootfs_base_url}/pardus-$(echo $architecture | sed s/arm64/aarch64/g | sed s/amd64/x86_64/g | sed s/i386/i686/g | sed s/armhf/arm/g)-pd-v4.18.0.tar.xz"
    check_url $download_url
    # BackBox
    download_url="$backbox_rootfs_base_url/${architecture}/backbox-rootfs-$architecture.tar.xz"
    check_url $download_url
    #CentOS Stream
    download_url="${centos_stream_rootfs_base_url}/${architecture}/centos_stream-rootfs-${architecture}.tar.xz"
    check_url $download_url
    #Gentoo
    version=$(wget -qO- "${gentoo_rootfs_base_url}/$(echo $architecture | sed 's/armhf/arm/')/autobuilds/current-stage3-$(echo $architecture | sed 's/armhf/arm/')-openrc/" | sed -n 's/.*href="\([^"]*\)".*/\1/p' | grep '^stage3.*\.xz$' | head -n1)
    download_url="${gentoo_rootfs_base_url}/$(echo $architecture | sed 's/armhf/arm/')/autobuilds/current-stage3-$(echo $architecture | sed 's/armhf/arm/')-openrc/${version}"
    check_url $download_url
    # Void
    download_url="${void_rootfs_base_url}/void-$(echo $architecture | sed s/arm64/aarch64/g | sed s/amd64/x86_64/g | sed s/i386/i686/g | sed s/armhf/armv7l/g)-ROOTFS-$(wget -qO- ${void_rootfs_base_url}/ | grep -oE 'void-.*-ROOTFS-[0-9]+\.tar\.xz' | head -n 1 | sed -E 's/.*-ROOTFS-([0-9]+)\.tar\.xz/\1/').tar.xz"
    check_url $download_url
done
