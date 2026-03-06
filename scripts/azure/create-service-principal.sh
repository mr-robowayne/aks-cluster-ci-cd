#!/bin/bash
set -euo pipefail

SUBSCRIPTION_ID="$(az account show --query id -o tsv)"
SP_NAME="github-actions-filipe"
RG_NAME="rsg-filipe"
RG_ID="/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RG_NAME}"

az ad sp create-for-rbac \
  --name "${SP_NAME}" \
  --role "Contributor" \
  --scopes "${RG_ID}"