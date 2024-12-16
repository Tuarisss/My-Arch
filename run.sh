#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    echo "Please run the script as root (using sudo)."
    exit 1
fi

check_package_installed() {
    pacman -Q $1 &>/dev/null
}

install_yay_dependencies() {
    pacman -S --needed --noconfirm git base-devel
}

if ! command -v yay &>/dev/null; then
    install_yay_dependencies
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay || exit
    makepkg -si --noconfirm
    cd ~ || exit
    rm -rf /tmp/yay
fi

PACKAGES=(
    wireshark-cli
    wireshark-qt
    wifite
    hashcat
    kde-applications
    flatpak
    google-chrome
    nmap
    metasploit
    john
    aircrack-ng
    burpsuite
    hydra
    sqlmap
    nikto
    zaproxy
    openvpn
    gobuster
    binwalk
    radare2
    tcpdump
    dirb
    dirsearch
)

for package in "${PACKAGES[@]}"; do
    yay -S --needed --noconfirm "$package"
done

echo "All packages installed successfully!"
