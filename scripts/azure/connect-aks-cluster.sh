#!bin/bash 

RESSOURCE_GROUP="rsg-filipe"
AKS_NAME="aks-filipe"

az aks get-credentials \
    --resource-group $RESSOURCE_GROUP \
    --name $AKS_NAME 