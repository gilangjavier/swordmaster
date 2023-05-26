#!/bin/bash

# Define username and password
username="myuser"
password="mypassword"

# Squid config file path
squid_conf="/etc/squid/squid.conf"

# Function to install and configure Squid on Ubuntu or Debian
configure_squid_debian_based() {
    echo "Updating system..."
    sudo apt update

    echo "Installing apache2-utils..."
    sudo apt install -y apache2-utils

    echo "Creating password file..."
    sudo htpasswd -b -c /etc/squid/passwords $username $password

    echo "Updating Squid configuration..."
    sudo echo "auth_param basic program /usr/lib/squid/basic_ncsa_auth /etc/squid/passwords" >> $squid_conf
    sudo echo "auth_param basic children 5" >> $squid_conf
    sudo echo "auth_param basic realm Squid Basic Authentication" >> $squid_conf
    sudo echo "auth_param basic credentialsttl 2 hours" >> $squid_conf
    sudo echo "acl auth_users proxy_auth REQUIRED" >> $squid_conf
    sudo echo "http_access allow auth_users" >> $squid_conf

    echo "Restarting Squid service..."
    sudo systemctl restart squid.service
}

# Function to install and configure Squid on CentOS, Red Hat or Fedora
configure_squid_rpm_based() {
    echo "Updating system..."
    if [ "$ID" == "fedora" ]; then
        sudo dnf update -y
    else
        sudo yum update -y
    fi

    echo "Installing httpd-tools..."
    if [ "$ID" == "fedora" ]; then
        sudo dnf install -y httpd-tools
    else
        sudo yum install -y httpd-tools
    fi

    echo "Creating password file..."
    sudo htpasswd -b -c /etc/squid/passwords $username $password

    echo "Updating Squid configuration..."
    sudo echo "auth_param basic program /usr/lib64/squid/basic_ncsa_auth /etc/squid/passwords" >> $squid_conf
    sudo echo "auth_param basic children 5" >> $squid_conf
    sudo echo "auth_param basic realm Squid Basic Authentication" >> $squid_conf
    sudo echo "auth_param basic credentialsttl 2 hours" >> $squid_conf
    sudo echo "acl auth_users proxy_auth REQUIRED" >> $squid_conf
    sudo echo "http_access allow auth_users" >> $squid_conf

    echo "Restarting Squid service..."
    sudo systemctl restart squid.service
}

# Detect the OS and run the appropriate function
if [ -f /etc/os-release ]; then
    . /etc/os-release
    if [ "$ID" == "ubuntu" ] || [ "$ID" == "debian" ]; then
        configure_squid_debian_based
    elif [ "$ID" == "centos" ] || [ "$ID" == "rhel" ] || [ "$ID" == "fedora" ]; then
        configure_squid_rpm_based
    else
        echo "This script only supports Ubuntu, Debian, CentOS, Red Hat, and Fedora."
        exit 1
    fi
else
    echo "Cannot determine OS."
    exit 1
fi

echo "Squid configuration complete."