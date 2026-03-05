#!/bin/bash

SUBSCRIPTION_ID=$(az account show --query id -o tsv)
USER_OBJECT_ID=$(az ad signed-in-user show --query id -o tsv)
OBJECT_PATH="resourceGroups/rsg-filipe/providers/Microsoft.Storage/storageAccounts/stterraformstatefilipe"

az role assignment create \
  --assignee $USER_OBJECT_ID \
  --role "Storage Blob Data Contributor" \
  --scope "/subscriptions/$SUBSCRIPTION_ID/$OBJECT_PATH"