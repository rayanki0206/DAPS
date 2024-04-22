terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 1.0.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = ">=1.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 1.0.0" # Specify a non-deprecated version
    }

    # databricks = {
    #   source  = "databricks/databricks"
    #   version = "1.0.1"
    # }
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

provider "azurerm" {
  alias                      = "data_factory"
  skip_provider_registration = true
  subscription_id            = var.subscription_id != "" ? var.subscription_id : var.functional_area == "global services" ? "34f22bc6-135a-4e3f-a2d9-28f2ea2e0607" : var.functional_area == "commercial" ? "0a0bdfa4-f261-493d-b02e-a1c114b4298f" : var.functional_area == "dataops" ? "897caaa4-0ac7-43e3-97b4-b0b57029410d" : var.functional_area == "it" ? "055ac988-501b-4788-9d86-8f43bcbd7ccf" : var.functional_area == "m&q" ? "765b7ef6-0d12-4313-b67f-11e9e85ee0d6" : var.functional_area == "r&d" ? "a357d9b0-e1a1-4278-bf00-8a143f3d5e89" : "3de5bb92-ec90-4c7e-af9b-90c3ed1cae76"
  features {

  }

}


provider "random" {
  # Configuration options for the provider (if any)
}
provider "azuread" {
  tenant_id = "e378272e-61df-4269-b4f4-833c521b7bf9"
}



# provider "databricks" {
#   alias                       = "azure_account"
#   host                        = data.azurerm_databricks_workspace.dbs-ws.workspace_url
#   azure_workspace_resource_id = data.azurerm_databricks_workspace.dbs-ws.id

#   # account_id = data.azurerm_databricks_workspace.dbs-ws.id
#   auth_type  = "azure-cli"
#   # ARM_USE_MSI environment variable is recommended
#   # azure_use_msi = true


#}

 