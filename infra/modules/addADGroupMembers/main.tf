# get users from azure ad.

data "azuread_user" "adusers" { 
  for_each = var.users
    user_principal_name = each.value.email
}
# Get exsitng AD Group
data "azuread_group" "existingazadgroup" {
  display_name = var.adgroupName
}


# Add members to AD Group.
resource "azuread_group_member" "addusertogroup" {
  
  for_each = { for key, val in data.azuread_user.adusers :
  	key => val if val.user_type == "Member" }
  group_object_id  = azuread_group.existingazadgroup.id
  member_object_id = data.azuread_user.adusers[each.key].id
}

# Add Guest to AD Group.
resource "azuread_group_member" "addusertogroup" {
  for_each = { for key, val in data.azuread_user.adusers :
  	key => val if val.user_type == "Guest" }
  group_object_id  = azuread_group.existingazadgroup.id
  member_object_id = data.azuread_user.adusers[each.key].idd
}



# memberADGroupName
data "azuread_group" "memberexistingazadgroup" {
  count = var.memberAdGroup ? 1 :0
  display_name = var.memberAdGroup
}

# Add another ad group as member to ad group
resource "azuread_group_member" "addgrouptoadgroup" {
  count = var.memberAdGroup ? 1 :0
  group_object_id = azuread_group.existingazadgroup.id
  member_object_id = azuread_group_member.addusertogroup.group_object_id
}

# add managedIdentity or SPN using ObjectId / PrincipalId 
resource "azuread_group_member" "addidentitytogroup" {
  count = var.identityid ? 1 :0
  group_object_id = azuread_group.existingazadgroup.id
  member_object_id = var.identityid
}
