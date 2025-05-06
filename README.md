# chroot-distro
<p align="center">
  <img src="https://img.shields.io/github/downloads/Magisk-Modules-Alt-Repo/chroot-distro/total?label=Downloads"/>
  <img src="https://img.shields.io/github/v/release/Magisk-Modules-Alt-Repo/chroot-distro?include_prereleases&label=Release"/>
  <img src="https://img.shields.io/badge/License-GPLv3-blue.svg"/>
</p>

![](https://github.com/Magisk-Modules-Alt-Repo/chroot-distro/raw/main/images/chroot-distro.jpg) 

***chroot-distro***: Installs GNU/Linux distributions in a chroot environment on Android.  
> The idea is inspired by [proot-distro](https://github.com/termux/proot-distro).

+ Directory Structure
```
/data/local/chroot-distro/
├── .backup/           # Backup folder for distributions
├── .rootfs/           # Minimal root filesystem used for bootstrapping distributions
├── <distro>/          # Folder for each installed distribution (e.g., ubuntu, debian)
├── <distro>/          # Another folder for a different installed distribution
├── .config/           # Configuration folder for chroot-distro
│   ├── <distro>       # Empty file representing a custom distribution
│   ├── fix_suid       # File for handling SUID permission fixes
│   ├── ram_bind       # Configuration for RAM disk binding to improve performance
│   ├── android_bind   # Configuration for binding the Android environment with chroot
```
**Note:** If the system is not *Android*, the main path is `/opt/chroot-distro`

## Requirements

### Rooted Android Device
All root implementations are compatible.

You can use `chroot-distro` on any terminal, for example: MiXplorer, MT Manager, Termux, TWRP and Android Terminal Emulator (ADB Shell).

### BusyBox for Android NDK
Install the [latest BusyBox for Android NDK](https://github.com/osm0sis/android-busybox-ndk) by [osm0sis](https://github.com/osm0sis) Magisk module.  
- **Recommended:** v1.36.1 (stable)  
- **Avoid:** v1.32.1 (known bugs)  
- **Note:** Outdated versions may cause issues with rootfs downloads.

### Alternative BusyBox
- BusyBox from Magisk, KernelSU, or APatch (without the NDK module) is community-supported but may lead to bugs.
- Additionally, BusyBox that is automatically detected is also supported, such as the one provided by **Termux** or the user's environment.

## Distro Paths

### System Points
```
<distro>/
├── /dev
├── /sys
├── /proc
└── /dev/pts
```

### Optional Mounts

`chroot-distro android-bind <enable|disable>`: 

Binding all Android root directories not mounted by default for full environment access. 

## Supported Distributions
*Notes*: 
- Use lowercase identifiers for it to be properly identified.
- Some distributions may not support your device architecture. The main supported architectures are:
`armv7 arm64 i686 amd64`

| <img src="https://github.com/Magisk-Modules-Alt-Repo/chroot-distro/raw/main/images/ubuntu.png" width="50"><br> Ubuntu | <img src="https://github.com/Magisk-Modules-Alt-Repo/chroot-distro/raw/main/images/arch_linux.png" width="50"><br>    Arch    | <img src="https://github.com/Magisk-Modules-Alt-Repo/chroot-distro/raw/main/images/fedora.png" width="50"><br>  Fedora   | <img src="https://github.com/Magisk-Modules-Alt-Repo/chroot-distro/raw/main/images/debian.png" width="50"><br>  Debian  | <img src="https://github.com/Magisk-Modules-Alt-Repo/chroot-distro/raw/main/images/rocky_linux.png" width="50"><br>  Rocky | <img src="https://github.com/Magisk-Modules-Alt-Repo/chroot-distro/raw/main/images/centos.png" width="50"><br> CentOS Stream  | <img src="https://github.com/Magisk-Modules-Alt-Repo/chroot-distro/raw/main/images/manjaro.png" width="50"><br>  Manjaro   | <img src="https://github.com/Magisk-Modules-Alt-Repo/chroot-distro/raw/main/images/kali_linux.png" width="50"><br>   Kali    | <img src="https://github.com/Magisk-Modules-Alt-Repo/chroot-distro/raw/main/images/parrot_security.png" width="50"><br>  Parrot  | <img src="https://github.com/Magisk-Modules-Alt-Repo/chroot-distro/raw/main/images/alpine_linux.png" width="50"><br>  Alpine  | <img src="https://github.com/Magisk-Modules-Alt-Repo/chroot-distro/raw/main/images/opensuse.png" width="50"><br> OpenSUSE  | <img src="https://github.com/Magisk-Modules-Alt-Repo/chroot-distro/raw/main/images/deepin.png" width="50"><br>  Deepin  | <img src="https://github.com/Magisk-Modules-Alt-Repo/chroot-distro/raw/main/images/backbox_linux.png" width="50"><br> BackBox | <img src="https://github.com/Magisk-Modules-Alt-Repo/chroot-distro/raw/main/images/chimera_linux.png" width="50"><br> Chimera  | <img src="https://github.com/Magisk-Modules-Alt-Repo/chroot-distro/raw/main/images/openkylin.png" width="50"><br> OpenKylin | <img src="https://github.com/Magisk-Modules-Alt-Repo/chroot-distro/raw/main/images/gentoo.png" width="50"><br>  Gentoo  | <img src="https://github.com/Magisk-Modules-Alt-Repo/chroot-distro/raw/main/images/artix_linux.png" width="50"><br>  Artix  | <img src="https://github.com/Magisk-Modules-Alt-Repo/chroot-distro/raw/main/images/adelie_linux.png" width="50"><br>  Adélie  | <img src="https://github.com/Magisk-Modules-Alt-Repo/chroot-distro/raw/main/images/void_linux.png" width="50"><br>   Void  |
|:------:|:------:|:------:|:------:|:------:|:------:|:------:|:------:|:------:|:------:|:------:|:------:|:------:|:------:|:------:|:------:|:------:|:------:|:------:|
| `ubuntu`| `arch`  | `fedora`| `debian`| `rocky` | `centos_stream`  | `manjaro`| `kali`  | `parrot`| `alpine`| `opensuse` | `deepin`| `backbox`  | `chimera`  | `openkylin`| `gentoo`| `artix` | `adelie`| `void`  |

## Usage Warning

### Notice
chroot-distro requires root access to function. While running as root:
* There's a small possibility of unintended file deletion
* System files could be accidentally modified
* Corner cases might exist despite thorough testing

### Careful
Before running chroot-distro:
* Always backup your important files
* Always backup your system partitions

### Remember
This warning applies to all root-level operations, not just chroot-distro.

As they say: ***With great power comes great responsibility.***

## Commands

### Basic Commands
```bash
chroot-distro help                        # Display this help message
chroot-distro env                         # Display environment information
chroot-distro list                        # List available distributions
chroot-distro list -i|--installed         # List installed distributions 
chroot-distro download <distro> [link]    # Download a distribution
chroot-distro redownload <distro> [link]  # Redownload a distribution
chroot-distro add <distro>                # Add a custom distribution
chroot-distro rename <old> <new>          # Rename a distribution
chroot-distro delete <distro>             # Delete a distribution (rootfs file only)
chroot-distro remove <distro>             # Remove all files related to a distribution
```
**Note:**
- `[link]` is an optional parameter for downloading a custom distribution.

### Installation Commands
```bash
chroot-distro install <distro>              # Install a distribution
chroot-distro reinstall <distro>            # Reinstall a distribution
chroot-distro reinstall --force <distro>    # Force reinstall
chroot-distro uninstall <distro>            # Uninstall a distribution
chroot-distro uninstall --force <distro>    # Force uninstall
```

### Backup and Restore
```bash
chroot-distro backup <distro> [path]           # Create a backup
chroot-distro unbackup <distro>                # Remove a backup
chroot-distro restore <distro> [path]          # Restore from a backup
chroot-distro restore --default <distro>       # Restore to default settings
```
**Notes:**
- Use `--default` or `-d` to restore the original installation settings.
- Specify a custom `[path]` for backup/restore operations.
- For older backups, use `--force` cautiously to avoid issues like system mount conflicts or storage limitations.

### Mount 
```bash
chroot-distro mount <distro> # command to mount rootfs without entering
```
### Unmount Commands
```bash
chroot-distro unmount <distro|all>                 # Unmount system points
chroot-distro unmount --force --all <distro|all>   # Force unmount all mounts
```
**Notes:**
- You can unmount all distros with `unmount all`
- Use `--force` to close processes accessing system points.
- Use `--all` to unmount system, normal, and loopback mounts.

### Execute Commands
```bash
chroot-distro command <distro> "command"       # Run a command in the distribution
chroot-distro login <distro>                   # Log in to the distribution
```
**Notes:**
- Enclose commands in quotes for the `command` operation.
- The `command` operation executes and returns to the host system.

### Example Usage
```bash
chroot-distro download ubuntu
chroot-distro install ubuntu
chroot-distro login ubuntu
chroot-distro command debian "sudo -i -u root"
chroot-distro backup ubuntu /sdcard/backup
```
*Replace `<distro>` with the desired distribution identifier.*
### Settings Commands

```bash
chroot-distro android-bind <enable|disable>
```
- Default set to enable.
- Binds all Android root directories.
```bash
chroot-distro fix-suid <enable|disable>
```
- Default set to enable.
- Auto-fixes the setuid issue.
```bash
chroot-distro ram-bind <enable|disable>
```
- Default set to enable.
- Binds some paths in the distro to RAM for performance improvement.

## Installation
1. Download the [latest release](https://github.com/Magisk-Modules-Alt-Repo/chroot-distro/releases/latest) from the table below.
2. Install via a module manager (e.g., Magisk) or flash through a custom recovery.

## Screenshot Examples 
![Debian  console](https://github.com/Magisk-Modules-Alt-Repo/chroot-distro/raw/main/screenshot/debian.png)
### Desktop Environment with VNC
![Debian GUI over VNC](https://github.com/Magisk-Modules-Alt-Repo/chroot-distro/raw/main/screenshot/debian_vnc.png)
![Ubuntu GUI over VNC](https://github.com/Magisk-Modules-Alt-Repo/chroot-distro/raw/main/screenshot/ubuntu.png)
### Desktop Environment with Termux-X11
![Gui over Termux-X11](https://github.com/Magisk-Modules-Alt-Repo/chroot-distro/raw/main/images/parrot_termux_x11.jpg)
**For a complete setup guide of VNC and Termux-X11, see [android_gui.md](docs/android_gui.md).**
### chroot-distro on Gnu/Linux 
![Gnu_Linux](https://github.com/Magisk-Modules-Alt-Repo/chroot-distro/raw/main/images/gnu_linux.jpg) 
**`chroot-distro` was originally designed for Android, but it has also been made compatible with GNU/Linux systems.**   
**Installation instructions for GNU/Linux can be found here: [how-to.md](docs/how-to.md).**
## How-to Instructions
**For detailed instructions on fixing `sudo` and other setup methods, see [how-to.md](docs/how-to.md).**

## Development Guide
**For full development instructions, see [development_guide.md](docs/development_guide.md).**

## Environment Variables for chroot-distro Configuration
- **Change default `chroot-distro` path**: 
  ```bash
  export chroot_distro_path=<path>
  ```
- **Manual specification for `busybox`**:
  ```bash
  export chroot_distro_busybox=<path> 
  ```
  Used to manually specify the path to the busybox command.
- **Skip tmpfs mount for `/tmp`**: 
  ```bash
  export chroot_distro_tmp=true
  ```
  Useful in some cases.
- **Skip exit on errors (unsafe)**:
  ```bash
  export chroot_distro_exit=true
  ```
  Allows bypassing automatic exit on errors.
- **Disable mounting**:
  ```bash
  export chroot_distro_mount=true
  ```
  Prevents mounting of file systems during execution.
- **Developer-specific setting**:
  ```bash
  export chroot_distro_log=<value>
  ```
  **Reserved for developers, explained in [development_guide.md](docs/development_guide.md).**

## Semantic Versioning

`chroot-distro` uses semantic versioning for version numbers. Versioning uses three levels: major, minor and patch. Major version changes when there are breaking changes in API. Minor version changes for new features (or significant changes that don't break compatibility). Patch version is only for bug fixes or very small changes (no breaking changes).

- **Major (X)**: Changes when API breaks compatibility
- **Minor (Y)**: Changes for new features (no compatibility breaks)
- **Patch (Z)**: Bug fixes and small updates (no breaking changes)

## Software License

This software is licensed under the GNU General Public License v3.0 (GPL-3.0). You are free to:
- Use, modify, and distribute this software
- Access and modify the source code
- Use for commercial purposes

Full license text: [GNU GPL v3](LICENSE)