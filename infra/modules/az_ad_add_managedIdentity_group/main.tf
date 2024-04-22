
data "azuread_client_config" "dapp" {}

# Get the Existing AD group to add Managed Identities
data "azuread_group" "exising_adgroup" {
  display_name = var.GroupName
}

# Add the existing Managed Identities to AD group

resource "azuread_group_member" "addManagedIdentity" {
  group_object_id = data.azuread_group.exising_adgroup.id
  # count = length(var.managedIdentitys_id)  
  # member_object_id = "${var.managedIdentitys_id[count.index]}"
  for_each = { for key, val in var.managedIdentitys_id :
    key => val }
  member_object_id = var.managedIdentitys_id[each.key]


}