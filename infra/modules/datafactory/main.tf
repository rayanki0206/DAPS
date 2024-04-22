resource "azurerm_data_factory" "datafactory" {
  name                = var.datafactory_name
  location            = var.location
  resource_group_name = var.adf_resourcegroupname
  managed_virtual_network_enabled = var.enable_Managed_VNET
  
  public_network_enabled = var.enable_publicNework
  
  identity {
    type = "SystemAssigned"
  }
  
  tags = {
    Project= var.tag_projectName
  }
  }


 