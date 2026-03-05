terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.62.0"
    }
  }
}
provider "azurerm" {
  features {}
}
module "ressource_group" {
  source              = "../modules/azure/backend/ressource-group"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}

module "azure_key_vault" {
  source              = "../modules/azure/backend/key-vault"
  vault_name          = var.vault_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tenant_id           = var.tenant_id
  azure_id            = var.user_id
}

module "storage_account" {
  source                   = "../modules/azure/backend/storage-account"
  storage_account_name     = var.storage_account_name
  resource_group_name      = module.ressource_group.resource_group_name
  location                 = module.ressource_group.ressource_group_location
  account_replication_type = var.account_replication_type
  public_access            = var.public_access
  tags                     = var.tags
}

module "storage_container" {
  source                 = "../modules/azure/backend/storage-container"
  storage_container_name = var.storage_container_name
  storage_account_id     = module.storage_account.storage_account_id
  container_access_type  = var.container_access_type
}