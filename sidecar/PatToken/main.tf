data "azurerm_resources" "databricks" {
  type = "microsoft.databricks/workspaces"
}

data "azurerm_databricks_workspace" "dbs-ws" {
  name                = var.databricks_workspace_name
  resource_group_name = local.dbks_rg_name
}

resource "databricks_token" "pat" {
  provider = databricks.azure_account
  #count = var.service_principal !
  comment  = "DIDQ"
  // 100 day token
  #lifetime_seconds = 8640000
}
data "azurerm_resources" "kv" {
provider = azurerm.functional_area
type = "microsoft.keyvault/vaults"
}
data "azurerm_key_vault" "keyvault" {
  provider = azurerm.functional_area
  #count = var.keyvault != "" ? 1 : 0
  name = var.keyvault
  resource_group_name = local.kv_rg_name
}
resource "azurerm_key_vault_secret" "pat_token_kv" {
  provider = azurerm.functional_area#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  name         = "Serviceprincipal-ADBUserToken"
  content_type = "Databricks User Token - ${var.service_principal}"
  value        = databricks_token.pat.token_value
  key_vault_id = data.azurerm_key_vault.keyvault.id
  depends_on   = [databricks_token.pat]
}