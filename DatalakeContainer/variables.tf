# variable "datalake_resource_group_name" {
#   type = string 
# }
variable "existing_datalake" {
  type = string
}
# variable "datalake_container_name" {
#   type = string
# }
variable "appmnemonic" {
  type        = string
  description = "name of the application "
  validation {
    condition     = (length(var.appmnemonic) < 5)
    error_message = "value of appmnemonic should be lessthan 5 charecters"
  }
}
# variable "location" {
#   type        = string
#   description = "location of the resources where they were deployed"
# }
variable "environment" {
  type = string
  #default     = ["dev", "qa", "test", "prod"]
  description = "specifies the environment of the app"
}

variable "functional_area" {
  type        = string
  description = "Elanco Functional area that owns the data product associated with the new data lake container."
}
variable "data_product_name" {
  type        = string
  description = "Name of the data product associated with the new data lake container."
}
variable "ad_admins_group" {
  type        = string
  description = "display name of the Azure AD admins group"
}
variable "ad_developers_group" {
  type        = string
  description = "display name of the Azure AD developers group"
}
variable "data_factory_name" {
  type        = string
  description = "name of the Data Factory resource"
}
variable "subscription_id" {
  type        = string
  description = "subscription id of the data fatory resource "
}
variable "service_principal" {
  type        = string
  description = "display name of the service prinicipal"
}
