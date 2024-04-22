
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


## Datacontainer block

module "datalakecontainer" {
  #count = var.existing_datalake != "" ? 1 : 0
  source                       = "../infra/modules/datalakecontainer"
  datalake_container_name      = local.dl_container
  datalake_resource_group_name = local.dlsa_rg_name
  existing_datalake            = var.existing_datalake #"bdaze1icommdl13"
  # datalake_resource_group_name = local.dl_rg_name
  # existing_datalake            = local.dl_storage_account
  # datalake_ad_group_dev        = [data.azuread_group.az_ad_dev.display_name]
  # datalake_ad_group_admins     = [data.azuread_group.az_ad_admins.display_name]
  # depends_on                   = [data.azuread_group.az_ad_dev, data.azuread_group.az_ad_admins]
}

data "azurerm_data_factory" "identity_management_rbac" {
  #name = local.df_name
  count               = var.data_factory_name != "" ? 1 : 0
  provider            = azurerm.data_factory
  name                = var.data_factory_name
  resource_group_name = local.df_rg_name
  #resource_group_name = upper(local.rg_name)
}
data "azuread_service_principal" "rbac_storage_blob_data_contributor" {
  #display_name = local.service_principal
  count        = var.service_principal != "" ? 1 : 0
  display_name = var.service_principal
}

module "role_assignment_datalake_container_storage_blob_datacontributor_developers_group" {
  count                = var.ad_developers_group != "" ? 1 : 0
  source               = "../infra/modules/role_assignment"
  scope                = local.dl_container_scope
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = [data.azuread_group.ad_dev[count.index].object_id]
}

module "role_assignment_datalake_container_storage_blob_datacontributor_data_factory" {
  count                = var.data_factory_name != "" ? 1 : 0
  source               = "../infra/modules/role_assignment"
  scope                = local.dl_container_scope
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = [data.azurerm_data_factory.identity_management_rbac[count.index].identity[0].principal_id]
}

module "role_assignment_datalake_container_storage_blob_datacontributor_service_principal" {
  count                = var.service_principal != "" ? 1 : 0
  source               = "../infra/modules/role_assignment"
  scope                = local.dl_container_scope
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = [data.azuread_service_principal.rbac_storage_blob_data_contributor[count.index].object_id]
}

module "role_assignment_datalake_container_storage_blob_data_owner" {
  count                = var.ad_admins_group != "" ? 1 : 0
  source               = "../infra/modules/role_assignment"
  scope                = local.dl_container_scope
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = [data.azuread_group.ad_admins[count.index].object_id]
}