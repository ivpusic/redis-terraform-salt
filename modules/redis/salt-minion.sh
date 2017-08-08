#!/bin/bash

SALT_MASTER_IP=$1

echo 'starting salt installation...'

wget -O - https://repo.saltstack.com/apt/ubuntu/16.04/amd64/latest/SALTSTACK-GPG-KEY.pub | sudo apt-key add -

cat << EOF | sudo tee -a /etc/apt/sources.list.d/saltstack.list
deb http://repo.saltstack.com/apt/ubuntu/16.04/amd64/latest xenial main
EOF

sudo apt update

sudo apt install -y salt-minion

sudo cp /tmp/grains /etc/salt/grains

echo 'injecting salt master ip address'
sudo sed -i s/'#master: salt'/"master: $SALT_MASTER_IP"/g /etc/salt/minion

sudo systemctl enable salt-minion.service

sudo systemctl restart salt-minion.service

echo 'salt installation done'
