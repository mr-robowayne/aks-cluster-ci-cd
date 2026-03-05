# ressource group
variable "resource_group_name" {
  type        = string
  description = "ressource group name value"
}
variable "location" {
  type        = string
  description = "location value"
}
## key vault 

variable "key_vault_name" {
  type        = string
  description = "Name of Azure key vault"
}
## aks network 
variable "vnet_name" {
  type        = string
  description = "Name of the virtual network"
}

variable "vnet_address_space" {
  type        = string
  description = "Address space for the VNet e.g. 10.0.0.0/8"
}

variable "subnet_name" {
  type        = string
  description = "Name of the subnet"
}

variable "subnet_address_prefix" {
  type        = string
  description = "Address prefix for the subnet e.g. 10.0.1.0/24"
}

## aks cluster
variable "cluster_name" {
  type        = string
  description = "Name of aks cluster"
}
variable "node_count" {
  type        = number
  description = "number of worker nodes on cluster"
}
variable "vm_size" {
  type        = string
  description = "size of the worker nodes example: Standard_DS2_v2"
}
variable "tags" {
  type = map(string)
}
## container regristry 

variable "acr_name" {
  type        = string
  description = "Must be globally unique only alphanumeric"
}

variable "sku" {
  type        = string
  default     = "Basic"
  description = "Basic Standard or Premium"
}
variable "dns_prefix" {
  type = string
}