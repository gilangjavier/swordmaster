#!/bin/bash

# Check the linux distro
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO=$ID
else
    DISTRO=$(uname -s)
fi

# Install Docker and Docker Compose based on the detected distro
echo "Installing Docker and Docker Compose..."

if [ "$DISTRO" == "debian" ] || [ "$DISTRO" == "ubuntu" ]; then
    sudo apt-get update -y
    sudo apt-get install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg \
        lsb-release
    curl -fsSL https://download.docker.com/linux/$DISTRO/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo \
        "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/$DISTRO \
        $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    sudo apt-get install docker-ce docker-ce-cli containerd.io
    sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
elif [ "$DISTRO" == "centos" ] || [ "$DISTRO" == "fedora" ]; then
    sudo yum update -y
    sudo yum install -y yum-utils
    sudo yum-config-manager --add-repo https://download.docker.com/linux/$DISTRO/docker-ce.repo
    sudo yum install docker-ce docker-ce-cli containerd.io
    sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
else 
    echo "Unsupported distribution. This script supports Debian, Ubuntu, CentOS, and Fedora."
    exit 1
fi

# Starting Docker Service
echo "Starting Docker service..."
sudo systemctl start docker
sudo systemctl enable docker

# Installing Harness
echo "Installing Harness..."
mkdir harness && cd harness
wget https://app.harness.io/storage/harness-shell-scripts/latest/harness-install-community-edition.sh
chmod +x harness-install-community-edition.sh
sudo ./harness-install-community-edition.sh

echo "Harness Community Edition has been installed successfully."
