#! /bin/bash
#Creating DNS MX Record in Domain Provider

sudo apt update
sudo apt upgrade -y
PASS=ADD_PASSWORD

useradd user1
passwrd user1 $PASS

sudo echo "127.0.0.1       mail.your-domain.com localhost" >> /etc/hosts
hostname -f

wget https://github.com/iredmail/iRedMail/archive/1.5.0.tar.gz q -P /tmp
tar xzfC /tmp/1.5.0.tar.gz /tmp
cd /tmp/iRedMail-1.5.0/
chmod +x iRedMail.sh
sudo bash iRedMail.sh

#CONTINUE THE INSTALLATION