#!/bin/bash

# Check if the script is run as root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Determine the Linux distribution
OS=$(awk -F= '/^NAME/{print $2}' /etc/os-release)

# Install Octopus Deploy
if [[ $OS == *"Ubuntu"* ]] || [[ $OS == *"Debian"* ]]; then
  echo "Installing Octopus Deploy on $OS"

  # Import Octopus key
  wget -qO- https://download.octopusdeploy.com/octopus-tools/dists/stretch/main/binary-amd64/Packages.gz | gzip -d | awk '/^Package: octopuscli$/,/^$/{print}' | awk -F ": " '/SHA256/ {print $2}' | xargs echo -n | wget -O - https://download.octopus.com/octopus.key | apt-key add -

  # Add Octopus repository
  echo "deb https://download.octopusdeploy.com/octopus-tools/ stretch main" | tee /etc/apt/sources.list.d/octopus.com.list > /dev/null

  # Update repository list and install Octopus Deploy
  apt-get update && apt-get install octopuscli -y

elif [[ $OS == *"CentOS"* ]] || [[ $OS == *"Red Hat"* ]]; then
  echo "Installing Octopus Deploy on $OS"

  # Install the .NET Core and Octopus Deploy prerequisites
  yum install -y libunwind libicu
  
  # Enable the .NET SDK repository
  rpm -Uvh https://packages.microsoft.com/config/rhel/7/packages-microsoft-prod.rpm

  # Install the .NET Core SDK
  yum update -y
  yum install -y dotnet-sdk-2.2

  # Install Octopus CLI
  curl -L -o octo.tar.gz https://octopus.com/downloads/latest/Linux_x64TarGz/Octo
  mkdir octo
  tar xvzf octo.tar.gz -C octo
  sudo chmod +x octo/Octo
  sudo ln -s /opt/octopus/octo/Octo /usr/local/bin/
else
  echo "$OS is not supported"
  exit 1
fi
