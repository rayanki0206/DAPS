#outputs  storage account id
output "storage_account_id" {
  value = azurerm_storage_account.daps.id
}

#outputs account tier
output "storage_account_tier" {
  value = azurerm_storage_account.daps.account_tier
}

#outputs location
output "storage_account_location" {
  value = azurerm_storage_account.daps.location
}