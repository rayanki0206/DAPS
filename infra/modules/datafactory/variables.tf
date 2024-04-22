variable "adf_resourcegroupname" {
  type = string
  description = "name of the resource group"
}
variable "location" {
  type = string
  description = "location of the resources"
}
variable "datafactory_name" {
    type = string
  description = "logic app name"
}
variable "enable_Managed_VNET" {
  type = bool
  description = "enable managed virtual network"
  default = false
}
variable "enable_publicNework" {
  type = bool
  description = "connect via public endpoint"
  default = true
  }
  variable "tag_projectName" {
    type = string
    description = "data product Name"
  }
  