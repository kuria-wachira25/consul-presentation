#!/bin/bash

# Set up variables
ENCRYPTION_KEY=$1
BIND_ADDRESS=$2
ADVERTISE_ADDRESS=$3
NODE_NAME=$4
SERVICE_ID=$5

# Create consul user
sudo adduser consul

# Add consul user to consul group
sudo usermod -a -G consul consul

# Install consul binary
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum -y install consul

# Create consul.d directory
sudo mkdir -p /etc/consul.d/
sudo chown consul /etc/consul.d/

# Create data directory
sudo mkdir -p /opt/consul/data
sudo chown consul /opt/consul/data

# Setup configs
sed -i -e "s/NODE_NAME/$NODE_NAME/g" /home/ec2-user/consul/client-config.json
sed -i -e "s/ENCRYPTION_KEY/$ENCRYPTION_KEY/g" /home/ec2-user/consul/client-config.json
sed -i -e "s/BIND_ADDRESS/$BIND_ADDRESS/g" /home/ec2-user/consul/client-config.json
sed -i -e "s/ADVERTISE_ADDRESS/$ADVERTISE_ADDRESS/g" /home/ec2-user/consul/client-config.json
sed -i -e "s/SERVICE_ID/$SERVICE_ID/g" /home/ec2-user/consul/systemd/consul-connect.service
sudo cp -R /home/ec2-user/consul/ /etc/consul.d/

# Setup consul.service via systemd
if [ ! -f "/etc/systemd/system/consul.service" ]
then
sudo cp /etc/consul.d/consul/systemd/consul.service /etc/systemd/system/consul.service
sudo systemctl daemon-reload
sudo systemctl enable consul.service
sudo systemctl start consul.service
else
sudo systemctl restart consul.service
fi

# Allow agent to first join cluster
sleep 20

# Register service
consul services register /etc/consul.d/consul/client-app-service.json

# Set up httpd
sudo yum install -y httpd.x86_64
sudo systemctl enable httpd
sudo systemctl start httpd

# Clean up
sudo rm -rf /home/ec2-user/consul
sudo rm -rf /etc/consul.d/consul/systemd
sudo rm -rf /etc/consul.d/consul/scripts