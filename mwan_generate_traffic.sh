#!/bin/bash

#Script that runs continously and fetches resources in the internet and behind cloudflare tunnel and mwan site
#Do "chmod +x mwan_generate_traffic.sh" to make it executable
while true; do
 
#Get current timestamp
timestamp=$(date +"%Y-%m-%d %T")

# Make a curl request to get the current public IP
ip_address=$(curl --max-time 2 -s https://ipv4.icanhazip.com/)                                                  

# Make a curl request to an external website in the internet                                                                                         
external_content=$(curl --max-time 2 -s https://www.techmeme.com)                                               
echo " $external_content" > mwan_generate_traffic_external.txt                                                            
dump=$(grep "DOCTYPE" mwan_generate_traffic_external.txt)                                                                 
if [ $? -eq 0 ]; then                                                                              
    external_reachable=$(echo "OK")
else
    external_reachable=$(echo "NOK")
fi

# Make a curl request to an internal website available via cloudflared
internal_content_cfd=$(curl --max-time 2 -s http://10.132.0.2)
echo " $internal_content_cfd" > mwan_generate_traffic_cfd.txt
dump=$(grep "DOCTYPE" mwan_generate_traffic_cfd.txt)
if [ $? -eq 0 ]; then
    internal_reachable_cfd=$(echo "OK")
else
    internal_reachable_cfd=$(echo "NOK")
fi

# Make a curl request to an internal website available via magic wan
internal_content_mwan=$(curl --max-time 2 -s http://10.186.0.55)
echo " $internal_content_mwan" > mwan_generate_traffic_mwan.txt
dump=$(grep "DOCTYPE" mwan_generate_traffic_mwan.txt)
if [ $? -eq 0 ]; then
    internal_reachable_mwan=$(echo "OK")
else
    internal_reachable_mwan=$(echo "NOK")
fi

# Make a curl request to an internal website available via cloudflared (httpbin blocked by Magic Firewall)
internal_content_httpbin=$(curl --max-time 2 -s http://10.156.15.234)
echo " $internal_content_httpbin" > mwan_generate_traffic_httpbin.txt
dump=$(grep "DOCTYPE" mwan_generate_traffic_httpbin.txt)
if [ $? -eq 0 ]; then
    internal_reachable_httpbin=$(echo "OK")
else
    internal_reachable_httpbin=$(echo "NOK")
fi

# Append result to log file
echo "$timestamp - $ip_address. Reachability: Cfd $internal_reachable_cfd MWan $internal_reachable_mwan Ext $external_reachable Httpbin $internal_reachable_httpbin" >> mwan_generate_traffic_logs.txt

# Output result to console
echo "$timestamp - $ip_address. Reachability: Cfd $internal_reachable_cfd MWan $internal_reachable_mwan Ext $external_reachable Httpbin $internal_reachable_httpbin"
   
#echo "Sleeping for 60sec..."
sleep 60
done