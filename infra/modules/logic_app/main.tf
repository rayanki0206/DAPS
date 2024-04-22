
#this creates logic app 
resource "azurerm_logic_app_workflow" "dapp" {
  name                = var.logicapp_name
  resource_group_name = var.logicapp_resource_group_name
  location            = var.logicapp_location
  enabled = true


identity {
  type = "SystemAssigned"
}

    

  
  tags = {
    project = var.appmnemonic
  }
}
 