# ressource group
variable "resource_group_name" {
  type        = string
  description = "ressource group name value"
}

variable "location" {
  type        = string
  description = "location value"
}
# azure key vault
variable "vault_name" {
  type = string
}
variable "tenant_id" {
  type = string
}
variable "user_id" {
  type = string
}
# storage account 
variable "storage_account_name" {
  type = string
}
variable "account_replication_type" {
  type = string
}
variable "public_access" {
  type = string
}

# storage container 
variable "storage_container_name" {
  type = string
}

variable "container_access_type" {
  type = string
}

# tags 
variable "tags" {
  type = map(string)
}