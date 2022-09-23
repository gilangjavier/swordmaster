#! /bin/bash
sudo apt update
sudo apt upgrade -y
sudo apt install wireguard -y

sudo sh -c 'umask 077; touch /etc/wireguard/wg0.conf'
sudo -i
cd /etc/wireguard/
umask 077; wg genkey | tee privatekey | wg pubkey > publickey
ls -l publickey privatekey

PUBLICKEYFROMSERVER=Put_Public_Key_on_here
PRIVKEY_VAR=$(cat privatekey)

cp /etc/wireguard/wg0.conf /etc/wireguard/wg0.conf.orig
cat <<EOT> /etc/wireguard/wg0.conf
[Interface]
## This Desktop/client's private key ##
PrivateKey = $PRIVKEY_VAR
 
## Client ip address ##
Address = 192.168.6.2/24
 
[Peer]
## Ubuntu 20.04 server public key ##
PublicKey = $PUBLICKEYFROMSERVER
 
## set ACL ##
AllowedIPs = 192.168.6.0/24
 
## Your VPN server's public IPv4/IPv6 address and port ##
Endpoint = 172.105.112.120:41194
 
##  Key connection alive ##
PersistentKeepalive = 15
EOT

sudo systemctl enable wg-quick@wg0
sudo systemctl start wg-quick@wg0
sudo systemctl status wg-quick@wg0

