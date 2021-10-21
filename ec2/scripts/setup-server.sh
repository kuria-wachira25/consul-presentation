#!/bin/bash

# Set up variables
SERVER_CERTIFICATE_KEY=$1
NODE_NAME=$2
ENCRYPTION_KEY=$3
BIND_ADDRESS=$4
ADVERTISE_ADDRESS=$5

# Create consul user
sudo adduser consul --disabled-password

# Change To tmp directory
mkdir -p ~/consul
cd ~/consul

# Install consul binary
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum -y install consul

# Create consul.d directory
sud mkdir -p /etc/consul.d/

# Create data directory
sud mkdir -p /opt/consul/data

# Setup configs
echo "$SERVER_CERTIFICATE_KEY" > ./certs/server-certificate.key
cp -R . /etc/consul.d/


# Setup consul.service via systemd
if [ ! -f "/etc/systemd/system/consul.service" ]
then
sudo cp /etc/consul.d/systemd/consul.service /etc/systemd/system/consul.service
sudo systemctl daemon-reload
sudo systemctl enable consul.service
sudo systemctl start consul.service
else
sudo systemctl restart consul.service
fi

# Clean up
rm -rf ~/consul