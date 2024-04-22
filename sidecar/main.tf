#creates data lake container
module "datalakecontainer" {
source                       = "../infra/modules/datalakecontainer"
  datalake_container_name      = local.dl_container
  datalake_resource_group_name = local.dlsa_rg_name
  existing_datalake            = var.existing_datalake
}

#Storage Blob Data Contributor role assignment on data lake container for developer group
module "role_assignment_datalake_container_storage_blob_datacontributor_developers_group" {
  count                = var.ad_developers_group != "" ? 1 : 0
  source               = "../infra/modules/role_assignment"
  scope                = local.dl_container_scope
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = [data.azuread_group.ad_dev[count.index].object_id]
}

#Storage Blob Data Contributor role assignment on data lake container for data factory identity
module "role_assignment_datalake_container_storage_blob_datacontributor_data_factory" {
  count                = var.datafactory != "" ? 1 : 0
  source               = "../infra/modules/role_assignment"
  scope                = local.dl_container_scope
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = [data.azurerm_data_factory.identity_management_rbac[count.index].identity[0].principal_id]
}

#Storage Blob Data Contributor role assignment on data lake container for service principal
module "role_assignment_datalake_container_storage_blob_datacontributor_service_principal" {
  count                = var.service_principal != "" ? 1 : 0
  source               = "../infra/modules/role_assignment"
  scope                = local.dl_container_scope
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = [data.azuread_service_principal.rbac_storage_blob_data_contributor[count.index].object_id]
}

#storage blob data owner role assignment on data lake container for admins group
module "role_assignment_datalake_container_storage_blob_data_owner" {
  count                = var.ad_admins_group != "" ? 1 : 0
  source               = "../infra/modules/role_assignment"
  scope                = local.dl_container_scope
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = [data.azuread_group.ad_admins[count.index].object_id]
}

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#add admins group to cluster general 01 group 
resource "databricks_group_member" "admins" {
  provider  = databricks.azure_account
  count     = var.ad_admins_group != "" ? 1 : 0
  group_id  = data.databricks_group.clustergroups1.id
  member_id = data.databricks_group.admins[count.index].id #dbs-functionalgroup.id
  #depends_on = [data.databricks_group.admins]
}

#add developers group to cluster general 01 group
resource "databricks_group_member" "dev" {
  provider  = databricks.azure_account
  count     = var.ad_developers_group != "" ? 1 : 0
  group_id  = data.databricks_group.clustergroups1.id
  member_id = data.databricks_group.developers[count.index].id #dbs-functionalgroup.id
  #depends_on = [data.databricks_group.admins]
}

#add admins group to cluster general 02 group 
resource "databricks_group_member" "admins2" {
  provider  = databricks.azure_account
  count     = var.ad_admins_group != "" ? 1 : 0
  group_id  = data.databricks_group.clustergroups2.id
  member_id = data.databricks_group.admins[count.index].id #dbs-functionalgroup.id
  #depends_on = [data.databricks_group.admins]
}

#add developers group to cluster general 02 group
resource "databricks_group_member" "dev2" {
  provider  = databricks.azure_account
  count     = var.ad_developers_group != "" ? 1 : 0
  group_id  = data.databricks_group.clustergroups2.id
  member_id = data.databricks_group.developers[count.index].id #dbs-functionalgroup.id
  #depends_on = [data.databricks_group.admins]
}

#creates workspace folder in databricks
resource "databricks_directory" "my_custom_directory" {
  provider = databricks.azure_account
  path     = "/${local.databricksFolderName}"

}

#assign permissions on workspace folder for admins group
resource "databricks_permissions" "folder_usage_admins" {
  provider       = databricks.azure_account
  count          = var.ad_admins_group != "" ? 1 : 0
  directory_path = databricks_directory.my_custom_directory.path
 
access_control {
    group_name       = data.databricks_group.admins[count.index].display_name
    permission_level = "CAN_MANAGE"
  }
}

#assign permissions on workspace folder for developers group
resource "databricks_permissions" "folder_usage_developers" {
  provider       = databricks.azure_account
  count          = var.ad_developers_group != "" ? 1 : 0
  directory_path = databricks_directory.my_custom_directory.path
  access_control {
    group_name       = data.databricks_group.developers[count.index].display_name
    permission_level = "CAN_MANAGE"
  }
}

#assign permissions on workspace folder for service principal
resource "databricks_permissions" "folder_usage_service_principal" {
  provider       = databricks.azure_account
  count          = var.service_principal != "" ? 1 : 0
  directory_path = databricks_directory.my_custom_directory.path
  access_control {
    service_principal_name = databricks_service_principal.service_principal[count.index].application_id
    permission_level       = "CAN_RUN"
  }
}

#assign permissions on workspace folder for datafactory service principal
resource "databricks_permissions" "folder_usage_service_principal_datafactory" {
  provider       = databricks.azure_account
  count          = var.datafactory != "" ? 1 : 0
  directory_path = databricks_directory.my_custom_directory.path
  access_control {
    service_principal_name = databricks_service_principal.data_factory[count.index].application_id
    permission_level       = "CAN_RUN"
  }
}

#creates datafactory service principal
resource "databricks_service_principal" "data_factory" {
  provider             = databricks.azure_account
  count                = var.datafactory != "" ? 1 : 0
  display_name         = data.azurerm_data_factory.spn[count.index].name
  application_id       = data.azurerm_data_factory.spn[count.index].identity[0].principal_id
  allow_cluster_create = true
}

#creates service principal
resource "databricks_service_principal" "service_principal" {
  provider             = databricks.azure_account
  count                = var.service_principal != "" ? 1 : 0
  display_name         = var.service_principal
  application_id       = data.azuread_service_principal.spn[count.index].client_id
  allow_cluster_create = true
  workspace_access     = true

}

#adds service principal in admins group for pat token generation
resource "databricks_group_member" "service_principal" {
  provider  = databricks.azure_account
  count     = var.service_principal != "" ? 1 : 0
  group_id  = data.databricks_group.dbks_admins_group.id
  member_id = databricks_service_principal.service_principal[0].id

}

#account id of the databricks
locals {
  account_id = var.databricks_account_id
}

#permissions on service principal for admins, developers groups as user and manager
resource "databricks_access_control_rule_set" "automation_sp_rule_set_user_admins" {
  provider = databricks.azure_account
  count = var.service_principal != "" && (var.ad_admins_group != "" || var.ad_developers_group != "") ? 1 : 0
  
  name     = "accounts/${local.account_id}/servicePrincipals/${databricks_service_principal.service_principal[0].application_id}/ruleSets/default"
  dynamic "grant_rules" {
    for_each = var.ad_admins_group != "" ? [1] : []
    content {
      principals = [data.databricks_group.admins[0].acl_principal_id]
      role       = "roles/servicePrincipal.user"
    }
  }
  dynamic  "grant_rules"  {
    for_each = var.ad_admins_group != "" ? [1] : []
    content {
    principals = [data.databricks_group.admins[0].acl_principal_id]
    role       = "roles/servicePrincipal.manager"
  }
  }
 dynamic "grant_rules" {
    for_each = var.ad_developers_group != "" ? [1] : []
    content {
      principals = [data.databricks_group.developers[0].acl_principal_id]
      role       = "roles/servicePrincipal.user"
    }
  }
  dynamic  "grant_rules"  {
    for_each = var.ad_developers_group != "" ? [1] : []
    content {
    principals = [data.databricks_group.developers[0].acl_principal_id]
    role       = "roles/servicePrincipal.manager"
  }
  }
}

#creates secret scope
resource "databricks_secret_scope" "secretscope_kv" {
  provider = databricks.azure_account
  count    = var.keyvault != "" ? 1 : 0
  name     = "AKV-${local.app}"
  # initial_manage_principal = "users"

  keyvault_metadata {
    resource_id = data.azurerm_key_vault.keyvault[count.index].id
    dns_name    = data.azurerm_key_vault.keyvault[count.index].vault_uri
  }
  #depends_on = [data.azurerm_key_vault.pat_keyvault]
}

#Create databricks acl for admins group
resource "databricks_secret_acl" "secret_acl_admins" {
  provider   = databricks.azure_account
  count      = var.ad_admins_group != "" ? 1 : 0
  principal  = data.databricks_group.admins[count.index].display_name
  permission = "MANAGE"
  scope      = databricks_secret_scope.secretscope_kv[count.index].name
  # depends_on = [ azurerm_key_vault_secret.svctoken_kv, databricks_secret_scope.secretscope_kv ]
  #depends_on = [databricks_secret_scope.secretscope_kv]
}

##Create databricks acl for developers group
resource "databricks_secret_acl" "secret_acl_developers" {
  provider   = databricks.azure_account
  count      = var.ad_developers_group != "" ? 1 : 0
  principal  = data.databricks_group.developers[count.index].display_name
  permission = "READ"
  scope      = databricks_secret_scope.secretscope_kv[count.index].name
  # depends_on = [ azurerm_key_vault_secret.svctoken_kv, databricks_secret_scope.secretscope_kv ]
  #depends_on = [databricks_secret_scope.secretscope_kv]
}

##Create databricks acl for datafactory
resource "databricks_secret_acl" "secret_acl_datafactory" {
  provider   = databricks.azure_account
  count      = var.service_principal != "" ? 1 : 0
  principal  = data.azurerm_data_factory.spn[count.index].identity[0].principal_id
  permission = "READ"
  scope      = databricks_secret_scope.secretscope_kv[count.index].name
  # depends_on = [ azurerm_key_vault_secret.svctoken_kv, databricks_secret_scope.secretscope_kv ]
  #depends_on = [databricks_secret_scope.secretscope_kv]
}

##Create databricks acl for service principal
resource "databricks_secret_acl" "secret_acl_service_principal" {
  provider   = databricks.azure_account
  count      = var.service_principal != "" ? 1 : 0
  principal  = databricks_service_principal.service_principal[count.index].application_id
  permission = "READ"
  scope      = databricks_secret_scope.secretscope_kv[count.index].name
  # depends_on = [ azurerm_key_vault_secret.svctoken_kv, databricks_secret_scope.secretscope_kv ]
  #depends_on = [databricks_secret_scope.secretscope_kv]
}

#create job cluster pool
resource "databricks_instance_pool" "job_cluster" {
  provider                              = databricks.azure_account
  instance_pool_name                    = "${local.app}-Pool-General-JobClusters"
  min_idle_instances                    = 0
  idle_instance_autotermination_minutes = 60
  node_type_id                          = "Standard_L8s_v3"
  azure_attributes {
    availability = "ON_DEMAND_AZURE"
  }
  preloaded_spark_versions = [
    "10.4.x-scala2.12"
  ]
}

#creates pool permissions on admins group
resource "databricks_permissions" "pool_usage_admins" {
  provider         = databricks.azure_account
  count            = var.ad_admins_group != "" ? 1 : 0
  depends_on       = [databricks_instance_pool.job_cluster]
  instance_pool_id = databricks_instance_pool.job_cluster.id

  access_control {
    group_name       = data.databricks_group.admins[count.index].display_name
    permission_level = "CAN_MANAGE"
  }
 
}

#creates pool permissions on developers group
resource "databricks_permissions" "pool_usage_developers" {
  provider         = databricks.azure_account
  count            = var.ad_developers_group != "" ? 1 : 0
  depends_on       = [databricks_instance_pool.job_cluster]
  instance_pool_id = databricks_instance_pool.job_cluster.id

  access_control {
    group_name       = data.databricks_group.developers[count.index].display_name
    permission_level = "CAN_MANAGE"
  }
}

#creates pool permissions on datafactory
resource "databricks_permissions" "pool_usage_datafactory" {
  provider         = databricks.azure_account
  count            = var.datafactory != "" ? 1 : 0
  depends_on       = [databricks_instance_pool.job_cluster]
  instance_pool_id = databricks_instance_pool.job_cluster.id

  access_control {
    service_principal_name = databricks_service_principal.data_factory[count.index].application_id
    permission_level       = "CAN_ATTACH_TO"
  }
}

#creates pool permissions on service principal
resource "databricks_permissions" "pool_usage_service_principal" {
  provider         = databricks.azure_account
  count            = var.service_principal != "" ? 1 : 0
  depends_on       = [databricks_instance_pool.job_cluster]
  instance_pool_id = databricks_instance_pool.job_cluster.id

  access_control {
    service_principal_name = databricks_service_principal.service_principal[count.index].application_id
    permission_level       = "CAN_ATTACH_TO"
  }
}
