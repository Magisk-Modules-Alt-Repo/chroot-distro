#!/system/bin/sh

# ANSI color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# List of URLs to check (extracted from the provided script)
urls=(
    # Ubuntu
    "https://cdimage.ubuntu.com/ubuntu-base/releases/trusty/release/ubuntu-base-14.04.6-base-i386.tar.gz"
    "https://cdimage.ubuntu.com/ubuntu-base/releases/trusty/release/ubuntu-base-14.04.6-base-arm64.tar.gz"
    "https://cdimage.ubuntu.com/ubuntu-base/releases/trusty/release/ubuntu-base-14.04.6-base-armhf.tar.gz"
    "https://cdimage.ubuntu.com/ubuntu-base/releases/trusty/release/ubuntu-base-14.04.6-base-amd64.tar.gz"
    "https://cdimage.ubuntu.com/ubuntu-base/releases/xenial/release/ubuntu-base-16.04.6-base-i386.tar.gz"
    "https://cdimage.ubuntu.com/ubuntu-base/releases/xenial/release/ubuntu-base-16.04.6-base-arm64.tar.gz"
    "https://cdimage.ubuntu.com/ubuntu-base/releases/xenial/release/ubuntu-base-16.04.6-base-armhf.tar.gz"
    "https://cdimage.ubuntu.com/ubuntu-base/releases/xenial/release/ubuntu-base-16.04.6-base-amd64.tar.gz"
    "https://cdimage.ubuntu.com/ubuntu-base/releases/bionic/release/ubuntu-base-18.04.5-base-i386.tar.gz"
    "https://cdimage.ubuntu.com/ubuntu-base/releases/bionic/release/ubuntu-base-18.04.5-base-arm64.tar.gz"
    "https://cdimage.ubuntu.com/ubuntu-base/releases/bionic/release/ubuntu-base-18.04.5-base-armhf.tar.gz"
    "https://cdimage.ubuntu.com/ubuntu-base/releases/bionic/release/ubuntu-base-18.04.5-base-amd64.tar.gz"
    "https://cdimage.ubuntu.com/ubuntu-base/releases/focal/release/ubuntu-base-20.04.5-base-arm64.tar.gz"
    "https://cdimage.ubuntu.com/ubuntu-base/releases/focal/release/ubuntu-base-20.04.5-base-armhf.tar.gz"
    "https://cdimage.ubuntu.com/ubuntu-base/releases/focal/release/ubuntu-base-20.04.5-base-amd64.tar.gz"
    "https://cdimage.ubuntu.com/ubuntu-base/releases/jammy/release/ubuntu-base-22.04.5-base-arm64.tar.gz"
    "https://cdimage.ubuntu.com/ubuntu-base/releases/jammy/release/ubuntu-base-22.04.5-base-armhf.tar.gz"
    "https://cdimage.ubuntu.com/ubuntu-base/releases/jammy/release/ubuntu-base-22.04.5-base-amd64.tar.gz"
    "https://cdimage.ubuntu.com/ubuntu-base/releases/noble/release/ubuntu-base-24.04.1-base-arm64.tar.gz"
    "https://cdimage.ubuntu.com/ubuntu-base/releases/noble/release/ubuntu-base-24.04.1-base-armhf.tar.gz"
    "https://cdimage.ubuntu.com/ubuntu-base/releases/noble/release/ubuntu-base-24.04.1-base-amd64.tar.gz"
    "https://cdimage.ubuntu.com/ubuntu-base/releases/oracular/release/ubuntu-base-24.10-base-arm64.tar.gz"
    "https://cdimage.ubuntu.com/ubuntu-base/releases/oracular/release/ubuntu-base-24.10-base-armhf.tar.gz"
    "https://cdimage.ubuntu.com/ubuntu-base/releases/oracular/release/ubuntu-base-24.10-base-amd64.tar.gz"
    "https://cdimage.ubuntu.com/ubuntu-base/releases/plucky/release/ubuntu-base-25.04-base-arm64.tar.gz"
    "https://cdimage.ubuntu.com/ubuntu-base/releases/plucky/release/ubuntu-base-25.04-base-armhf.tar.gz"
    "https://cdimage.ubuntu.com/ubuntu-base/releases/plucky/release/ubuntu-base-25.04-base-amd64.tar.gz"

    # Kali Linux
    "http://kali.download/nethunter-images/current/rootfs/kali-nethunter-rootfs-full-arm64.tar.xz"
    "http://kali.download/nethunter-images/current/rootfs/kali-nethunter-rootfs-full-armhf.tar.xz"
    "http://kali.download/nethunter-images/current/rootfs/kali-nethunter-rootfs-full-amd64.tar.xz"
    "http://kali.download/nethunter-images/current/rootfs/kali-nethunter-rootfs-full-i386.tar.xz"
    "http://kali.download/nethunter-images/current/rootfs/kali-nethunter-rootfs-minimal-arm64.tar.xz"
    "http://kali.download/nethunter-images/current/rootfs/kali-nethunter-rootfs-minimal-armhf.tar.xz"
    "http://kali.download/nethunter-images/current/rootfs/kali-nethunter-rootfs-minimal-amd64.tar.xz"
    "http://kali.download/nethunter-images/current/rootfs/kali-nethunter-rootfs-minimal-i386.tar.xz"
    "http://kali.download/nethunter-images/current/rootfs/kali-nethunter-rootfs-nano-arm64.tar.xz"
    "http://kali.download/nethunter-images/current/rootfs/kali-nethunter-rootfs-nano-armhf.tar.xz"
    "http://kali.download/nethunter-images/current/rootfs/kali-nethunter-rootfs-nano-amd64.tar.xz"
    "http://kali.download/nethunter-images/current/rootfs/kali-nethunter-rootfs-nano-i386.tar.xz"

    # Debian (AnLinux)
    "https://github.com/EXALAB/Anlinux-Resources/raw/master/Rootfs/Debian/arm64/debian-rootfs-arm64.tar.xz"
    "https://github.com/EXALAB/Anlinux-Resources/raw/master/Rootfs/Debian/armhf/debian-rootfs-armhf.tar.xz"
    "https://github.com/EXALAB/Anlinux-Resources/raw/master/Rootfs/Debian/amd64/debian-rootfs-amd64.tar.xz"
    "https://github.com/EXALAB/Anlinux-Resources/raw/master/Rootfs/Debian/i386/debian-rootfs-i386.tar.xz"

    # Debian (Proot-distro)
    "https://github.com/termux/proot-distro/releases/download/v4.7.0/debian-bullseye-aarch64-pd-v4.7.0.tar.xz"
    "https://github.com/termux/proot-distro/releases/download/v4.7.0/debian-bullseye-arm-pd-v4.7.0.tar.xz"
    "https://github.com/termux/proot-distro/releases/download/v4.7.0/debian-bullseye-x86_64-pd-v4.7.0.tar.xz"
    "https://github.com/termux/proot-distro/releases/download/v4.7.0/debian-bullseye-i686-pd-v4.7.0.tar.xz"
    "https://github.com/termux/proot-distro/releases/download/v4.7.0/debian-bookworm-aarch64-pd-v4.7.0.tar.xz"
    "https://github.com/termux/proot-distro/releases/download/v4.7.0/debian-bookworm-arm-pd-v4.7.0.tar.xz"
    "https://github.com/termux/proot-distro/releases/download/v4.7.0/debian-bookworm-x86_64-pd-v4.7.0.tar.xz"
    "https://github.com/termux/proot-distro/releases/download/v4.7.0/debian-bookworm-i686-pd-v4.7.0.tar.xz"

    # Parrot OS
    "https://github.com/EXALAB/Anlinux-Resources/raw/master/Rootfs/Parrot/arm64/parrot-rootfs-arm64.tar.xz"
    "https://github.com/EXALAB/Anlinux-Resources/raw/master/Rootfs/Parrot/armhf/parrot-rootfs-armhf.tar.xz"
    "https://github.com/EXALAB/Anlinux-Resources/raw/master/Rootfs/Parrot/amd64/parrot-rootfs-amd64.tar.xz"
    "https://github.com/EXALAB/Anlinux-Resources/raw/master/Rootfs/Parrot/i386/parrot-rootfs-i386.tar.xz"

    # Arch Linux
    "http://ca.us.mirror.archlinuxarm.org/os/ArchLinuxARM-armv7-latest.tar.gz"
    "http://ca.us.mirror.archlinuxarm.org/os/ArchLinuxARM-aarch64-latest.tar.gz"
    "https://mirrors.ocf.berkeley.edu/archlinux/iso/latest/archlinux-bootstrap-x86_64.tar.gz"

    # Artix Linux
    "https://github.com/termux/proot-distro/releases/download/v4.6.0/artix-aarch64-pd-v4.6.0.tar.xz"

    # Deepin
    "https://github.com/termux/proot-distro/releases/download/v4.16.0/deepin-aarch64-pd-v4.16.0.tar.xz"
    "https://github.com/termux/proot-distro/releases/download/v4.16.0/deepin-x86_64-pd-v4.16.0.tar.xz"

    # Fedora
    "https://github.com/termux/proot-distro/releases/download/v4.24.0/fedora-aarch64-pd-v4.24.0.tar.xz"
    "https://github.com/termux/proot-distro/releases/download/v4.23.0/fedora-aarch64-pd-v4.23.0.tar.xz"
    "https://github.com/termux/proot-distro/releases/download/v4.17.3/fedora-aarch64-pd-v4.17.3.tar.xz"
    "https://github.com/termux/proot-distro/releases/download/v4.15.0/fedora-aarch64-pd-v4.15.0.tar.xz"
    "https://github.com/termux/proot-distro/releases/download/v4.24.0/fedora-x86_64-pd-v4.24.0.tar.xz"
    "https://github.com/termux/proot-distro/releases/download/v4.23.0/fedora-x86_64-pd-v4.23.0.tar.xz"
    "https://github.com/termux/proot-distro/releases/download/v4.17.3/fedora-x86_64-pd-v4.17.3.tar.xz"
    "https://github.com/termux/proot-distro/releases/download/v4.15.0/fedora-x86_64-pd-v4.15.0.tar.xz"

    # OpenKylin
    "https://github.com/termux/proot-distro/releases/download/v4.10.0/openkylin-aarch64-pd-v4.10.0.tar.xz"
    "https://github.com/termux/proot-distro/releases/download/v4.10.0/openkylin-x86_64-pd-v4.10.0.tar.xz"

    # Pardus
    "https://github.com/termux/proot-distro/releases/download/v4.6.0/pardus-aarch64-pd-v4.6.0.tar.xz"
    "https://github.com/termux/proot-distro/releases/download/v4.6.0/pardus-x86_64-pd-v4.6.0.tar.xz"
    "https://github.com/termux/proot-distro/releases/download/v4.6.0/pardus-i686-pd-v4.6.0.tar.xz"

    # OpenSuse
    "https://github.com/termux/proot-distro/releases/download/v4.6.0/opensuse-aarch64-pd-v4.6.0.tar.xz"
    "https://github.com/termux/proot-distro/releases/download/v4.6.0/opensuse-arm-pd-v4.6.0.tar.xz"
    "https://github.com/termux/proot-distro/releases/download/v4.6.0/opensuse-x86_64-pd-v4.6.0.tar.xz"
    "https://github.com/termux/proot-distro/releases déplacer/download/v4.6.0/opensuse-i686-pd-v4.6.0.tar.xz"

    # BackBox
    "https://github.com/EXALAB/Anlinux-Resources/raw/master/Rootfs/BackBox/arm64/backbox-rootfs-arm64.tar.xz"
    "https://github.com/EXALAB/Anlinux-Resources/raw/master/Rootfs/BackBox/armhf/backbox-rootfs-armhf.tar.xz"
    "https://github.com/EXALAB/Anlinux-Resources/raw/master/Rootfs/BackBox/amd64/backbox-rootfs-amd64.tar.xz"
    "https://github.com/EXALAB/Anlinux-Resources/raw/master/Rootfs/BackBox/i386/backbox-rootfs-i386.tar.xz"

    # CentOS
    "https://github.com/EXALAB/Anlinux-Resources/raw/master/Rootfs/CentOS/arm64/centos-rootfs-arm64.tar.xz"
    "https://github.com/EXALAB/Anlinux-Resources/raw/master/Rootfs/CentOS/amd64/centos-rootfs-amd64.tar.xz"

    # CentOS Stream
    "https://github.com/EXALAB/Anlinux-Resources/raw/master/Rootfs/CentOS_Stream/arm64/centos_stream-rootfs-arm64.tar.xz"
    "https://github.com/EXALAB/Anlinux-Resources/raw/master/Rootfs/CentOS_Stream/amd64/centos_stream-rootfs-amd64.tar.xz"

    # Rocky
    "https://github.com/termux/proot-distro/releases/download/v4.20.0/rocky-aarch64-pd-v4.20.0.tar.xz"
    "https://github.com/termux/proot-distro/releases/download/v4.20.0/rocky-x86_64-pd-v4.20.0.tar.xz"

    # Adelie
    "https://distfiles.adelielinux.org/adelie/1.0-beta6/iso/adelie-rootfs-full-aarch64-1.0-beta6-20241223.txz"
    "https://distfiles.adelielinux.org/adelie/1.0-beta6/iso/adelie-rootfs-minimal-aarch64-1.0-beta6-20241223.txz"
    "https://distfiles.adelielinux.org/adelie/1.0-beta6/iso/adelie-rootfs-full-armv7-1.0-beta6-20241223.txz"
    "https://distfiles.adelielinux.org/adelie/1.0-beta6/iso/adelie-rootfs-minimal-armv7-1.0-beta6-20241223.txz"
    "https://distfiles.adelielinux.org/adelie/1.0-beta6/iso/adelie-rootfs-full-x86_64-1.0-beta6-20241223.txz"
    "https://distfiles.adelielinux.org/adelie/1.0-beta6/iso/adelie-rootfs-minimal-x86_64-1.0-beta6-20241223.txz"

    # Chimera
    "https://repo.chimera-linux.org/live/20250420/chimera-linux-aarch64-ROOTFS-20250420-full.tar.gz"
    "https://repo.chimera-linux.org/live/20250420/chimera-linux-aarch64-ROOTFS-20250420-bootstrap.tar.gz"
    "https://repo.chimera-linux.org/live/20250420/chimera-linux-x86_64-ROOTFS-20250420-full.tar.gz"
    "https://repo.chimera-linux.org/live/20250420/chimera-linux-x86_64-ROOTFS-20250420-bootstrap.tar.gz"

    # Gentoo
    "https://distfiles.gentoo.org/releases/arm64/autobuilds/current-stage3-arm64-openrc/stage3-arm64-openrc-20250420T230518Z.tar.xz"
    "https://distfiles.gentoo.org/releases/amd64/autobuilds/current-stage3-amd64-openrc/stage3-amd64-openrc-20250420T121009Z.tar.xz"
    "https://distfiles.gentoo.org/releases/arm/autobuilds/current-stage3-armv7a-openrc/stage3-armv7a-openrc-20250416T215027Z.tar.xz"
    "https://distfiles.gentoo.org/releases/x86/autobuilds/current-stage3-i686-openrc/stage3-i686-openrc-20250414T165036Z.tar.xz"

    # Void Linux
    "https://repo-default.voidlinux.org/live/20240314/void-aarch64-ROOTFS-20240314.tar.xz"
    "https://repo-default.voidlinux.org/live/20240314/void-x86_64-ROOTFS-20240314.tar.xz"
    "https://repo-default.voidlinux.org/live/20240314/void-i686-ROOTFS-20240314.tar.xz"
    "https://repo-default.voidlinux.org/live/20240314/void-armv7l-ROOTFS-20240314.tar.xz"
    "https://repo-default.voidlinux.org/live/20230628/void-aarch64-ROOTFS-20230628.tar.xz"
    "https://repo-default.voidlinux.org/live/20230628/void-x86_64-ROOTFS-20230628.tar.xz"
    "https://repo-default.voidlinux.org/live/20230628/void-i686-ROOTFS-20230628.tar.xz"
    "https://repo-default.voidlinux.org/live/20230628/void-armv7l-ROOTFS-20230628.tar.xz"
    "https://repo-default.voidlinux.org/live/20221001/void-aarch64-ROOTFS-20221001.tar.xz"
    "https://repo-default.voidlinux.org/live/20221001/void-x86_64-ROOTFS-20221001.tar.xz"
    "https://repo-default.voidlinux.org/live/20221001/void-i686-ROOTFS-20221001.tar.xz"
    "https://repo-default.voidlinux.org/live/20221001/void-armv7l-ROOTFS-20221001.tar.xz"
    "https://repo-default.voidlinux.org/live/20210930/void-aarch64-ROOTFS-20210930.tar.xz"
    "https://repo-default.voidlinux.org/live/20210930/void-x86_64-ROOTFS-20210930.tar.xz"
    "https://repo-default.voidlinux.org/live/20210930/void-i686-ROOTFS-20210930.tar.xz"
    "https://repo-default.voidlinux.org/live/20210930/void-armv7l-ROOTFS-20210930.tar.xz"
    "https://repo-default.voidlinux.org/live/20210316/void-aarch64-ROOTFS-20210316.tar.xz"
    "https://repo-default.voidlinux.org/live/20210316/void-x86_64-ROOTFS-20210316.tar.xz"
    "https://repo-default.voidlinux.org/live/20210316/void-i686-ROOTFS-20210316.tar.xz"
    "https://repo-default.voidlinux.org/live/20210316/void-armv7l-ROOTFS-20210316.tar.xz"
    "https://repo-default.voidlinux.org/live/20210218/void-aarch64-ROOTFS-20210218.tar.xz"
    "https://repo-default.voidlinux.org/live/20210218/void-x86_64-ROOTFS-20210218.tar.xz"
    "https://repo-default.voidlinux.org/live/20210218/void-i686-ROOTFS-20210218.tar.xz"
    "https://repo-default.voidlinux.org/live/20210218/void-armv7l-ROOTFS-20210218.tar.xz"
)

# Function to check if a URL is accessible
check_url() {
    local url="$1"
    # Use curl to check if the URL is accessible (HTTP 200 or 302 for redirects)
    if curl --output /dev/null --silent --head --fail "$url" 2>/dev/null; then
        echo -e "${GREEN}Valid: $url${NC}"
    else
        echo -e "${RED}Invalid: $url${NC}"
    fi
}

# Main loop to check each URL
echo "Checking URLs..."
for url in "${urls[@]}"; do
    check_url "$url"
done

# Note about dynamic URLs
echo -e "\n${RED}Note:${NC} URLs for Alpine and Void Linux (current) are dynamic and require runtime fetching of the latest version. These are not included in this check. Please specify exact versions or run the original script to resolve them."
