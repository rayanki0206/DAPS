# deploys databricks operations as per Dataproduct Spreadsheet
data "azurerm_databricks_workspace" "dbs-ws" {
  name                = var.databricksName
  resource_group_name = var.databricks_resourceGroupName
}
 
# add databricks users
resource "databricks_user" "dbs-user" {
  provider = databricks.azure_account  
  count = length(var.databricks-group-memebers)  
  user_name = "${var.databricks-group-memebers[count.index]}"
  depends_on = [ data.azurerm_databricks_workspace.dbs-ws ]
}
 
# Create databricks Group
resource "databricks_group" "dbs-groupname" {
  provider     = databricks.azure_account
  display_name = var.dbws-GroupName
    allow_cluster_create       = true
  allow_instance_pool_create = true
  depends_on = [ data.azurerm_databricks_workspace.dbs-ws ]
}
 
data "databricks_group" "dbs-functionalgroup" {
   provider     = databricks.azure_account
  display_name = var.dbws-GroupName
  depends_on = [ databricks_group.dbs-groupname ]
}
 
# Get the existing users in dbs workspace.
data "databricks_user" "getdbsusers" {
  provider = databricks.azure_account  
  count = length(var.databricks-group-memebers)  
  user_name = "${var.databricks-group-memebers[count.index]}"
  depends_on = [ databricks_user.dbs-user ]
}
 
# Add group members to above created group.
resource "databricks_group_member" "dbs_groupmembers" {
    provider     = databricks.azure_account
  for_each = { for key, val in data.databricks_user.getdbsusers :
    key => val }
  group_id  = databricks_group.dbs-groupname.id
  member_id = data.databricks_user.getdbsusers[each.key].id
  depends_on = [ data.databricks_user.getdbsusers ]
}
 
 
# Add the DBS Group to the main cluster Groups
 
# get the clustergroups 01  and 02 id's
data "databricks_group" "clustergroups" {
   provider     = databricks.azure_account
#   count = length(var.default-databricks-groups)
  # for_each = var.default-databricks-groups
  count = length(var.default-databricks-groups)  
  display_name = "${var.default-databricks-groups[count.index]}"
}
 
# Add group members to above created group.
resource "databricks_group_member" "dbs_defaultgroupmembers" {
     provider     = databricks.azure_account
  for_each = { for key, val in data.databricks_group.clustergroups :
    key => val }
  group_id  = data.databricks_group.clustergroups[each.key].id
  member_id = data.databricks_group.dbs-functionalgroup.id
  depends_on = [ databricks_group.dbs-groupname ]
}
 
# Create Folder in databricks
resource "databricks_directory" "my_custom_directory" {
   provider     = databricks.azure_account
  path = "/${var.databricksFolderName}"
 
}
 
# Manage Folder permissions for the group.
 
resource "databricks_permissions" "folder_usage" {
     provider     = databricks.azure_account
  directory_path = databricks_directory.my_custom_directory.path
  depends_on     = [databricks_directory.my_custom_directory, databricks_group.dbs-groupname]
 
  access_control {
    group_name       = "users"
    permission_level = "CAN_READ"
  }
 
  access_control {
    group_name       = databricks_group.dbs-groupname.display_name
    permission_level = "CAN_MANAGE"
  }
}
 
####  Get the User Token for the ServiceAccount
 
# get the service Account User
data "databricks_user" "svcuser" {
    provider     = databricks.azure_account
    user_name = var.ServiceAccountuserName
    depends_on = [ databricks_user.dbs-user ]
}
###################### Managed SVC Account as Service Principle
# Register SVC as Service Principle Account
# resource "databricks_service_principal" "sp" {
#   provider       = databricks.azure_account
#   # application_id = data.databricks_user.svcuser.application_id
#     application_id = "b226a429-86fe-4955-8b93-a198b67d0831"
#   depends_on = [ data.databricks_user.svcuser ]
# }
 
# # Get existing admin groups
# data "databricks_group" "admins" {
#   display_name = "admins"
#   depends_on = [ databricks_user.dbs-user ]
# }
 
# resource "databricks_group_member" "svctoadmins" {
#   group_id  = data.databricks_group.admins.id
#   member_id = databricks_service_principal.sp.id
#   depends_on = [ databricks_service_principal.sp, data.databricks_group.admins ]
# }
 
# # Create token for SVC Account.
# resource "databricks_obo_token" "svcusertoken" {
#      provider     = databricks.azure_account
#   application_id = databricks_service_principal.sp.application_id
#   comment =  "PAT Token of ${var.ServiceAccountuserName}"
#   lifetime_seconds = 3600000
#   depends_on = [ data.databricks_user.svcuser,databricks_group_member.svctoadmins ]
# }
 
 
#gives object id and tenant id that are used in keyvault
data "azurerm_client_config" "dbstfadmin" {
 
}
 
## Add the Seceret to KeyValut
data "azurerm_key_vault" "svckeyvault" {
  name = var.svc-token-keyvaultName
  resource_group_name = var.svc-token-keyvault_ResourceGroup
}
 
 
# # add current Terraform user to Keyvault
# #this gives key vault access policy for admin group
# resource "azurerm_key_vault_access_policy" "dbstfadminkv" {
#   key_vault_id = data.azurerm_key_vault.svckeyvault.id
#   tenant_id    = data.azurerm_client_config.dbstfadmin.tenant_id
#   object_id    = data.azurerm_client_config.dbstfadmin.object_id
 
#   key_permissions = [
#     "Purge", "Backup", "Create", "Decrypt", "Delete", "Encrypt", "Get", "Import", "List", "Recover", "Restore", "Sign", "UnwrapKey", "Update", "Verify", "WrapKey", "Release", "Rotate", "GetRotationPolicy", "SetRotationPolicy"
#   ]
 
#   secret_permissions = [
#     "Purge", "Get", "Backup", "Delete", "List", "Recover", "Restore", "Set"
#   ]
 
#   certificate_permissions = [
#     "Purge", "Backup", "Create", "Delete", "DeleteIssuers", "Get", "GetIssuers", "Import", "List", "ListIssuers", "ManageContacts", "ManageIssuers", "Purge", "Recover", "Restore", "SetIssuers", "Update"
#   ]
 
#   depends_on = [ data.azurerm_key_vault.svckeyvault ]
# }
 
 
 
 
 
 
# resource "azurerm_key_vault_secret" "svctoken_kv" {
#   name         = "ServiceAccount-ADBUserToken"
#   content_type = "Databricks User Token - ${var.ServiceAccountuserName}"
#   value        = databricks_obo_token.svcusertoken.token_value
#   key_vault_id = data.azurerm_key_vault.svckeyvault.id
#   depends_on = [ data.azurerm_key_vault.svckeyvault ]
# }
 
#### Create Secret Scope
resource "databricks_secret_scope" "secretscope_kv" {
  provider     = databricks.azure_account
  name = var.secretScopeName
  initial_manage_principal = "users"
 
  keyvault_metadata {
    resource_id = data.azurerm_key_vault.svckeyvault.id
    dns_name    = data.azurerm_key_vault.svckeyvault.vault_uri
  }
  depends_on = [ data.azurerm_key_vault.svckeyvault ]
}
 
# Create databricks acl
resource "databricks_secret_acl" "secret_acl" {
  provider     = databricks.azure_account
  principal  = databricks_group.dbs-groupname.display_name
  permission = "MANAGE"
  scope      = databricks_secret_scope.secretscope_kv.name
  # depends_on = [ azurerm_key_vault_secret.svctoken_kv, databricks_secret_scope.secretscope_kv ]
  depends_on = [ databricks_secret_scope.secretscope_kv ]
 
}
 