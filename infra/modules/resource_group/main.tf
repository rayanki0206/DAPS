#creates resource group
resource "azurerm_resource_group" "dapp" {
  name = var.resource_group_name
  location = var.location
}