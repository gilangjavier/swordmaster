#!/bin/bash

# Check the linux distro
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO=$ID
else
    DISTRO=$(uname -s)
fi

# Install Chef Infra Client based on the detected distro
echo "Installing Chef Infra Client..."

if [ "$DISTRO" == "debian" ] || [ "$DISTRO" == "ubuntu" ]; then
    sudo apt-get update -y
    sudo apt-get install -y curl
    curl https://omnitruck.chef.io/install.sh | sudo bash -s -- -P chef -v 15.14.0
elif [ "$DISTRO" == "centos" ] || [ "$DISTRO" == "fedora" ]; then
    sudo yum update -y
    sudo yum install -y curl
    curl https://omnitruck.chef.io/install.sh | sudo bash -s -- -P chef -v 15.14.0
else 
    echo "Unsupported distribution. This script supports Debian, Ubuntu, CentOS, and Fedora."
    exit 1
fi

echo "Chef Infra Client has been installed successfully."

# Assume that jdoe.pem and myorg-validator.pem are available in /tmp directory
sudo mkdir -p /etc/chef
sudo cp /tmp/jdoe.pem /etc/chef/
sudo cp /tmp/myorg-validator.pem /etc/chef/

# Create the client.rb
echo "Creating the client.rb..."
sudo bash -c 'cat > /etc/chef/client.rb' << EOF
log_level        :info
log_location     STDOUT
chef_server_url  'https://chef-server.example.com/organizations/myorg'
validation_client_name 'myorg-validator'
validation_key   '/etc/chef/myorg-validator.pem'
client_key       '/etc/chef/jdoe.pem'
EOF

echo "Running Chef Client for the first time..."
sudo chef-client

echo "Chef Client has been configured successfully."
