#!/bin/bash

#Script that runs continously and tries to do SSH to a machine on another mwan site
#This script assumes that there is a Magic Firewall rule blocking the SSH connection from being established
#Do "chmod +x mwan_block_ssh.sh" to make it executable

while true; do

timestamp=$(date +"%Y-%m-%d %T")

echo "$timestamp"
ssh_access=$(ssh -o ConnectTimeout=2 jose@10.26.26.207)
   
#echo "Sleeping for 10sec..."
sleep 10
done