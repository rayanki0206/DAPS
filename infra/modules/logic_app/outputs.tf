
output "logic_app_workflow_id" {
  value = azurerm_logic_app_workflow.dapp.id
}
output "logic_app_access_endpoint" {
  value = azurerm_logic_app_workflow.dapp.access_endpoint
}
output "logic_app_identity" {
  value = azurerm_logic_app_workflow.dapp.identity[0].principal_id
}

output "logicApp_Name" {
  value = azurerm_logic_app_workflow.dapp.name
}