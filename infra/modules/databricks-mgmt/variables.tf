variable "databricks_resourceGroupName" {
  type = string
  description = "Name of the databricks Resource Group Name"
}
 
variable "databricksName" {
  type = string
  description = "Name of the databricks"
}
 
variable "databricksFolderName" {
  type = string
  description = "Name of the databrick folder"
}
 
variable "dbws-GroupName" {
  type = string
  description = "databricks group Name"
}
 
variable "ServiceAccountuserName" {
  type = string
  description = "Service Account User email id"
}
 
variable "default-databricks-groups" {
  type = list(string)
  description = "default databricks groups"
  default = [ " Cluster - General 01", " Cluster - General 02" ]
}
variable "databricks-group-memebers" {
    type = list(string)
  description = "databricks groups members"
  default = [ "scott.h.huston@elancoah.com", "SNEH_KUMAR.GAUR@elancoah.com" ]
}
 
 
variable "svc-token-keyvaultName" {
  type = string
  description = "keyvalut Name to save service account user accesstoken"
}
 
variable "svc-token-keyvault_ResourceGroup" {
  type = string
  description = "keyvalut ResourceGroup to save service account user accesstoken"
}
 
variable "secretScopeName" {
  type = string
  description = "secret scope name"
}
variable "secretACLScope" {
  type = string
  description = "Secret ACL scope"
}