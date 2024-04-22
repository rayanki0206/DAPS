terraform {
  required_providers {
    databricks = {
      source = "databricks/databricks"
      version = "1.0.1"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 1.0.0"
    }
  }
}
 
provider "azurerm" {
  skip_provider_registration = true
  features {
 
    key_vault {
      purge_soft_delete_on_destroy = true
      #   recover_soft_deleted_key_vaults = true
    }
  }
}
 
# provider "databricks" {
#   alias      = "azure_account"
#   host       = var.databrick-host-url#"https://adb-5169432361175602.2.azuredatabricks.net"
#   account_id = var.databrick-account_id#"5169432361175602"
#   auth_type  = "azure-cli"
# }
 
provider "databricks" {
  alias      = "azure_account"
  host       = data.azurerm_databricks_workspace.dbs-ws.workspace_url
  azure_workspace_resource_id = data.azurerm_databricks_workspace.dbs-ws.id
  # account_id = data.azurerm_databricks_workspace.dbs-ws.id
  # auth_type  = "azure-cli"
  # ARM_USE_MSI environment variable is recommended
  azure_use_msi = true
}
 