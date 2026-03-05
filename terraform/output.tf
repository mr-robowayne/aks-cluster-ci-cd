output "vnet_id" {
  value = module.aks_network.vnet_id
}

output "vnet_name" {
  value = module.aks_network.vnet_name
}

output "subnet_id" {
  value = module.aks_network.subnet_id
}

output "subnet_name" {
  value = module.aks_network.subnet_name
}

output "cluster_name" {
  value = module.kubernetes_cluster.cluster_name
}