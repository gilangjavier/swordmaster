#!/bin/bash

# Update packages and install Docker
echo "Updating packages and installing Docker..."
sudo apt-get update
sudo apt-get install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install docker-ce

# Setup Docker logging
echo "Setting up Docker logging..."
echo '{"log-driver":"json-file","log-opts":{"max-size":"500m"}}' > /etc/docker/daemon.json
sudo systemctl restart docker

# Initialize Docker Swarm
echo "Initializing Docker Swarm..."
sudo docker swarm init

# Install Docker Compose
echo "Installing Docker Compose..."
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Install and setup fail2ban for security
echo "Installing and setting up fail2ban..."
sudo apt-get install fail2ban
sudo systemctl start fail2ban
sudo systemctl enable fail2ban

# Setup UFW firewall rules
echo "Setting up UFW firewall rules..."
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw allow 2376/tcp
sudo ufw allow 7946/tcp
sudo ufw allow 7946/udp
sudo ufw allow 4789/udp
sudo ufw --force enable

# Install and setup a Docker monitoring tool (cAdvisor)
echo "Setting up cAdvisor..."
sudo docker run \
  --volume=/:/rootfs:ro \
  --volume=/var/run:/var/run:ro \
  --volume=/sys:/sys:ro \
  --volume=/var/lib/docker/:/var/lib/docker:ro \
  --publish=8080:8080 \
  --detach=true \
  --name=cadvisor \
  google/cadvisor:latest

echo "Docker Swarm provisioning completed."
