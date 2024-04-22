locals {
  databrick-host-url = "https://${data.azurerm_databricks_workspace.dbs-ws.workspace_url}"
}