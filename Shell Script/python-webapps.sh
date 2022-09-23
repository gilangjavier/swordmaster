#!/bin/bash
git clone https://github.com/WillKoehrsen/recurrent-neural-networks.git
sudo apt-get update
sudo apt-get install python3-pip -y
cd recurrent-neural-networks
pip3 install --user -r requirements.txt
screen -R deploy
python3 run_keras_server.py #sample Webapps