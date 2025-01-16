#!/usr/bin/env bash

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

# ASCII art logo
logo="
  ____ _                     _     ____  _     _             
 / ___| |__  _ __ ___   ___ | |_  |  _ \(_)___| |_ _ __ ___  
| |   | '_ \| '__/ _ \ / _ \| __| | | | | / __| __| '__/ _ \ 
| |___| | | | | (_) | (_) | |_  | |_| | \__ \ |_| | | (_) |
 \____|_| |_|_|  \___/ \___/ \__| |____/|_|___/\__|_|  \___/
 v1.2 the.puer@discord | chroot-distro by YasserNull & jjkola@github!!"

# Tips array
infoa=("[Info] Use Up/Down to navigate."
      "[Info] Press Enter to select an option."
      "[Info] Use Home/End for quick navigation."
      "[Info] Press Esc or q or Ctrl+C to exit.")
infob=("[Info] Run Audio Server once before login as CLI.")

# Cleanup function
cleanup() {
    stty echo
    echo -e "${show_cursor}"
    exit "${1:-0}"
}

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
    done < <(sudo chroot-distro list) || {
        echo "Failed to get installed distributions" >&2
        exit 1
    }
    
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

# Validate username
validate_username() {
    local username="$1"
    if [[ ! "$username" =~ ^[a-z_][a-z0-9_-]*$ ]]; then
        return 1
    fi
    return 0
}

# Kill existing processes
kill_existing_processes() {
    pkill -f com.termux.x11 2>/dev/null || true
    sudo pkill mpd 2>/dev/null || true
    killall -9 termux-x11 Xwayland pulseaudio virgl_test_server_android termux-wake-lock 2>/dev/null || true
    sudo fuser -k 4713/tcp 2>/dev/null || true
    sleep 1
}

# Function to wait for user input to continue
wait_for_key_press() {
    echo -e "${normal}Press any key to continue..."
    read -r -n1 -s
}

# Start termux server
start_termux_server() {
    kill_existing_processes
    
    sudo busybox mount --bind "$PREFIX/tmp" "/data/local/chroot-distro/$selected_distro/tmp"
    
    XDG_RUNTIME_DIR=${TMPDIR} termux-x11 :0 -ac &
    sleep 2

    pulseaudio --start --load="module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1" --exit-idle-time=-1
    pacmd load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1
    virgl_test_server_android &

    sudo chmod -R 1777 /data/data/com.termux/files/usr/tmp
}

audio_server() {
    select_distro || return 1
    echo -e "\nRunning Audio Server for $selected_distro..."
    start_termux_server
    sudo chroot-distro command "$selected_distro" "export DISPLAY=:0 PULSE_SERVER=tcp:127.0.0.1:4713 && dbus-launch --exit-with-session && mpd"
    clear
}

login_cli() {
    select_distro || return 1
    clear
    echo -e "\nLogging in as CLI to $selected_distro..."
    tput cnorm
    
    local username
    while true; do
        read -rp "Enter username: " username
        if validate_username "$username"; then
            break
        fi
        echo "Please enter a valid username"
    done

    sudo chroot-distro command "$selected_distro" "sudo -i -u $username"
}

login_gui() {
    select_distro || return 1
    echo -e "\nLogging in as GUI to $selected_distro..."
    tput cnorm
    
    local username
    while true; do
        read -rp "Enter username: " username
        if validate_username "$username"; then
            break
        fi
        echo "Please enter a valid username"
    done

    start_termux_server
    am start --user 0 -n com.termux.x11/com.termux.x11.MainActivity
    sudo chroot-distro command "$selected_distro" "export DISPLAY=:0 PULSE_SERVER=tcp:127.0.0.1:4713 && dbus-launch --exit-with-session sudo -u $username startxfce4"
}

# Initialize
get_installed_distros
format_installed_distros

# Hide cursor and draw initial menu
echo -e "$hide_cursor"
draw_menu

# Set up trap handler
trap 'cleanup 0' EXIT
trap 'cleanup 1' INT TERM

# Main loop
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
                '[F') selected=$(( ${#options[@]} - 1 )) ;;
                *) cleanup 0 ;;
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
                    exec "$(readlink -f "$0")"
                    ;;
                "Login CLI")
                    login_cli
                    ;;
                "Login GUI")
                    login_gui
                    ;;
            esac
            cleanup 0
            ;;
        $'\x03'|'q')
            cleanup 0
            ;;
    esac

    stty echo
    draw_menu
done