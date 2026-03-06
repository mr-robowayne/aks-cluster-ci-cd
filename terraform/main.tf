terraform {
  required_version = "~> 1.7.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.22"
    }
  }
  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

data "azurerm_key_vault" "this" {
  name                = var.key_vault_name
  resource_group_name = var.resource_group_name
}

module "aks_network" {
  source                = "./modules/azure/aks-network"
  resource_group_name   = var.resource_group_name
  location              = var.location
  vnet_name             = var.vnet_name
  vnet_address_space    = var.vnet_address_space
  subnet_name           = var.subnet_name
  subnet_address_prefix = var.subnet_address_prefix
  tags                  = var.tags
}

module "kubernetes_cluster" {
  source              = "./modules/azure/aks-cluster"
  cluster_name        = var.cluster_name
  resource_group_name = var.resource_group_name
  dns_prefix = var.dns_prefix
  location            = var.location
  node_count          = var.node_count
  subnet_id           = module.aks_network.subnet_id
  vm_size             = var.vm_size
  tags                = var.tags
}

resource "azurerm_key_vault_secret" "kube_config" {
  name         = "aks-kube-config"
  value        = module.kubernetes_cluster.kube_config
  key_vault_id = data.azurerm_key_vault.this.id
}

module "container_registry" {
  source              = "./modules/azure/container-registry"
  resource_group_name = var.resource_group_name
  location            = var.location
  acr_name            = var.acr_name
  sku                 = var.sku
  aks_principal_id    = module.kubernetes_cluster.kubelet_principal_id
  tags                = var.tags
}
