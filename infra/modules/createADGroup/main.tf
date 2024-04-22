# Create Azure AD Group.

data "azuread_user" "groupowner" { 
    user_principal_name = var.groupOnwerEmailid
}

resource "azuread_group" "azadgroup" {
  display_name     = var.adgroupName
  security_enabled = true
  owners           = [data.azuread_user.groupowner.id]
}