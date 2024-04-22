#gets client configuration details
data "azuread_client_config" "dapp" {}


resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$*()-_+[]{}<>:?"
}


resource "azuread_user" "ad_svc_user" {
  
  user_principal_name = lower("${var.SVC-UserName}@rgtechlabsoutlook.onmicrosoft.com")
  display_name        = var.SVC-UserName
  mail_nickname       = var.SVC-UserName
  password            = random_password.password.result
}