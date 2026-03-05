output "ressource_group_id" {
  description = "resource group id value"
  value       = azurerm_resource_group.rg_demo.id
}
output "ressource_group_location" {
  description = "location of the ressource group"
  value       = azurerm_resource_group.rg_demo.location
}
output "resource_group_name" {
  description = "resource group name"
  value       = azurerm_resource_group.rg_demo.name
}