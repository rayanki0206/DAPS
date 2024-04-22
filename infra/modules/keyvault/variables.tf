variable "keyvault_Name" {
  type = string
  description = "name of the keyvault"
}
variable "resource_group_name" {
  type = string
  description = "name of the resource group"
}
variable "location" {
  type =string
  description = "loction/region of the keyvault"
}
variable "appmnemonic" {
  type = string
  description = "4 letter code of the app"
}