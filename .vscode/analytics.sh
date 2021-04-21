#!/bin/bash

# Pings the webhook so that we can gather
# basic usage stats

DATA="-F date=$(date +%d/%m/%y) -F time=$(date +%H:%M:%S) -F user=${GITPOD_GIT_USER_EMAIL} -F repo=${GITPOD_WORKSPACE_CONTEXT_URL}"

curl -X POST $DATA https://hooks.zapier.com/hooks/catch/4753778/ov8o90g
