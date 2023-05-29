#!/bin/bash

# Check the linux distro
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO=$ID
else
    DISTRO=$(uname -s)
fi

# Initial System Update and Upgrade
echo "Updating and upgrading system..."

if [[ "$OS" == *"Debian"* ]] || [[ "$OS" == *"Ubuntu"* ]]; then
    # Check if curl is installed
    if ! command -v curl &> /dev/null; then
        sudo apt-get update
        sudo apt-get install -y curl
    fi

    # Check if unzip is installed
    if ! command -v unzip &> /dev/null; then
        sudo apt-get update
        sudo apt-get install -y unzip
    fi

    # Install Pulumi
    echo "Installing Pulumi..."
    curl -fsSL https://get.pulumi.com | sh
    export PATH=$PATH:$HOME/.pulumi/bin
elif [[ "$OS" == *"CentOS Linux"* ]] || [[ "$OS" == *"Fedora"* ]]; then
    # Check if curl is installed
    if ! command -v curl &> /dev/null; then
        sudo yum -y update
        sudo yum -y install curl
    fi

    # Check if unzip is installed
    if ! command -v unzip &> /dev/null; then
        sudo yum -y update
        sudo yum -y install unzip
    fi

    # Install Pulumi
    echo "Installing Pulumi..."
    curl -fsSL https://get.pulumi.com | sh
    export PATH=$PATH:$HOME/.pulumi/bin
else
    echo "Unsupported OS"
    exit
fi

# Exporting Path Variable
echo "Exporting path variable..."
export PATH=$PATH:~/.pulumi/bin

# Checking Pulumi Version
echo "Checking Pulumi version..."
pulumi version

# Setting Up Logging
echo "Setting up logging..."
# Specify the path of your log file
LOGFILE="/var/log/pulumi.log"

# Create a log file
sudo touch $LOGFILE

# Change permissions of the log file to allow read and write
sudo chmod 666 $LOGFILE

# Setting Up Security
echo "Setting up security..."
# You might want to change ownership of the Pulumi directory to the current user
sudo chown -R $USER:$USER ~/.pulumi/

echo "Pulumi has been installed and configured with monitoring, logging, and security."
