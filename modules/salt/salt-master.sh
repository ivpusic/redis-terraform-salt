#!/bin/bash

echo 'starting salt installation...'

wget -O - https://repo.saltstack.com/apt/ubuntu/16.04/amd64/latest/SALTSTACK-GPG-KEY.pub | sudo apt-key add -

cat << EOF | sudo tee -a /etc/apt/sources.list.d/saltstack.list
deb http://repo.saltstack.com/apt/ubuntu/16.04/amd64/latest xenial main
EOF

sudo apt update

sudo apt install -y salt-master

sudo systemctl enable salt-master.service

sudo systemctl restart salt-master.service

echo 'salt installation done'

echo 'changing hostname...'

sudo hostnamectl set-hostname salt
