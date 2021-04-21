#!/bin/bash

# Pings the webhook so that we can gather
# basic usage stats

export UUID=$(cat /proc/sys/kernel/random/uuid)

while true; do

    DATA="-F date=$(date +%d/%m/%y) -F time=$(date +%H:%M:%S) -F uuid=${UUID}"

    curl -X POST $DATA https://hooks.zapier.com/hooks/catch/4753778/ov8o90g/silent/

    sleep 300
done
