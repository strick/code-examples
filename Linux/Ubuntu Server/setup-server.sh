#!/bin/bash

# Check if a port argument was provided
if [ $# -eq 0 ]; then
    echo "No port specified. Usage: $0 <SSH Port>"
    exit 1
fi

SSH_PORT=$1

# Update and upgrade packages
sudo apt-get update && sudo apt-get upgrade -y

# Change SSH port
sudo sed -i "s/#Port 22/Port $SSH_PORT/g" /etc/ssh/sshd_config
sudo systemctl restart sshd

# Install and configure UFW
sudo apt-get install ufw -y
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow $SSH_PORT/tcp # Allow new SSH port
sudo ufw enable

# Install NTP
sudo apt-get install ntp -y

# Install Fail2Ban
sudo apt-get install fail2ban -y
sudo systemctl enable fail2ban
sudo systemctl start fail2ban

echo "Setup completed with SSH port set to $SSH_PORT."
