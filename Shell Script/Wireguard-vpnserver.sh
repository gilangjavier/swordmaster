#! /bin/bash
sudo apt update
sudo apt upgrade -y
sudo apt install wireguard -y
sudo -i
mkdir -m 0700 /etc/wireguard/
cd /etc/wireguard/
#Create Private Key and Public Key for Configuration
umask 077; wg genkey | tee privatekey | wg pubkey > publickey
ls -l privatekey publickey
PRIVKEY_VAR=$(cat privatekey)
PUBLICKEYFROMCLIENT=Put_Public_Key_on_here

#Create Config File
cp /etc/wireguard/wg0.conf /etc/wireguard/wg0.conf.orig
cat <<EOT> /etc/wireguard/wg0.conf
## Set Up WireGuard VPN on Ubuntu By Editing/Creating wg0.conf File ##
[Interface]
## My VPN server private IP address ##
Address = 192.168.6.1/24
 
## My VPN server port ##
ListenPort = 41194
 
## VPN server's private key i.e. /etc/wireguard/privatekey ##
PrivateKey = $PRIVKEY

[Peer]
## Desktop/client VPN public key ##
PublicKey = $PUBLICKEYFROMCLIENT
 
## client VPN IP address (note  the /32 subnet) ##
AllowedIPs = 192.168.6.2/32
EOT

sudo systemctl enable wg-quick@wg0
sudo systemctl start wg-quick@wg0
sudo systemctl status wg-quick@wg0

#TEST Connections
ping -c 4 192.168.6.1