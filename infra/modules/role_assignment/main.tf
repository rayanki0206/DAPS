# creates role assignment
resource "azurerm_role_assignment" "role_assignment" {
  scope                = var.scope#data.azurerm_resource_group.dapp.id
  role_definition_name = var.role_definition_name#"Data Factory Contributor"
   for_each = { for key, val in var.principal_id :
    key => val }
  principal_id         = var.principal_id[each.key]#data.azuread_group.az_ad_admins.object_id
}