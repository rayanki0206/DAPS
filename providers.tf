terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.0.0" # Specify a non-deprecated version
    }
     azuread = {
      source  = "hashicorp/azuread"
      version = ">=1.0.0"
    }
     databricks = {
      source  = "databricks/databricks"
      version = "1.0.1"
    }
  }
  # backend "remote" {
  #   hostname     = "app.terraform.io"
  #   organization = "elanco_animal_health"
  #   workspaces {
  #     name = "dat-daps-dev"
  #   }
  # }
  required_version = ">= 1.0.0"
}

provider "azurerm" {
  skip_provider_registration = true
  features {

    key_vault {
      purge_soft_delete_on_destroy    = true
      #recover_soft_deleted_key_vaults = true
    }
  }

}

provider "random" {
  # Configuration options for the provider (if any)
}
provider "azuread" {
  tenant_id = "df49ebf2-2fd2-44c2-80f8-37058cc147b9"
}
provider "databricks" {
  alias                       = "azure_account"
  host                        = data.azurerm_databricks_workspace.dbs-ws.workspace_url
  azure_workspace_resource_id = data.azurerm_databricks_workspace.dbs-ws.id

  # account_id = data.azurerm_databricks_workspace.dbs-ws.id
  auth_type  = "azure-cli"
  # ARM_USE_MSI environment variable is recommended
  # azure_use_msi = true
}
 