locals {
    dbks_workspace = data.azurerm_resources.databricks.resources
    valid_dbks = {for resource in data.azurerm_resources.databricks.resources : resource.name => resource
    if contains(tolist([var.databricks_workspace_name]), resource.name)
    }
dbks_rg = local.valid_dbks
dbks_rg_name = values(local.dbks_rg)[0].resource_group_name
key_vault = data.azurerm_resources.kv.resources
  valid_kv = {
    for res in local.key_vault: res.name => res
    if contains(tolist([var.keyvault]),res.name)
  }
  kv = local.valid_kv
  kv_rg_name = values(local.kv)[0].resource_group_name
}