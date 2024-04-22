data "azuread_client_config" "spn_cli_config" {
  
}


resource "azuread_application" "spn" {
  display_name = var.service_principal_name
}
resource "azuread_application_password" "spn_pwd" {
  application_id = azuread_application.spn.id
  depends_on = [ azuread_application.spn ]
}
resource "azuread_service_principal" "spn_ref" {
  client_id = azuread_application.spn.client_id
  owners = [data.azuread_client_config.spn_cli_config.object_id]
  depends_on = [ azuread_application.spn,azuread_application_password.spn_pwd ]
}
resource "azuread_service_principal_password" "az_spn_pwd" {
  service_principal_id = azuread_service_principal.spn_ref.object_id
  depends_on = [ azuread_service_principal.spn_ref ]
}