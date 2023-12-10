#!/bin/bash

# Install iptables-persistent
sudo apt install iptables-persistent -y

# Restart iptables
sudo systemctl restart iptables

# Enable IP forwarding
echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward
sysctl net.ipv4.ip_forward=1

# Prompt for user input - Port Server Iran
read -p "Enter Port for Server Iran: " PORTIRAN

# Prompt for user input - IP Server Kharej
read -p "Enter IP for Server Kharej: " IPKHAREJ

# Prompt for user input - Port Server Kharej
read -p "Enter Port for Server Kharej: " PORTKHAREJ

# Find the server's interface logical name
ENS3=$(sudo lshw -class network | awk '/logical name/{print $3}')

# Run iptables commands
sudo iptables -t nat -A POSTROUTING -j MASQUERADE
sudo iptables -t nat -A PREROUTING -p tcp -i "$ENS3" --dport "$PORTIRAN" -j DNAT --to-destination "$IPKHAREJ":"$PORTKHAREJ"
sudo iptables-save | sudo tee /etc/iptables/rules.v4
