output "backend" {
  value = {
    ressource_group_id   = module.ressource_group.ressource_group_id
    storage_account_id   = module.storage_account.storage_account_id
    storage_container_id = module.storage_container.container_id
  }
}