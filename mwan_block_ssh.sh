#!/bin/bash

#Script that runs continously and tries to do SSH to a machine on another mwan site
#This script assumes that the session cannot actually be established.
#If SSH is not blocked by magic firewall, connection should still fail because of a lack of SSH key. Result NOT BLOCKED
#If SSH is blocked by magic firewall, connection fails too with result BLOCKED
#Do "chmod +x mwan_block_ssh.sh" to make it executable

while true; do

timestamp=$(date +"%Y-%m-%d %T")

#Waits 2 seconds to check whether the connection can be established
ssh -o ConnectTimeout=2 jose@10.26.26.207 > mwan_block_ssh.txt 2>1&
dump=$(grep "kex_exchange_identification" mwan_block_ssh.txt)
if [ $? -eq 0 ]; then
    mwan_block=$(echo "NOT BLOCKED")
else
    mwan_block=$(echo "BLOCKED")
fi

# Append result to log file
echo "$timestamp - SSH to 10.156.15.234 - $mwan_block" >> mwan_block_ssh_logs.txt

# Output result to console
echo "$timestamp - SSH to 10.156.15.234 - $mwan_block" >> mwan_block_ssh_logs.txt

#echo "Sleeping for 10sec..."
sleep 10
done