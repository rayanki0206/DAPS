#gets client configuration details 
data "azuread_client_config" "dapp" {}

data "azuread_group" "ad_admins" {
  display_name = var.ad_admins
}
data "azuread_group" "ad_dev" {
  display_name = var.ad_dev
}

# required application roles if authenticated with spn: Group.ReadWrite.All or Directory.ReadWrite.All(Group.Create.)
#creates az_ad_admins_group
resource "azuread_group" "az_ad_admins" {
  display_name     = var.az_ad_admins
  security_enabled = true
members = [
    data.azuread_group.ad_admins.object_id
]
}
#creates az_ad_dev_group
resource "azuread_group" "az_ad_dev" {
  display_name     = var.az_ad_dev
  security_enabled = true
members = [
    data.azuread_group.ad_dev.object_id
]

}