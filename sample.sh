#!/bin/bash


mkdir present
cd present 
touch variable.txt
CURRENT_TIME=$(date +"%Y-%m-%d %H:%M:%S")

IP_ADDRESS=$(hostname -I | awk '{print $1}')
LINE_COUNT=$(wc -l < variable.txt)
echo "current time: $CURRENT_TIME"
echo "IP Address: $IP_ADDRESS"
echo "number of lines in the file: $LINE_COUNT"









































































