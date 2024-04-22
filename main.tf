
module "resource_group" {
  source       = "./infra/modules/resource_group"
  #daps_RG_Name = local.resourcegroup
  resource_group_name = upper(local.rg_name)
  location     = var.location

}
module "blob_storage" {
  source              = "./infra/modules/blob_storage"
  storageaccount_Name = local.storageaccount
  resource_group_name = module.resource_group.name
  location            = var.location
  depends_on          = [module.resource_group]
}
module "key_vault" {
  source              = "./infra/modules/key_vault"
  keyvault_Name       = local.keyvault
  location            = var.location
  resource_group_name = module.resource_group.name
  depends_on          = [module.resource_group]
}
module "app_insights" {
  source              = "./infra/modules/app_insights"
  app_insights_Name   = local.application_insights
  resource_group_name = module.resource_group.name
  location            = var.location
  depends_on          = [module.resource_group]
}
############################



##################################################################################

##################################################################################
module "ad_groups" {
  source       = "./infra/modules/ad_groups"
  admin_member = var.admin_member
  dev_member   = var.dev_member
  ad_dev       = local.ad_developers_group
  ad_admins    = local.ad_admins_group
}

#creating az_ad_dev and az_ad_admin_groups 
module "az_ad_groups" {
  source       = "./infra/modules/az_ad_groups"
  az_ad_dev    = local.az_ad_developers_group
  az_ad_admins = local.az_ad_admins_group
  ad_dev       = local.ad_developers_group
  ad_admins    = local.ad_admins_group
  depends_on   = [module.ad_groups]
}

############################


#used in role assignment for scope(resource group id)
data "azurerm_resource_group" "dapp" {
  name       = module.resource_group.resource_group_name
  depends_on = [module.resource_group]
}
#gives az_ad_dev_group object id
data "azuread_group" "az_ad_dev" {
  display_name = local.az_ad_developers_group
  depends_on   = [module.az_ad_groups]
}

#IAM role assignments for az_ad_dev_group in resource group
resource "azurerm_role_assignment" "az_ad_dev_reader_contributor" {
  scope                = data.azurerm_resource_group.dapp.id
  role_definition_name = upper(var.environment) == "PROD" ? "Reader" : "Contributor"
  principal_id         = data.azuread_group.az_ad_dev.object_id
}
#IAM Role assignments for the az_ad_dev_group in resource group
resource "azurerm_role_assignment" "az_ad_dev_storage_blob_data_contributor" {
  scope                = data.azurerm_resource_group.dapp.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azuread_group.az_ad_dev.object_id
}
#IAM Role assignments for the az_ad_dev_group in resource group
resource "azurerm_role_assignment" "az_ad_dev_data_factory_contributor" {
  scope                = data.azurerm_resource_group.dapp.id
  role_definition_name = "Data Factory Contributor"
  principal_id         = data.azuread_group.az_ad_dev.object_id
}
#gives az_ad_admins_group object id
data "azuread_group" "az_ad_admins" {
  display_name = local.az_ad_admins_group
  depends_on   = [module.az_ad_groups]
}
#IAM Role assignment for the az_ad_admins_group in resource group
resource "azurerm_role_assignment" "az_ad_admins_contributor" {
  scope                = data.azurerm_resource_group.dapp.id
  role_definition_name = "Contributor"
  principal_id         = data.azuread_group.az_ad_admins.object_id
}
#IAM Role assignments for the az_ad_admins_group in resource group
resource "azurerm_role_assignment" "az_ad_admins_storage_blob_data_owner" {
  scope                = data.azurerm_resource_group.dapp.id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = data.azuread_group.az_ad_admins.object_id
}
#IAM Role assignments for the ad_groups in resource group
resource "azurerm_role_assignment" "az_ad_admins_data_factory_contributor" {
  scope                = data.azurerm_resource_group.dapp.id
  role_definition_name = "Data Factory Contributor"
  principal_id         = data.azuread_group.az_ad_admins.object_id
}

#creates keyvault
module "keyvault" {
  source              = "./infra/modules/keyvault"
  keyvault_Name       = local.kv_name
  resource_group_name = module.resource_group.resource_group_name
  location            = var.location
  appmnemonic         = var.appmnemonic
  depends_on          = [module.resource_group]
}

#gives object id and tenant id that are used in keyvault
data "azurerm_client_config" "daps" {

}


# add current Terraform user to Keyvault 
#this gives key vault access policy for admin group
resource "azurerm_key_vault_access_policy" "tfadmin" {
  key_vault_id = module.keyvault.key_vault_id
  tenant_id    = data.azurerm_client_config.daps.tenant_id
  object_id    = data.azurerm_client_config.daps.object_id

  key_permissions = [
    "Purge", "Backup", "Create", "Decrypt", "Delete", "Encrypt", "Get", "Import", "List", "Recover", "Restore", "Sign", "UnwrapKey", "Update", "Verify", "WrapKey", "Release", "Rotate", "GetRotationPolicy", "SetRotationPolicy"
  ]

  secret_permissions = [
    "Purge", "Get", "Backup", "Delete", "List", "Recover", "Restore", "Set"
  ]

  certificate_permissions = [
    "Purge", "Backup", "Create", "Delete", "DeleteIssuers", "Get", "GetIssuers", "Import", "List", "ListIssuers", "ManageContacts", "ManageIssuers", "Purge", "Recover", "Restore", "SetIssuers", "Update"
  ]

  depends_on = [module.keyvault]
}



#this gives key vault access policy (except purge) for dev group
resource "azurerm_key_vault_access_policy" "dapp" {
  key_vault_id = module.keyvault.key_vault_id
  tenant_id    = data.azurerm_client_config.daps.tenant_id
  object_id    = data.azuread_group.az_ad_dev.object_id

  key_permissions = [
    "Backup", "Create", "Decrypt", "Delete", "Encrypt", "Get", "Import", "List", "Recover", "Restore", "Sign", "UnwrapKey", "Update", "Verify", "WrapKey", "Release", "Rotate", "GetRotationPolicy", "SetRotationPolicy"
  ]

  secret_permissions = [
    "Get", "Backup", "Delete", "List", "Recover", "Restore", "Set"
  ]

  certificate_permissions = [
    "Backup", "Create", "Delete", "DeleteIssuers", "Get", "GetIssuers", "Import", "List", "ListIssuers", "ManageContacts", "ManageIssuers", "Recover", "Restore", "SetIssuers", "Update"
  ]
  depends_on = [module.keyvault, azurerm_key_vault_access_policy.tfadmin]
}
#this gives key vault access policy for admin group
resource "azurerm_key_vault_access_policy" "admins_access" {
  key_vault_id = module.keyvault.key_vault_id
  tenant_id    = data.azurerm_client_config.daps.tenant_id
  object_id    = data.azuread_group.az_ad_admins.object_id

  key_permissions = [
    "Purge", "Backup", "Create", "Decrypt", "Delete", "Encrypt", "Get", "Import", "List", "Recover", "Restore", "Sign", "UnwrapKey", "Update", "Verify", "WrapKey", "Release", "Rotate", "GetRotationPolicy", "SetRotationPolicy"
  ]

  secret_permissions = [
    "Purge", "Get", "Backup", "Delete", "List", "Recover", "Restore", "Set"
  ]

  certificate_permissions = [
    "Purge", "Backup", "Create", "Delete", "DeleteIssuers", "Get", "GetIssuers", "Import", "List", "ListIssuers", "ManageContacts", "ManageIssuers", "Purge", "Recover", "Restore", "SetIssuers", "Update"
  ]
  depends_on = [module.keyvault, azurerm_key_vault_access_policy.tfadmin]
}

#creates datafactory and system assigned identity enabled
module "datafactory" {
  source                = "./infra/modules/datafactory"
  datafactory_name      = local.df_name
  adf_resourcegroupname = module.resource_group.resource_group_name
  location              = var.location
  tag_projectName       = "Service Management"
  depends_on            = [module.resource_group]
}

#creates logic app and system assigned identity enabled
module "logic_app" {
  source                       = "./infra/modules/logic_app"
  logicapp_name                = local.la_name
  logicapp_location            = var.location
  logicapp_resource_group_name = module.resource_group.resource_group_name
  appmnemonic                  = local.app
  depends_on                   = [module.resource_group]
}

###################################
# Add Managed identities of Logic App and ADF

module "az_ad_add_managedIdentity_group" {
  source    = "./infra/modules/az_ad_add_managedIdentity_group"
  GroupName = local.az_ad_developers_group
  managedIdentitys_id = [
    "${module.datafactory.datafactory_managedIdentityObjectId}",
    "${module.logic_app.logic_app_identity}",
    "${module.spn.spn_object_id}",
    "${module.ad_svc_user.svc_user_objectid}"
  ]
  depends_on = [module.az_ad_groups, module.spn, module.ad_svc_user, module.logic_app, module.datafactory]
}
###################################


module "spn" {
  source                 = "./infra/modules/spn"
  service_principal_name = local.service_principal
}


resource "azurerm_key_vault_secret" "dapp" {
  name         = "ServicePrincipal-ClientSecret"
  content_type = lower("ClientSecret-${local.service_principal}")
  value        = module.spn.spn_secret_value
  key_vault_id = module.keyvault.key_vault_id
  depends_on   = [module.keyvault, azurerm_key_vault_access_policy.tfadmin, module.spn, azurerm_key_vault_access_policy.spn_access_policy]
}

#spn key vault access policy
resource "azurerm_key_vault_access_policy" "spn_access_policy" {
  key_vault_id       = module.keyvault.key_vault_id
  tenant_id          = data.azurerm_client_config.daps.tenant_id
  object_id          = module.spn.spn_object_id
  secret_permissions = ["Purge", "Get", "Backup", "Delete", "List", "Recover", "Restore", "Set"]
  depends_on         = [azurerm_key_vault_access_policy.tfadmin, module.keyvault, module.spn]
}

# ####    add spn to group
# module "add_spn_ad_group" {
#   source              = "./infra/modules/az_ad_add_managedIdentity_group"
#   GroupName           = local.az_ad_developers_group
#   managedIdentitys_id = ["${module.spn.spn_object_id}"]
#   depends_on          = [module.az_ad_groups]
# }

### create and ADd SVC

module "ad_svc_user" {
  source       = "./infra/modules/ad_svc_user"
  SVC-UserName = local.service_account_name
}


resource "azurerm_key_vault_secret" "savesvcpwdtokv" {
  name         = "ServiceAccount-password"
  content_type = "Password-${module.ad_svc_user.userupname}"
  value        = module.ad_svc_user.svc_password
  key_vault_id = module.keyvault.key_vault_id
  depends_on   = [module.ad_svc_user, module.keyvault, azurerm_key_vault_access_policy.tfadmin, azurerm_key_vault_access_policy.svc_access_policy]
}
#svc account key vault access policy
resource "azurerm_key_vault_access_policy" "svc_access_policy" {
  key_vault_id       = module.keyvault.key_vault_id
  tenant_id          = data.azurerm_client_config.daps.tenant_id
  object_id          = module.ad_svc_user.svc_user_objectid
  secret_permissions = ["Purge", "Get", "Backup", "Delete", "List", "Recover", "Restore", "Set"]
  depends_on         = [module.keyvault, module.ad_svc_user, azurerm_key_vault_access_policy.tfadmin]
}
## Datacontainer block

module "datalakecontainer" {
  source                       = "./infra/modules/datalakecontainer"
  datalake_container_name      = local.dl_container
  datalake_resource_group_name = "BDAZE1IDAPPRG01"
  existing_datalake            = "bdaze1icommdl12"
  datalake_ad_group_dev        = [data.azuread_group.az_ad_dev.display_name]
  datalake_ad_group_admins     = [data.azuread_group.az_ad_admins.display_name]
  depends_on                   = [data.azuread_group.az_ad_dev, data.azuread_group.az_ad_admins]
}


###################################################


# deploys databricks operations as per Dataproduct Spreadsheet

# module "databricks-mgmt" {
#   source = "./infra/modules/databricks-mgmt"
#   # databricksName                   = local.databricks_wspace
#   # databricks_resourceGroupName     = local.dbricks_ws_resourece_group
#   databricksName               = "BDAZE1IDAPPBK01"
#   databricks_resourceGroupName = "BDAZE1IDAPPRG01"
#   databricksFolderName         = local.databricksFolderName
#   dbws-GroupName               = local.databricksFolderName
#   # databricks-group-memebers        = ["harish@rgtechlabsoutlook.onmicrosoft.com","naresh@rgtechlabsoutlook.onmicrosoft.com","SVC-RAHUL@rgtechlabsoutlook.onmicrosoft.com"]
#   databricks-group-memebers = ["harish@rgtechlabsoutlook.onmicrosoft.com", "naresh@rgtechlabsoutlook.onmicrosoft.com", "SVC-RAHUL@rgtechlabsoutlook.onmicrosoft.com"]

#   default-databricks-groups        = ["cluster -General 01", "cluster -General 02"]
#   ServiceAccountuserName           = local.svc_account_email
#   svc-token-keyvaultName           = "BDAZE1IDAPPKV01" #local.dbricks_key_vault
#   svc-token-keyvault_ResourceGroup = "BDAZE1IDAPPRG01" #local.dbricks_key_vault_resource_group
#   secretScopeName                  = "AKV-${local.app}"
#   secretACLScope                   = "MANAGE"
# }
 
################################################################
## Below code is without databricks without module
#################################################################

# deploys databricks operations as per Dataproduct Spreadsheet
data "azurerm_databricks_workspace" "dbs-ws" {
  name                = "BDAZE1IDAPPBK01"
  resource_group_name = "BDAZE1IDAPPRG01"
}

# # add databricks users
# resource "databricks_user" "dbs-user" {
#   provider   = databricks.azure_account
#   count      = length(local.databricks_users)
#   user_name  = local.databricks_users[count.index]
#   depends_on = [data.azurerm_databricks_workspace.dbs-ws]
# }

# # Create databricks Group
# resource "databricks_group" "dbs-groupname" {
#   provider                   = databricks.azure_account
#   display_name               = local.databricksFolderName
#   allow_cluster_create       = true
#   allow_instance_pool_create = true
#   depends_on                 = [data.azurerm_databricks_workspace.dbs-ws]
# }

# data "databricks_group" "dbs-functionalgroup" {
#   provider     = databricks.azure_account
#   display_name = local.databricksFolderName
#   depends_on   = [databricks_group.dbs-groupname]
# }

# # Get the existing users in dbs workspace.
# data "databricks_user" "getdbsusers" {
#   provider   = databricks.azure_account
#   count      = length(local.databricks_users)
#   user_name  = local.databricks_users[count.index]
#   depends_on = [databricks_user.dbs-user]
# }

# # Add group members to above created group.
# resource "databricks_group_member" "dbs_groupmembers" {
#   provider = databricks.azure_account
#   for_each = { for key, val in data.databricks_user.getdbsusers :
#   key => val }
#   group_id   = databricks_group.dbs-groupname.id
#   member_id  = data.databricks_user.getdbsusers[each.key].id
#   depends_on = [data.databricks_user.getdbsusers]
# }


# # Add the DBS Group to the main cluster Groups

# # get the clustergroups 01  and 02 id's
# data "databricks_group" "clustergroups" {
#   provider = databricks.azure_account
#   #   count = length(var.default-databricks-groups)
#   # for_each = var.default-databricks-groups
#   count        = length(local.databricks_clsuter_groups)
#   display_name = local.databricks_clsuter_groups[count.index]
# }

# # Add group members to above created group.
# resource "databricks_group_member" "dbs_defaultgroupmembers" {
#   provider = databricks.azure_account
#   for_each = { for key, val in data.databricks_group.clustergroups :
#   key => val }
#   group_id   = data.databricks_group.clustergroups[each.key].id
#   member_id  = data.databricks_group.dbs-functionalgroup.id
#   depends_on = [databricks_group.dbs-groupname]
# }

# # Create Folder in databricks
# resource "databricks_directory" "my_custom_directory" {
#   provider = databricks.azure_account
#   path     = "/${local.databricksFolderName}"

# }

# # Manage Folder permissions for the group.

# resource "databricks_permissions" "folder_usage" {
#   provider       = databricks.azure_account
#   directory_path = databricks_directory.my_custom_directory.path
#   depends_on     = [databricks_directory.my_custom_directory, databricks_group.dbs-groupname]

#   access_control {
#     group_name       = "users"
#     permission_level = "CAN_READ"
#   }

#   access_control {
#     group_name       = databricks_group.dbs-groupname.display_name
#     permission_level = "CAN_MANAGE"
#   }
# }

# ####  Get the User Token for the ServiceAccount

# # get the service Account User
# data "databricks_user" "svcuser" {
#   provider   = databricks.azure_account
#   user_name  = local.svc_account_email
#   depends_on = [databricks_user.dbs-user]
# }
# ######################  comment this Managed SVC Account as Service Principle
# # Register SVC as Service Principle Account
# # resource "databricks_service_principal" "sp" {
# #   provider       = databricks.azure_account
# #   # application_id = data.databricks_user.svcuser.application_id
# #     application_id = "b226a429-86fe-4955-8b93-a198b67d0831"
# #   depends_on = [ data.databricks_user.svcuser ]
# # }

# # # Get existing admin groups
# # data "databricks_group" "admins" {
# #   display_name = "admins"
# #   depends_on = [ databricks_user.dbs-user ]
# # }

# # resource "databricks_group_member" "svctoadmins" {
# #   group_id  = data.databricks_group.admins.id
# #   member_id = databricks_service_principal.sp.id
# #   depends_on = [ databricks_service_principal.sp, data.databricks_group.admins ]
# # }

# # # Create token for SVC Account.
# # resource "databricks_obo_token" "svcusertoken" {
# #      provider     = databricks.azure_account
# #   application_id = databricks_service_principal.sp.application_id
# #   comment =  "PAT Token of ${var.ServiceAccountuserName}"
# #   lifetime_seconds = 3600000
# #   depends_on = [ data.databricks_user.svcuser,databricks_group_member.svctoadmins ]
# # }
# ######################## comment till here

# #gives object id and tenant id that are used in keyvault
# data "azurerm_client_config" "dbstfadmin" {

# }

# ## Add the Seceret to KeyValut
# data "azurerm_key_vault" "svckeyvault" {
#   # name = var.svc-token-keyvaultName
#   # resource_group_name = var.svc-token-keyvault_ResourceGroup
#   name                = local.kv_name
#   resource_group_name = local.rg_name
#   depends_on          = [module.keyvault, azurerm_key_vault_access_policy.tfadmin]
# }

# ################### cooment this
# # resource "azurerm_key_vault_secret" "svctoken_kv" {
# #   name         = "ServiceAccount-ADBUserToken"
# #   content_type = "Databricks User Token - ${var.ServiceAccountuserName}"
# #   value        = databricks_obo_token.svcusertoken.token_value
# #   key_vault_id = data.azurerm_key_vault.svckeyvault.id
# #   depends_on = [ data.azurerm_key_vault.svckeyvault ]
# # }
# ################### cooment here

# #### Create Secret Scope
# resource "databricks_secret_scope" "secretscope_kv" {
#   provider                 = databricks.azure_account
#   name                     = "AKV-${local.app}"
#   initial_manage_principal = "users"

#   keyvault_metadata {
#     resource_id = data.azurerm_key_vault.svckeyvault.id
#     dns_name    = data.azurerm_key_vault.svckeyvault.vault_uri
#   }
#   depends_on = [data.azurerm_key_vault.svckeyvault]
# }

# # Create databricks acl
# resource "databricks_secret_acl" "secret_acl" {
#   provider   = databricks.azure_account
#   principal  = databricks_group.dbs-groupname.display_name
#   permission = "MANAGE"
#   scope      = databricks_secret_scope.secretscope_kv.name
#   # depends_on = [ azurerm_key_vault_secret.svctoken_kv, databricks_secret_scope.secretscope_kv ]
#   depends_on = [databricks_secret_scope.secretscope_kv]

# }
 
