#gives az_ad_dev_group object id
data "azuread_group" "ad_dev" {
  #display_name = local.ad_developers_group
  count        = var.ad_developers_group != "" ? 1 : 0
  display_name = var.ad_developers_group
}


#gives az_ad_admins_group object id
data "azuread_group" "ad_admins" {
  #display_name = local.ad_admins_group
  count        = var.ad_admins_group != "" ? 1 : 0
  display_name = var.ad_admins_group
}
data "azurerm_resources" "df" {
  type = "microsoft.datafactory/factories"
}

#gives object id and tenant id that are used in keyvault
data "azurerm_client_config" "daps" {

}
data "azurerm_subscription" "dapp" {

}
data "azurerm_resources" "storageaccounts" {
  type = "microsoft.storage/storageaccounts"
}

data "azurerm_data_factory" "identity_management_rbac" {
  #name = local.df_name
  count               = var.datafactory != "" ? 1 : 0
  provider            = azurerm.data_factory
  name                = var.datafactory
  resource_group_name = local.df_rg_name
  #resource_group_name = upper(local.rg_name)
}
data "azuread_service_principal" "rbac_storage_blob_data_contributor" {
  #display_name = local.service_principal
  count        = var.service_principal != "" ? 1 : 0
  display_name = var.service_principal
}

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

data "azurerm_resources" "databricks" {
  type = "microsoft.databricks/workspaces"
}
# deploys databricks operations as per Dataproduct Spreadsheet
data "azurerm_databricks_workspace" "dbs-ws" {
  name                = var.databricks_workspace_name
  resource_group_name = local.dbks_rg_name
}

data "databricks_group" "admins" {
  provider     = databricks.azure_account
  count        = var.ad_admins_group != "" ? 1 : 0
  display_name = var.ad_admins_group
}
data "databricks_group" "developers" {
  provider     = databricks.azure_account
  count        = var.ad_developers_group != "" ? 1 : 0
  display_name = var.ad_developers_group
}

data "databricks_group" "clustergroups1" {
  provider     = databricks.azure_account
  display_name = "cluster - General 01"
}
data "databricks_group" "clustergroups2" {
  provider     = databricks.azure_account
  display_name = "cluster - General 02"
}

data "azurerm_resources" "kv" {
  provider = azurerm.functional_area #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  type     = "microsoft.keyvault/vaults"
}
data "azurerm_resources" "df" {
  provider = azurerm.functional_area #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  type     = "microsoft.datafactory/factories"
}
data "azurerm_data_factory" "spn" {
  provider            = azurerm.functional_area #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  count               = var.datafactory != "" ? 1 : 0
  name                = var.datafactory
  resource_group_name = local.df_rg_name
}
data "azuread_service_principal" "spn" {
  count        = var.service_principal != "" ? 1 : 0
  display_name = var.service_principal
}
data "databricks_group" "dbks_admins_group" {
  provider = databricks.azure_account
  display_name = "admins"
}
data "azurerm_key_vault" "keyvault" {
  provider            = azurerm.functional_area #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  count               = var.keyvault != "" ? 1 : 0
  name                = var.keyvault
  resource_group_name = local.kv_rg_name
  # depends_on          = [module.keyvault, azurerm_key_vault_access_policy.tfadmin]
}