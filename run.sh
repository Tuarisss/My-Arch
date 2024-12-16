#!/bin/bash

# Проверка, запущен ли скрипт от имени root
if [ "$EUID" -ne 0 ]; then
    echo "Пожалуйста, запустите скрипт от имени root (с помощью sudo)."
    exit 1
fi

# Функция для проверки, установлен ли пакет
check_package_installed() {
    pacman -Q $1 &>/dev/null
}

# Установка необходимых пакетов для сборки yay
install_yay_dependencies() {
    echo "Устанавливаем зависимости для yay..."
    pacman -S --needed --noconfirm git base-devel
}

# Установка yay, если он не установлен
if ! command -v yay &>/dev/null; then
    echo "yay не найден, начинаем установку..."
    install_yay_dependencies

    # Клонируем репозиторий yay
    git clone https://aur.archlinux.org/yay.git /tmp/yay

    # Сборка и установка yay
    cd /tmp/yay || exit
    makepkg -si --noconfirm
    
    # Удаляем временные файлы
    cd ~ || exit
    rm -rf /tmp/yay
else
    echo "yay уже установлен."
fi

# Установка пакетов через yay
PACKAGES=(wireshark-cli wireshark-qt wifite hashcat kde-applications)

echo "Устанавливаем пакеты: ${PACKAGES[*]}"
for package in "${PACKAGES[@]}"; do
    yay -S --needed --noconfirm "$package"
done

echo "Все пакеты успешно установлены!"
