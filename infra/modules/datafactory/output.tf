output "datafactoryname" {
    value = azurerm_data_factory.datafactory.name
}
output "datafactory_managedIdentityName" {
  value = azurerm_data_factory.datafactory.name
}
output "datafactory_managedIdentityObjectId" {
  value = azurerm_data_factory.datafactory.identity[0].principal_id
}
output "datafactory_managedIdentityAzGroupName" {
  value = "DEVELOPERS"
}