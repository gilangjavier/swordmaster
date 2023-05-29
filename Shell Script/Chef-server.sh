#!/bin/bash

# Check the linux distro
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO=$ID
else
    DISTRO=$(uname -s)
fi

# Install Chef Infra Server based on the detected distro
echo "Installing Chef Infra Server..."

if [ "$DISTRO" == "debian" ] || [ "$DISTRO" == "ubuntu" ]; then
    sudo apt-get update -y
    sudo apt-get install -y curl
    curl https://packages.chef.io/files/stable/chef-server/14.1.0/ubuntu/18.04/chef-server-core_14.1.0-1_amd64.deb -O
    sudo dpkg -i chef-server-core_*.deb
elif [ "$DISTRO" == "centos" ] || [ "$DISTRO" == "fedora" ]; then
    sudo yum update -y
    sudo yum install -y curl
    curl https://packages.chef.io/files/stable/chef-server/14.1.0/el/7/chef-server-core-14.1.0-1.el7.x86_64.rpm -O
    sudo rpm -Uvh chef-server-core-*.rpm
else 
    echo "Unsupported distribution. This script supports Debian, Ubuntu, CentOS, and Fedora."
    exit 1
fi

echo "Reconfiguring Chef Infra Server..."
sudo chef-server-ctl reconfigure

echo "Creating admin user and 'myorg' organization..."
sudo chef-server-ctl user-create jdoe John Doe jdoe@example.com 'abc123' --filename jdoe.pem
sudo chef-server-ctl org-create myorg "My Organization" --association_user jdoe --filename myorg-validator.pem

echo "Chef Infra Server has been installed and configured successfully."
