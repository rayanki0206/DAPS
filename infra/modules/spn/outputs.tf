output "spn_application_id" {
  value = azuread_application.spn.client_id
}
output "spn_client_id" {
  value = azuread_application.spn.client_id
}
output "spn_object_id" {
  value = azuread_service_principal.spn_ref.object_id
}
output "spn_secret_value" {
  value = azuread_service_principal_password.az_spn_pwd.value
}