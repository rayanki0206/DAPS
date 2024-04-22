variable "subscription_id" {
  type = string
  description = "subscription id of the keyvault and datafactory resources "
}
variable "ad_admins_group" {
  type = string
}
variable "ad_developers_group" {
  type = string
}
variable "datafactory" {
  type = string
}
variable "keyvault" {
  type = string
}
variable "service_principal" {
  type = string
}
variable "databricks_workspace_name" {
  type = string
}
variable "existing_datalake" {
  type = string
}
variable "databricks_account_id" {
  type = string
}
variable "appmnemonic" {
  type = string
}
variable "environment" {
  type = string
}
variable "functional_area" {
  type = string
}
variable "data_product_name" {
  type = string
}
