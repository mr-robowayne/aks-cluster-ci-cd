output "cluster_name" {
  value = azurerm_kubernetes_cluster.example.name
}

output "client_certificate" {
  value     = azurerm_kubernetes_cluster.example.kube_config[0].client_certificate
  sensitive = true
}

output "kube_config" {
  value     = azurerm_kubernetes_cluster.example.kube_config_raw
  sensitive = true
}

output "kubelet_principal_id" {
  value = azurerm_kubernetes_cluster.example.kubelet_identity[0].object_id
}