#this block provides datalake information
data "azurerm_storage_account" "dapp" {
  name = var.existing_datalake
  resource_group_name = var.datalake_resource_group_name
}
data "azurerm_subscription" "dapp" {
  
}


#creates datalake container
#"aquire lease" needs to be enabled 
resource "azurerm_storage_container" "dapp" {
  name                  = var.datalake_container_name
  storage_account_name  = data.azurerm_storage_account.dapp.name
  container_access_type = "private"
  #has_legal_hold = true

}


# data "azuread_group" "datalake_ad_group_admins" {
#   for_each = toset(var.datalake_ad_group_admins)
#   display_name = each.value
# }


# resource "azurerm_role_assignment" "datalake_admins" {
 
#   scope                = "/subscriptions/${data.azurerm_subscription.dapp.subscription_id}/resourceGroups/${var.datalake_resource_group_name}/providers/Microsoft.Storage/storageAccounts/${var.existing_datalake}/blobServices/default/containers/${var.datalake_container_name}"
#   role_definition_name = "Storage Blob Data Owner"
#   for_each = toset(var.datalake_ad_group_admins)
#    principal_id         = data.azuread_group.datalake_ad_group_admins[each.key].object_id
# }
# data "azuread_group" "datalake_ad_group_dev" {
#   for_each = toset(var.datalake_ad_group_dev)
#   display_name = each.value
# }
# resource "azurerm_role_assignment" "datalake_dev" {

#   scope                = "/subscriptions/${data.azurerm_subscription.dapp.subscription_id}/resourceGroups/${var.datalake_resource_group_name}/providers/Microsoft.Storage/storageAccounts/${var.existing_datalake}/blobServices/default/containers/${var.datalake_container_name}"
#   role_definition_name = "Storage Blob Data Contributor"
#   for_each = toset(var.datalake_ad_group_dev)
#    principal_id         = data.azuread_group.datalake_ad_group_dev[each.key].object_id
# }