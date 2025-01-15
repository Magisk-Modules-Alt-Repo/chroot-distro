# chroot-distro
chroot-distro :
  Installs Linux distributions in a chroot environment on Android.
+ Directory structure
```
/data/local/chroot-distro/
├── .backup/
├── .rootfs/
├── distro1/
└── distro2/
```
+ All necessary system paths are mounted automatically
+ GUI applications are possible through VNC or X11 forwarding
___
## Requirements

### Rooted Android Device
All root implementations are compatible.

You can use chroot-distro on any terminal, for example: MiXplorer, MT Manager, Termux, TWRP and Android Terminal Emulator (ADB Shell).

### Busybox for Android NDK
You need a recent version of the "Busybox for Android NDK by osm0sis" Magisk module installed.
* **Recommended:** v1.36.1 is confirmed to work.
* **Avoid:** v1.32.1 is known to cause issues.
* **Important:** Using an outdated version can lead to problems, such as difficulties downloading the rootfs.

### Alternative Busybox
Using the Busybox provided by:
* Magisk/KernelSU/APatch 
(without the "Busybox for Android NDK" module) is supported by the community, but it might introduce bugs during use.

## Android Paths

### System Points
```
/chroot-distro/distro1
├── /dev
├── /sys
├── /proc
├── /dev/pts
├── /sdcard
└── /storage
```

### Optional Mounts
use `-a` or `--android` when installing to mount it
```
├── /system   (Not mounted by default)
└── /data     (Not mounted by default)
```

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

## Commands Usage

### Basic Commands

```
# Show all commands and usage
chroot-distro help

# Display environment details
chroot-distro env

# Show available distributions
chroot-distro list

# Download a new distribution
chroot-distro download <distro>

# Refresh existing distribution
chroot-distro redownload <distro>

# Remove distribution
chroot-distro delete <distro>
```

### Usage Examples
```
chroot-distro download ubuntu
chroot-distro redownload debian
chroot-distro delete ubuntu
```
>*Replace `<distro>` with your chosen distribution identifier*

### Installation Commands
```
# Basic installation
chroot-distro install <distro>
# Install with Android mounts
chroot-distro install --android <distro>

# Reinstall distribution
chroot-distro reinstall <distro>
# Force reinstall with Android mounts
chroot-distro reinstall --android --force <distro>

# Remove distribution
chroot-distro uninstall <distro>
# Force uninstall
chroot-distro uninstall --force <distro>
```
Usage Note:
+ By default, Optional mounts (/data, /system) are not mounted. Use `-a` or `--android` flag to mount them.

+ The reinstall process will stop if files are open or mounts are active. Using `-f` or `--force` will close running processes and unmount active points. For safety, first run without force to see what's running before using the force option.

### Backup Operations
```
# Create backup
chroot-distro backup <distro> [path]
# Remove backup
chroot-distro unbackup <distro>

# Restore backup
chroot-distro restore <distro> [path]
# Restore to defaults
chroot-distro restore --default <distro>
```
Usage Note:
+ Restores backup in its current state. Use `-d` or `--default` to restore original install settings.
+ Optional: Specify custom path to restore from.
+ For old backups: `--force` may be needed, but review first to avoid issues like:
  * System mount conflicts
  * Storage space problems

### Unmount Paths
```
# Unmount system points
chroot-distro unmount <distro>
# Force unmount all points
chroot-distro unmount --force --all <distro>
```
Usage Note:
+ Stops if unmount fails. Use `-f` or `--force` to:
  * Close any process trying to access system points
  * Unmount any active system points forcefully
+ By default: Only unmounts system points
+ Use `-a` or `--all` to unmount everything (system, normal, and loopback mounts)

### Execute Commands
```
# Run specific command
chroot-distro command <distro> "command"

# Login to distro
chroot-distro login <distro>
```
Usage Note:
+ Execute Commands:
   ```
   chroot-distro command <distro> "command"
   ```
   * Runs a command within specified distro
   * Commands must be enclosed in quotes
   * Executes and returns to host system

### Usage Examples
```
chroot-distro download ubuntu
chroot-distro install ubuntu
chroot-distro install --android debian
chroot-distro login ubuntu
chroot-distro command debian "su -l root" 
```
>*Replace `<distro>` with your chosen distribution identifier.*

## Supported Distributions
Note: Use lowercase identifiers for it to be properly identified.
| Distributions   | Identifiers     |
|----------------|-----------------|
| Kali Linux     | `kali`         |
| Parrot OS      | `parrot`       |
| Alpine Linux   | `alpine`       |
| Arch Linux     | `archlinux`    |
| BackBox        | `backbox`      |
| Centos         | `centos`       |
| Centos Stream  | `centos_stream`|
| Artix Linux    | `artix`        |
| Debian         | `debian`       |
| Deepin         | `deepin`       |
| Fedora 39      | `fedora`       |
| Manjaro        | `manjaro`      |
| OpenKylin      | `openkylin`    |
| OpenSUSE       | `opensuse`     |
| Pardus         | `pardus`       |
| Ubuntu         | `ubuntu`       |
| Void Linux     | `void`         |

## Download Releases

|   Versions  |   Releases   |
|-------------|--------------|
|   v1.3.0    | [Download](https://github.com/Magisk-Modules-Alt-Repo/chroot-distro/releases/download/v1.3.0/chroot-distro.zip) |
|   v1.4.0    | [Download](https://github.com/Magisk-Modules-Alt-Repo/chroot-distro/releases/download/v1.4.0/chroot-distro.zip) |
|   Latest    | [Download](https://github.com/Magisk-Modules-Alt-Repo/chroot-distro/releases/latest/download/chroot-distro.zip) |

Install via Manager or flash through custom recovery.

## Screenshot Examples
![Debian console](screenshot/debian.png)
![Kali Linux console](screenshot/kali-linux.png)

## TODO: How-to Instructions

### Fixing Sudo

By default Android prevents suid usage under `/data` folder. This will prevent using `sudo` inside the rootfs. There is a few alternatives how this can be solved:

1. Quick Remount  
Remount /data for the current process with needed capabilities
```
# Run once per session
su -c mount -o remount,dev,suid /data
```

2. Image File Method
```
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
---

### Desktop Environment with VNC

![Debian GUI over VNC](screenshot/debian_vnc.png)
![Ubuntu GUI over VNC](screenshot/ubuntu.png)

1. Install VNC Server  
Download and install any VNC viewer app.
  * RealVNC Viewer
  * bVNC Pro
  * MultiVNC

2. Install Required Packages  
(Assuming that you're already installed the Chroot Distro)  
Inside your chroot environment:
```
apt update
apt upgrade
apt install tightvncserver
apt install nano dbus-x11 xfce4 xfce4-goodies xfce4-terminal
```

3. Set Up Desktop Environment
```
# Configure Terminal
update-alternatives --config x-terminal-emulator

# Start VNC first time to create config
vncserver

# Stop the server
vncserver -kill :1

# Add XFCE to startup
echo 'startxfce4 &' >> ~/.vnc/xstartup
```

4. Launch Desktop Environment
```
# Start VNC
vncserver

# Stop VNC
vncserver -kill :1
```

### Desktop Environment with Termux-X11
1. Install Termux-X11  
Download and install Termux-X11 from the official repository:
  https://github.com/termux/termux-x11

2. Install Required Packages in Termux
First, open Termux and run these commands:
```
pkg install x11-repo
pkg install root-repo
pkg install tsu
pkg install ncurses-utils
pkg install termux-x11-nightly
pkg install pulseaudio
pkg install virglrenderer-android
```

3. Set Up Desktop Environment  
(Assuming that you're already installed the Chroot Distro)  
Inside your chroot environment, Install XFCE4:
```
apt install xfce4

# Optional: Make sure to set up mpd.conf for music/audio server before running 'Audio Server'.
apt install mpd
```

4. Launch the Desktop Environment Easily
![chroot-xfce.sh](https://github.com/user-attachments/assets/3f5db05f-fdde-40da-aab1-bb754ca98e35)
Note: Make sure to run the script in Termux.

Save this script as "chroot-xfce.sh" as it provides user-friendly menu and use it to launch your XFCE4 desktop environment later:
1. Create the script:
```
nano chroot-xfce.sh
```

2. Copy and paste the provided code:
```
#!/bin/bash

# Set colors and styles
normal=$(tput sgr0)
highlight=$(tput bold; tput setaf 6)
logolight=$(tput bold; tput setaf 5)
title=$(tput bold; tput setaf 2)
error=$(tput setaf 1)
hide_cursor=$(tput civis)
show_cursor=$(tput cnorm)

# Menu options
options=("Audio Server" "Login CLI" "Login GUI")
selected=0
selected_distro_index=0
distro_selected=false

# Get Installed Distros
get_installed_distros() {
    installed_distros=()
    while read -r line; do
        if [[ "$line" =~ ^[A-Za-z].+[[:space:]]*:[[:space:]]*[a-z] ]]; then
            alias=$(echo "$line" | awk -F': ' '{print $2}')
            read -r next_line
            while [[ -n "$next_line" ]]; do
                if [[ "$next_line" == *"Installed: Yes"* ]]; then
                    installed_distros+=("$alias")
                    break
                fi
                read -r next_line
            done
        fi
    done < <(sudo chroot-distro list)
    
    if [ ${#installed_distros[@]} -eq 0 ]; then
        echo "No distributions installed."
        exit 1
    fi
}

# Format installed distros for display
format_installed_distros() {
    local distro_list
    distro_list=$(printf "%s " "${installed_distros[@]}")
    formatted_distro="Installed = [ ${distro_list%* } ]"
}

# ASCII art logo
logo="
  ____ _                     _     ____  _     _             
 / ___| |__  _ __ ___   ___ | |_  |  _ \(_)___| |_ _ __ ___  
| |   | '_ \| '__/ _ \ / _ \| __| | | | | / __| __| '__/ _ \ 
| |___| | | | | (_) | (_) | |_  | |_| | \__ \ |_| | | (_) |
 \____|_| |_|_|  \___/ \___/ \__| |____/|_|___/\__|_|  \___/
 v1.2 the.puer@discord | YasserNull@github | jjkola@github!!"

# Tips array
infoa=("[Info] Use Up/Down to navigate."
      "[Info] Press Enter to select an option."
      "[Info] Use Home/End for quick navigation."
      "[Info] Press Esc or q or Ctrl+C to exit.")
infob=("[Info] Run Audio Server once before login as CLI.")

# Function to wait for user input to continue
wait_for_key_press() {
    echo -e "${normal}Press any key to continue..."
    read -r -n1 -s
}

# Function to draw the main menu
draw_menu() {
    clear
    echo -e "\n${logolight}${logo}"
    echo -e "\n${normal}Login to Distro"
    echo -e "${error}${formatted_distro}\n"
    echo -e "${normal}${infoa[RANDOM % ${#infoa[@]}]}"
    echo -e "${normal}${infob[RANDOM % ${#infob[@]}]}\n"

    echo -e "${title}-- Main Menu --${normal}"
    for i in "${!options[@]}"; do
        if [[ $i -eq $selected ]]; then
            printf " ${highlight}> ${options[$i]} ${normal}\n"
        else
            printf "   ${options[$i]}\n"
        fi
    done
    
    echo -e "\n${normal}(Use Up/Down arrows, Enter, Escape, q, Home, or End)"
}

# Function to draw the distro selection menu
draw_distro_menu() {
    clear
    echo -e "\n${logolight}${logo}"
    echo -e "\n${normal}Login to Distro"
    echo -e "${error}${formatted_distro}\n"
    echo -e "${normal}${infoa[RANDOM % ${#infoa[@]}]}"
    echo -e "${normal}${infob[RANDOM % ${#infob[@]}]}\n"

    echo -e "${title}-- Select Distro --${normal}"
    for i in "${!installed_distros[@]}"; do
        if [[ $i -eq $selected_distro_index ]]; then
            printf " ${highlight}> ${installed_distros[$i]} ${normal}\n"
        else
            printf "   ${installed_distros[$i]}\n"
        fi
    done
    
    echo -e "\n${normal}(Use Up/Down arrows, Enter to select, Escape or q to exit)"
}

# Function to select distro
select_distro() {
    selected_distro_index=0
    distro_selected=false
    
    draw_distro_menu
    
    while true; do
        stty -echo
        read -r -sN1 char
        case "$char" in
            $'\e')
                read -r -sN2 -t 0.1 char2
                case "$char2" in
                    '[A') # Up
                        selected_distro_index=$(( (selected_distro_index - 1 + ${#installed_distros[@]}) % ${#installed_distros[@]} ))
                        ;;
                    '[B') # Down
                        selected_distro_index=$(( (selected_distro_index + 1) % ${#installed_distros[@]} ))
                        ;;
                    '[H') # Home
                        selected_distro_index=0
                        ;;
                    '[F') # End
                        selected_distro_index=$((${#installed_distros[@]} - 1))
                        ;;
                    *) 
                        stty echo
                        echo -e "$show_cursor"
                        return 1
                        ;;
                esac
                ;;
            $'\n'|$'\r') # Enter
                selected_distro="${installed_distros[$selected_distro_index]}"
                distro_selected=true
                stty echo
                return 0
                ;;
            $'\x03'|'q') # Ctrl+C or q
                stty echo
                echo -e "$show_cursor"
                exit 0
                ;;
        esac
        draw_distro_menu
    done
}

# Function to unmount remaining mounted points
unmount_chroot() {
    local chmount="/data/local/chroot-distro/$selected_distro"
    
    for leftover in dev sys proc dev/pts sdcard system data \
             storage/emulated storage/self \
             "data/local/chroot-distro/$selected_distro/storage/emulated" \
             "data/local/chroot-distro/$selected_distro/storage/self"; do
        su -c "mount | grep -q '$chmount/$leftover'" >/dev/null 2>&1 && \
        su -c "umount -l '$chmount/$leftover'" >/dev/null 2>&1
    done

    su -c "mount | grep '$chmount' | awk '{print \$3}'" | \
    while read leftover; do
        su -c "umount -l '$leftover'" >/dev/null 2>&1
    done
}

# Function for the option
start_termux_server() {
    pkill -f com.termux.x11
    sudo pkill mpd
    killall -9 termux-x11 Xwayland pulseaudio virgl_test_server_android termux-wake-lock
    sudo fuser -k 4713/tcp
    sudo busybox mount --bind "$PREFIX/tmp" /data/local/chroot-distro/"$selected_distro"/tmp
    XDG_RUNTIME_DIR=${TMPDIR} termux-x11 :0 -ac &
    sleep 2
    pulseaudio --start --load="module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1" --exit-idle-time=-1
    pacmd load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1
    virgl_test_server_android &
    sudo chmod -R 1777 /data/data/com.termux/files/usr/tmp
}

audio_server() {
    select_distro || return 1
    unmount_chroot
    echo -e "\nRunning Audio Server for $selected_distro..."
    start_termux_server
    su -c "chroot-distro command $selected_distro \"export DISPLAY=:0 PULSE_SERVER=tcp:127.0.0.1:4713 && dbus-launch --exit-with-session && mpd\""
    clear
}

login_cli() {
    select_distro || return 1
    unmount_chroot
    clear
    echo -e "\nLogging in as CLI to $selected_distro..."
    tput cnorm
    read -rp "Enter username: " username
    sudo chroot-distro command "$selected_distro" "su -l $username"
}

login_gui() {
    select_distro || return 1
    unmount_chroot
    echo -e "\nLogging in as GUI to $selected_distro..."
    tput cnorm
    read -rp "Enter username: " username
    start_termux_server
    am start --user 0 -n com.termux.x11/com.termux.x11.MainActivity
    su -c "chroot-distro command $selected_distro \"export DISPLAY=:0 PULSE_SERVER=tcp:127.0.0.1:4713 && dbus-launch --exit-with-session sudo -u $username startxfce4\""
}

# Initialize
get_installed_distros
format_installed_distros

# Hide cursor and draw initial menu
echo -e "$hide_cursor"
draw_menu

# Main loop
trap 'stty echo; echo -e "$show_cursor"; exit' EXIT SIGINT SIGTERM
while true; do
    stty -echo
    read -r -sN1 char
    case "$char" in
        $'\e')
            read -r -sN2 -t 0.1 char2
            case "$char2" in
                '[A') selected=$(( (selected - 1 + ${#options[@]}) % ${#options[@]} )) ;;
                '[B') selected=$(( (selected + 1) % ${#options[@]} )) ;;
                '[H') selected=0 ;;
                '[F') selected=$((${#options[@]} - 1)) ;;
                *) stty echo; echo -e "$show_cursor"; exit 0 ;;
            esac
            ;;
        $'\n'|$'\r')
            clear
            echo -e "${title}You selected: ${options[$selected]}${normal}"
            case "${options[$selected]}" in
                "Audio Server")
                    audio_server
                    echo -e "\nYou can login as CLI now.\nSelect 'Login CLI' to login!\n"
                    wait_for_key_press
                    $HOME/chroot-xfce.sh
                    ;;
                "Login CLI")
                    su -c mount -o remount,dev,suid /data
                    login_cli
                    ;;
                "Login GUI")
                    su -c mount -o remount,dev,suid /data
                    login_gui
                    ;;
            esac
            stty echo; echo -e "$show_cursor"; exit 0
            ;;
        $'\x03'|'q')
            stty echo; echo -e "$show_cursor"; exit 0
            ;;
    esac

    stty echo
    draw_menu
done
```

4. Save and make it executable:
```
chmod +x chroot-xfce.sh
```

5. Run the script:
```
./chroot-xfce.sh
or
bash chroot-xfce.sh
```

Once completed, you'll have a fully functional XFCE4 desktop environment with audio capabilities running through Termux-X11.

## Development Guide

If you want to help with development or test a bug report against the latest version, create a development build using:

```
zip chroot-distro.zip config.sh module.prop META-INF/com/google/android/* system/bin/chroot-distro
```

Alternative approaches:
- Enable SSH in a distro, update scripts remotely, and test against another distro (no reboot needed thus making the development quicker)
- Develop directly on the device (physically or via remote connection)

Testing requirements:
- Test all changes in Termux (or other terminals) AND Android terminal emulator (ADB Shell)
- Note: ADB Shell only has Busybox and Android Toybox commands, which may behave differently than Termux

Code quality:
- Use `shellcheck` for POSIX compliance
- Document warning exceptions with `# shellcheck disable=SCXXXX` and explanatory comments
- For shell scripting guidance, refer to [Grymoire's tutorial](https://www.grymoire.com/Unix/Sh.html)

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
