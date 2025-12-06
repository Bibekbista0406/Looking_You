#!/bin/bash
# Look_For_Kri Installation Script
# Created by Bibek Bista

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

banner() {
clear
echo -e "${BLUE}"
echo "╦  ╔═╗╔═╗╦╔═  ╔═╗┌─┐┬─┐  ╦ ╦╔═╗┬ ┬ "
echo "║  ║ ║║ ║╠╩╗  ╠╣ │ │├┬┘  ╚╦╝║ ║│ │ "
echo "╩═╝╚═╝╚═╝╩ ╩  ╚  └─┘┴└─   ╩ ╚═╝└─┘ "
echo -e "${YELLOW}      LOOK_For_Kri 1.0 Installation${NC}"
echo -e "${RED}      WARNING: For educational purposes only!${NC}"
echo ""
echo -e "${BLUE}══════════════════════════════════════════════════${NC}"
echo ""
}

check_os() {
echo -e "${YELLOW}[*] Detecting operating system...${NC}"
if [[ -f /etc/os-release ]]; then
    . /etc/os-release
    OS=$NAME
    VER=$VERSION_ID
elif [[ -f /etc/redhat-release ]]; then
    OS=$(cat /etc/redhat-release)
elif [[ $(uname) == "Darwin" ]]; then
    OS="macOS"
elif [[ $(uname -o) == "Android" ]]; then
    OS="Android/Termux"
else
    OS=$(uname -s)
fi
echo -e "${GREEN}[+] OS Detected: $OS${NC}"
}

install_deps_debian() {
echo -e "${YELLOW}[*] Installing dependencies for Debian-based systems...${NC}"
sudo apt-get update
sudo apt-get install -y php php-curl wget curl git unzip openssh-client python3 python3-pip
echo -e "${GREEN}[+] Core dependencies installed${NC}"
}

install_deps_termux() {
echo -e "${YELLOW}[*] Installing dependencies for Termux...${NC}"
pkg update -y
pkg install -y php php-curl wget curl git unzip openssh python python-pip
echo -e "${GREEN}[+] Core dependencies installed${NC}"
}

install_deps_macos() {
echo -e "${YELLOW}[*] Installing dependencies for macOS...${NC}"
if ! command -v brew &> /dev/null; then
    echo -e "${RED}[!] Homebrew not found. Installing Homebrew...${NC}"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
brew install php wget curl git python3
echo -e "${GREEN}[+] Core dependencies installed${NC}"
}

install_deps_arch() {
echo -e "${YELLOW}[*] Installing dependencies for Arch-based systems...${NC}"
sudo pacman -Syu --noconfirm
sudo pacman -S --noconfirm php php-curl wget curl git unzip openssh python python-pip
echo -e "${GREEN}[+] Core dependencies installed${NC}"
}

install_cloudflared() {
echo -e "${YELLOW}[*] Installing Cloudflared (for tunnel option 1)...${NC}"
if [[ $(uname -o) == "Android" ]]; then
    pkg install cloudflared -y
else
    arch=$(uname -m)
    if [[ $arch == *'arm'* ]]; then
        wget -q "https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm" -O cloudflared
    elif [[ "$arch" == *'aarch64'* ]]; then
        wget -q "https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm64" -O cloudflared
    elif [[ "$arch" == *'x86_64'* ]]; then
        wget -q "https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64" -O cloudflared
    else
        wget -q "https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-386" -O cloudflared
    fi
    chmod +x cloudflared
    sudo mv cloudflared /usr/local/bin/
fi
echo -e "${GREEN}[+] Cloudflared installed${NC}"
}

install_ngrok() {
echo -e "${YELLOW}[*] Setting up Ngrok (for tunnel option 2)...${NC}"
echo -e "${BLUE}[*] Note: Ngrok requires an account at https://ngrok.com${NC}"
read -p "Do you want to install ngrok? (y/n): " install_ngrok
if [[ $install_ngrok == "y" || $install_ngrok == "Y" ]]; then
    arch=$(uname -m)
    if [[ $(uname -o) == "Android" ]]; then
        pkg install ngrok -y
    elif [[ "$arch" == *'x86_64'* ]]; then
        wget -q https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz
        tar -xzf ngrok-v3-stable-linux-amd64.tgz
        rm ngrok-v3-stable-linux-amd64.tgz
        sudo mv ngrok /usr/local/bin/
    elif [[ "$arch" == *'arm'* ]] || [[ "$arch" == *'aarch64'* ]]; then
        wget -q https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-arm64.tgz
        tar -xzf ngrok-v3-stable-linux-arm64.tgz
        rm ngrok-v3-stable-linux-arm64.tgz
        sudo mv ngrok /usr/local/bin/
    else
        wget -q https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-386.tgz
        tar -xzf ngrok-v3-stable-linux-386.tgz
        rm ngrok-v3-stable-linux-386.tgz
        sudo mv ngrok /usr/local/bin/
    fi
    echo -e "${GREEN}[+] Ngrok installed${NC}"
    echo -e "${YELLOW}[!] Remember to configure ngrok with your authtoken:${NC}"
    echo -e "${BLUE}    ngrok config add-authtoken YOUR_TOKEN${NC}"
    echo -e "${BLUE}    Get token from: https://dashboard.ngrok.com/get-started/your-authtoken${NC}"
fi
}

clone_tool() {
echo -e "${YELLOW}[*] Cloning Look_For_Kri from GitHub...${NC}"
if [[ -d "look-for-kri" ]]; then
    echo -e "${YELLOW}[!] Directory already exists. Updating...${NC}"
    cd look-for-kri
    git pull
    cd ..
else
    git clone https://github.com/bibekbista/look-for-kri.git
fi

if [[ ! -d "look-for-kri" ]]; then
    echo -e "${RED}[!] Failed to clone repository. Creating directory manually...${NC}"
    mkdir -p look-for-kri
fi
}

setup_permissions() {
echo -e "${YELLOW}[*] Setting up permissions...${NC}"
cd look-for-kri
chmod +x look-kri.sh
if [[ -f "install.sh" ]]; then
    chmod +x install.sh
fi
cd ..
}

test_installation() {
echo -e "${YELLOW}[*] Testing installation...${NC}"
cd look-for-kri

echo -e "${BLUE}[*] Testing PHP...${NC}"
php --version > /dev/null 2>&1
if [[ $? -eq 0 ]]; then
    echo -e "${GREEN}[✓] PHP is working${NC}"
else
    echo -e "${RED}[✗] PHP not working properly${NC}"
fi

echo -e "${BLUE}[*] Testing wget...${NC}"
wget --version > /dev/null 2>&1
if [[ $? -eq 0 ]]; then
    echo -e "${GREEN}[✓] wget is working${NC}"
else
    echo -e "${RED}[✗] wget not working properly${NC}"
fi

echo -e "${BLUE}[*] Testing curl...${NC}"
curl --version > /dev/null 2>&1
if [[ $? -eq 0 ]]; then
    echo -e "${GREEN}[✓] curl is working${NC}"
else
    echo -e "${RED}[✗] curl not working properly${NC}"
fi

cd ..
}

show_usage() {
echo -e "${BLUE}══════════════════════════════════════════════════${NC}"
echo -e "${GREEN}Installation Complete!${NC}"
echo -e "${BLUE}══════════════════════════════════════════════════${NC}"
echo ""
echo -e "${YELLOW}To run Look_For_Kri:${NC}"
echo -e "${BLUE}  cd look-for-kri${NC}"
echo -e "${BLUE}  ./look-kri.sh${NC}"
echo ""
echo -e "${YELLOW}Tunnel Options:${NC}"
echo -e "${BLUE}  1. Cloudflare Tunnel (Free, Recommended)${NC}"
echo -e "${BLUE}  2. Ngrok Tunnel (Requires Account)${NC}"
echo -e "${BLUE}  3. Local Server${NC}"
echo ""
echo -e "${YELLOW}For Ngrok Users:${NC}"
echo -e "${BLUE}  1. Create account at: https://ngrok.com${NC}"
echo -e "${BLUE}  2. Get authtoken from dashboard${NC}"
echo -e "${BLUE}  3. Run: ngrok config add-authtoken YOUR_TOKEN${NC}"
echo ""
echo -e "${RED}⚠️  WARNING: This tool is for EDUCATIONAL PURPOSES ONLY!${NC}"
echo -e "${RED}   Use only for authorized security testing.${NC}"
echo -e "${RED}   Developer not responsible for misuse.${NC}"
echo -e "${BLUE}══════════════════════════════════════════════════${NC}"
}

main() {
banner
check_os

echo -e "${YELLOW}[*] Starting installation...${NC}"

case $OS in
    *Debian*|*Ubuntu*|*Kali*|*Parrot*)
        install_deps_debian
        ;;
    *Android*|*Termux*)
        install_deps_termux
        ;;
    *macOS*)
        install_deps_macos
        ;;
    *Arch*|*Manjaro*)
        install_deps_arch
        ;;
    *)
        echo -e "${RED}[!] Unsupported OS: $OS${NC}"
        echo -e "${YELLOW}[!] Manual installation required${NC}"
        exit 1
        ;;
esac

install_cloudflared
install_ngrok
clone_tool
setup_permissions
test_installation
show_usage
}

main