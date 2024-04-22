# output "internalsqlservername" {
#   value = local.synapse_server
# }
# output "adminsgroupname" {
#   value = local.az_ad_admins_group
# }
# output "developersgroupname" {
#   value = local.az_ad_developers_group
# }
# output "readersgroupname" {
#   value = local.schema_readers_group
# }
# output "databasename" {
#   value = local.synapse_db
# }
# output "readerrolename" {
#   value = local.schema_reader_role
# }
# output "datawriterrolename" {
#   value = local.schema_writer_role
# }
# output "developerrolename" {
#   value = local.schema_developer_role
# }
# output "ownerRoleName" {
#   value = local.schema_owner_role
# }
# output "schemaName" {
#   value = local.schema
# }
# output "membername" {
#   value = local.ddl_admin_membername
# }
# output "appshortcodename" {
#   value = local.app
# }
# output "spnclientid" {
#   value = module.spn.spn_client_id
# }
# output "spnclientsecret" {
#   value = module.spn.spn_secret_value
#   sensitive = true
# }
# output "datalakename" {
#   value = module.datalakecontainer.datalake_name
# }
# output "datalakecontainername" {
#   value = module.datalakecontainer.container_name
# }
# #############################################################################################################
# output "app" {
#   value = local.app
# }

##############################################################################################################
#outputs of ad_group
# output "ad_admins_group_object_id" {
#   value = module.ad_groups.ad_admins_group_object_id
# }
# output "ad_dev_group_object_id" {
#   value = module.ad_groups.ad_dev_group_object_id
# }

# #outputs of az_ad_groups
# output "az_ad_admins_object_id" {
#   value = module.az_ad_groups.az_ad_admins_object_id
# }
# output "az_ad_dev_object_id" {
#   value = module.az_ad_groups.az_ad_dev_object_id
# }

#outputs of datafactory
# output "datafactoryname" {
#   value = module.datafactory.datafactoryname
# }
# output "datafactory_managedIdentityName" {
#   value = module.datafactory.datafactory_managedIdentityName
# }
# output "datafactory_managedIdentityObjectId" {
#   value = module.datafactory.datafactory_managedIdentityObjectId
# }
# output "datafactory_managedIdentityAzGroupName" {
#   value = module.datafactory.datafactory_managedIdentityAzGroupName
# }

# #outputs of ad_svc_user
# output "svc_password" {
#   value     = module.ad_svc_user.svc_password
#   sensitive = true
# }
# output "userupname" {
#   value = module.ad_svc_user.userupname
# }
# output "svc_user_objectid" {
#   value = module.ad_svc_user.svc_user_objectid
# }

#outputs of datalakecontainer
output "datalake_container_id" {
  value = module.datalakecontainer.datalake_container_id
}
output "datalake_name" {
  value = module.datalakecontainer.datalake_name
}
output "datalake_resource_group_name" {
  value = module.datalakecontainer.datalake_resource_group_name
}
output "datalake_container_name" {
  value = module.datalakecontainer.container_name
}

# #outputs of spn
# output "spn_client_id" {
#   value = module.spn.spn_client_id
# }
# output "spn_secret_value" {
#   value     = module.spn.spn_secret_value
#   sensitive = true
# }

# #outputs of keyvault
# output "key_vault_id" {
#   value = module.keyvault.key_vault_id
# }
# output "key_vault_uri" {
#   value = module.keyvault.key_vault_uri
# }
# output "keyvaultName" {
#   value = module.keyvault.KeyvaultName
# }

# #outputs of logic app
# output "logic_app_workflow_id" {
#   value = module.logic_app.logic_app_workflow_id
# }
# output "logic_app_access_endpoint" {
#   value = module.logic_app.logic_app_access_endpoint
# }
# output "logic_app_identity" {
#   value = module.logic_app.logic_app_identity
# }
# output "logicApp_Name" {
#   value = module.logic_app.logicApp_Name
# }

# #outputs of resource group 
# output "resource_group_name" {
#   value = module.resource_group.resource_group_name
# }
# output "resource_group_location" {
#   value = module.resource_group.resource_group_location
# }