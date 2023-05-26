#!/bin/bash

# Function to install Ansible on Ubuntu or Debian
install_ansible_debian_based() {
    echo "Updating system..."
    sudo apt update

    echo "Installing software-properties-common..."
    sudo apt install -y software-properties-common

    echo "Adding Ansible PPA..."
    sudo apt-add-repository --yes --update ppa:ansible/ansible

    echo "Updating system..."
    sudo apt update

    echo "Installing Ansible..."
    sudo apt install -y ansible
}

# Function to install Ansible on CentOS, Red Hat or Fedora
install_ansible_rpm_based() {
    echo "Adding EPEL repository..."
    if [ "$ID" == "fedora" ]; then
        sudo dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
        sudo dnf update -y
    else
        sudo yum install -y epel-release
    fi

    echo "Installing Ansible..."
    if [ "$ID" == "fedora" ]; then
        sudo dnf install -y ansible
    else
        sudo yum install -y ansible
    fi
}

# Detect the OS and run the appropriate function
if [ -f /etc/os-release ]; then
    . /etc/os-release
    if [ "$ID" == "ubuntu" ] || [ "$ID" == "debian" ]; then
        install_ansible_debian_based
    elif [ "$ID" == "centos" ] || [ "$ID" == "rhel" ] || [ "$ID" == "fedora" ]; then
        install_ansible_rpm_based
    else
        echo "This script only supports Ubuntu, Debian, CentOS, Red Hat and Fedora."
        exit 1
    fi
else
    echo "Cannot determine OS."
    exit 1
fi

echo "Ansible installation complete."