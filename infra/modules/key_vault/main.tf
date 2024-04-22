# this data block provides object id and tenant id
data "azurerm_client_config" "daps" {
  
}

#creates a key vault resource
resource "azurerm_key_vault" "daps" {
  name                        = var.keyvault_Name
  resource_group_name         = var.resource_group_name
  location                    = var.location
  sku_name                    = "standard"
  tenant_id                   = data.azurerm_client_config.daps.tenant_id
  enabled_for_disk_encryption = true
  enabled_for_template_deployment = true
  # soft_delete_enabled         = true
  
  ### Uncomment if the DAPS SPN have to set / Get / List from DAPS Keyvault

  # access_policy {
  #   tenant_id = data.azurerm_client_config.daps.tenant_id
  #   object_id = data.azurerm_client_config.daps.object_id

  #   key_permissions = [
  #     "Get"
  #   ]

  #   secret_permissions = [
  #     "Get","Set","Delete"
  #   ]

  #   storage_permissions = [
  #     "Get","Set","Delete"
  #   ]
  # }
}