output "svc_password" {
  value = random_password.password.result
  sensitive = true
}
output "userupname" {
  value = azuread_user.ad_svc_user.user_principal_name
}  
output "svc_user_objectid" {
  value = azuread_user.ad_svc_user.object_id
}