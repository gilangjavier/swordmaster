#! /bin/bash
echo "***********************************************"
echo "Installing Certbot for managing SSL Certificate"
echo "***********************************************"
apt-get update 
sudo apt-get install certbot python3-certbot-nginx -y
#Setup dns and email.
sudo certbot certonly --agree-tos --email sample@sampel.com -d domain_name
#Run LS Command to see Certificate Directory
ls /etc/letsencrypt/live/*domain_name/

