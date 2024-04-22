#creates blob storage account
resource "azurerm_storage_account" "daps" {
  name                     = var.storageaccount_Name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "BlobStorage"            

}   