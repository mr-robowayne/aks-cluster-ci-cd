
resource "azurerm_kubernetes_cluster" "example" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.cluster_name
  kubernetes_version  = "1.32.4"

  default_node_pool {
    name                 = "default"
    node_count           = var.node_count
    vm_size              = var.vm_size
    vnet_subnet_id       = var.subnet_id
    orchestrator_version = "1.32.4"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}