variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "acr_name" {
  type        = string
  description = "Must be globally unique only alphanumeric"
}

variable "sku" {
  type        = string
  default     = "Basic"
  description = "Basic Standard or Premium"
}

variable "aks_principal_id" {
  type        = string
  description = "AKS kubelet identity principal ID for AcrPull role"
}

variable "tags" {
  type = map(string)
}