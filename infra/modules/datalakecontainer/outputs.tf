output "datalake_container_id" {
  value = azurerm_storage_container.dapp.id
}
output "datalake_name" {
  value = data.azurerm_storage_account.dapp.name
}
output "datalake_resource_group_name" {
  value = data.azurerm_storage_account.dapp.resource_group_name
}
output "datalake_id" {
  value = data.azurerm_storage_account.dapp.id
}
output "container_has_immutable_policy" {
  value = azurerm_storage_container.dapp.has_immutability_policy
}
output "container_name" {
  value = azurerm_storage_container.dapp.name
}