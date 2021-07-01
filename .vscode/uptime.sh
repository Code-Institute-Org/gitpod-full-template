#!/bin/bash

# Pings the webhook so that we can gather
# basic usage stats. No personally identifiable
# data is captured here, and it is impossible to
# identify an individual user from the captured data.
# Matt Rudge, April 2021

UUID=$(cat /proc/sys/kernel/random/uuid)
URL=https://1xthkmzwg3.execute-api.eu-west-1.amazonaws.com/prod/lrsapi/
API_KEY=jceBCdeGZP9RDeUNCfM4jIQ39Cx0jtG51QgcwDwc
VERB="started"

clear

while true; do

    DATA="{\"activity_time\":\"$(date +%Y-%m-%dT%H:%M:%S).000Z\",\"actor\":\"${UUID}\",\"verb\":\"${VERB}\",\"activity_object\":\"Gitpod Workspace\",\"extra_data\":\"{}\"}"
    curl -s -X POST  -H "x-api-key: ${API_KEY}" -d "${DATA}" ${URL} 1> /dev/null
    VERB="running"
    sleep 300

done
