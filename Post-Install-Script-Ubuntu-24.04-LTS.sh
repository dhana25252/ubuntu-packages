#!/bin/bash

echo "🔧 Starting post-install setup for Ubuntu 24.04 LTS..."

# Ensure curl is installed early for later use
sudo apt update
sudo apt install -y curl

# Update system
echo "📦 Updating and upgrading the system..."
sudo apt upgrade -y
sudo apt autoremove -y && sudo apt autoclean -y
echo "✅ System update & upgrade complete."

# Define essential packages
ESSENTIAL_PACKAGES=(
    build-essential
    synaptic
    dconf-editor
    curl
    wget
    ffmpeg
    timeshift
    gnome-shell-extensions
    git
    vim
    lshw
    gnome-tweaks
    lm-sensors
    software-properties-common
    ubuntu-restricted-extras
    apt-transport-https
    ca-certificates
    lsb-release
)

echo "📦 Installing essential packages..."
sudo apt install -y "${ESSENTIAL_PACKAGES[@]}"

# ---- Brave Browser ----
read -p "🦁 Install Brave browser? (y/n): " install_brave
install_brave=$(echo "$install_brave" | tr -d '[:space:]' | tr '[:upper:]' '[:lower:]')
if [[ "$install_brave" == "y" || "$install_brave" == "yes" ]]; then
    echo "Installing Brave browser..."
    sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave.com/signing-key.gpg
    echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | \
        sudo tee /etc/apt/sources.list.d/brave-browser-release.list
    sudo apt update
    sudo apt install -y brave-browser
    echo "✅ Brave browser installed."
else
    echo "⏭️ Skipped Brave browser installation."
fi

# ---- ONLYOFFICE ----
read -p "📝 Install ONLYOFFICE Desktop Editors? (y/n): " install_onlyoffice
install_onlyoffice=$(echo "$install_onlyoffice" | tr -d '[:space:]' | tr '[:upper:]' '[:lower:]')
if [[ "$install_onlyoffice" == "y" || "$install_onlyoffice" == "yes" ]]; then
    echo "Installing ONLYOFFICE Desktop Editors..."
    sudo add-apt-repository -y ppa:onlyoffice/desktopeditors
    sudo apt update
    sudo apt install -y onlyoffice-desktopeditors
    echo "✅ ONLYOFFICE installed."
else
    echo "⏭️ Skipped ONLYOFFICE installation."
fi

# ---- Oracle VirtualBox ----
read -p "📦 Install Oracle VirtualBox and Extension Pack? (y/n): " install_vbox
install_vbox=$(echo "$install_vbox" | tr -d '[:space:]' | tr '[:upper:]' '[:lower:]')
if [[ "$install_vbox" == "y" || "$install_vbox" == "yes" ]]; then
    echo "Installing Oracle VirtualBox..."

    # Add Oracle VirtualBox repository
    wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | \
        sudo gpg --dearmor -o /usr/share/keyrings/oracle-virtualbox.gpg

    echo "deb [signed-by=/usr/share/keyrings/oracle-virtualbox.gpg] https://download.virtualbox.org/virtualbox/debian noble contrib" | \
        sudo tee /etc/apt/sources.list.d/virtualbox.list

    sudo apt update
    sudo apt install -y virtualbox-7.0

    # Install Extension Pack
    if command -v VBoxManage &>/dev/null; then
        VBOX_VERSION=$(VBoxManage --version | cut -d 'r' -f1)
        wget https://download.virtualbox.org/virtualbox/${VBOX_VERSION}/Oracle_VM_VirtualBox_Extension_Pack-${VBOX_VERSION}.vbox-extpack
        sudo VBoxManage extpack install Oracle_VM_VirtualBox_Extension_Pack-${VBOX_VERSION}.vbox-extpack --replace
        rm Oracle_VM_VirtualBox_Extension_Pack-${VBOX_VERSION}.vbox-extpack
        echo "✅ Extension Pack installed."
    else
        echo "⚠️ VBoxManage not found. Skipping Extension Pack installation."
    fi

    # Add current user to vboxusers group
    sudo usermod -aG vboxusers "$USER"

    echo "✅ VirtualBox installation complete."
    echo "⚠️ Please reboot or log out/in to apply group membership changes."
else
    echo "⏭️ Skipped VirtualBox installation."
fi

echo "🎉 Post-installation setup completed successfully!"

