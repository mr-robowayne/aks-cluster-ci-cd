#!/bin/bash

SUBSCRIPTION_ID=$(az account show --query id -o tsv)
ROLE_NAME="github-actions-filipe"
PERMISSSION="Contributor"

az ad sp create-for-rbac \
    --name $ROLE_NAME \
    --role $PERMISSSION \
    --scopes /subscriptions/$SUBSCRIPTION_ID
