output "vnet_id" {
  value       = azurerm_virtual_network.this.id
  description = "ID of the virtual network"
}

output "vnet_name" {
  value       = azurerm_virtual_network.this.name
  description = "Name of the virtual network"
}

output "subnet_id" {
  value       = azurerm_subnet.this.id
  description = "ID of the subnet — pass this to AKS module"
}

output "subnet_name" {
  value       = azurerm_subnet.this.name
  description = "Name of the subnet"
}