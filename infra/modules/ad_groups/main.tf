#gets client configuration details
data "azuread_client_config" "dapp" {}


#gets user information
data "azuread_user" "admins" {
    user_principal_name = var.admin_member #["harish@rgtechlabsoutlook.onmicrosoft.com"]
}
data "azuread_user" "dev" {
    user_principal_name = var.dev_member #["rakesh@rgtechlabsoutlook.onmicrosoft.com"]
}


# required application roles if authenticated with spn: Group.ReadWrite.All or Directory.ReadWrite.All(Group.Create.)
resource "azuread_group" "ad_admins" {
  display_name     = var.ad_admins
  security_enabled = true
    members = [ data.azuread_user.admins.object_id 
]
}

# #modify in the main file to get dev group
# data "azurerm_logic_app_workflow" "dapp" {
#   name = var.logicapp_name
#   #name                = "BDAZE1IdappLA01"
#  resource_group_name = var.logicapp_resource_group_name
#   #resource_group_name = "BDAZE1IDAPPRG01"
# }
resource "azuread_group" "ad_dev" {
  display_name     = var.ad_dev
  security_enabled = true
members = [
    data.azuread_user.dev.object_id
]
}