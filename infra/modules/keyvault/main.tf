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
  soft_delete_retention_days  = 90
  purge_protection_enabled = true
  public_network_access_enabled = true
  tags = {
    project = var.appmnemonic
  }
}
