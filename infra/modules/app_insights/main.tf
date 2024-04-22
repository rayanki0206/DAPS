
resource "azurerm_application_insights" "daps" {
  name                = var.app_insights_Name
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = "other"
}

