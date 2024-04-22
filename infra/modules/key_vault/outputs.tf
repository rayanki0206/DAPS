#outputs keyvault id
output "key_vault_id" {
  value = azurerm_key_vault.daps.id
}
#outputs key vault uri
output "key_vault_uri" {
  value = azurerm_key_vault.daps.vault_uri
}