output "internalsqlservername" {
  value = local.synapse_server
}
output "adminsgroupname" {
  value = local.ad_admins_group
}
output "developersgroupname" {
  value = local.ad_developers_group
}
output "readersgroupname" {
  value = local.schema_readers_group
}
output "databasename" {
  value = local.synapse_db
}
output "readerrolename" {
  value = local.schema_reader_role
}
output "datawriterrolename" {
  value = local.schema_writer_role
}
output "developerrolename" {
  value = local.schema_developer_role
}
output "ownerRoleName" {
  value = local.schema_owner_role
}
output "schemaName" {
  value = local.schema
}
output "membername" {
  value = local.owner_member_name_2
}
output "appshortcodename" {
  value = local.app
}
# SPN Name
output "spnclientname" {
  value = local.service_principal
}
#outputs of datalakecontainer
output "datalakecontainername" {
  value = local.dl_container
}
output "app" {
  value = local.app
}
# Data Facorty Name
output "datafactoryIdName" {
  value = local.df_name
}

#Synapse Resource Name 

output "synapse_name" {
  value = local.synapse_name
}

##############################################################################################################
#outputs of ad_group


output "svc_email" {
  value = local.svc_account_email
}

#outputs of keyvault

output "keyvaultName" {
  value = local.kv_name
}

