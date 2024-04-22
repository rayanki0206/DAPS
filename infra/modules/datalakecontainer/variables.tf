variable "datalake_container_name" {
  type = string
  description = "name of the container"
}
variable "datalake_resource_group_name" {
  type = string
  description = "name of the resource group"
}
variable "existing_datalake" {
  description = "existing datalake account name"
  type = string
}
variable "datalake_ad_group_dev" {
  type = list(string)
  default = ["AZ-SEC-NONPROD-GLO-GLSM-DEVELOPERS"]
}
variable "datalake_ad_group_admins" {
  type = list(string)
  default = ["AZ-SEC-NONPROD-GLO-GLSM-ADMINS"]
}
