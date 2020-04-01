#!/usr/bin/env bash

####### credentials #######
FILE=.env.local
if [ ! -f "$FILE" ]; then
    echo "$FILE does not exist. Copy .env to .env.local and fill in credentials"
    exit
fi
source .env.local
export AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_DEFAULT_REGION TF_VAR_aws_account_id


####### terraform #######
cd infrastructure/terraform
terraform destroy -auto-approve

rm -rf auth/*
