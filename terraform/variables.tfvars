resource_group_name = "rsg-filipe"
location            = "westeurope"

subnet_name           = "subnet-aks-filipe"
subnet_address_prefix = "10.0.1.0/24"

vnet_name          = "vnet-aks-filipe"
vnet_address_space = "10.0.0.0/16"

cluster_name = "aks-filipe"
node_count   = 1
vm_size      = "Standard_B2s"
tags = {
  env = "dev-terraform"
}
acr_name       = "acrfilipe"
key_vault_name = "vault-filipe"
dns_prefix = "aksfilipe"