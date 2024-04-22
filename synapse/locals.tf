# variable "env" {
#   description = "Environment (DEV/QA/PROD)"
#   type        = string
# }

# variable "functional_area" {
#   description = "Functional Area (commercial/dataops/global services/it/m&q/r&d)"
#   type        = string
# }

# Function to derive app based on the provided app
# locals {
#   derive_app = {
#     "ABCD" = "abcd"
#     # Add more mappings as needed
#   }

#   app = lookup(local.derive_app, upper(var.app), "DEFAULT")
# }

# Function to derive functional_area2 and functional_area3 based on user input
locals {
  derive_functional_area = {
    "commercial"      = "COM"
    "dataops"         = "DAT"
    "global services" = "GLO"
    "it"              = "IT"
    "m&q"             = "MNQ"
    "r&d"             = "RND"
  }
  storage_account_functional_area = {
    "commercial"      = "comm"
    "dataops"         = "edna"
    "global services" = "glbl"
    "it"              = "it"
    "m&q"             = "mq"
    "r&d"             = "rd"
  }
  data_lake_functionl_area = {
    "commercial"      = "comm"
    "dataops"         = "edna"
    "global services" = "global"
    "it"              = "it"
    "m&q"             = "mq"
    "r&d"             = "rd"
  }
    synapse_functionl_area = {
    "commercial"      = "Comm"
    "dataops"         = "EDNA"
    "global services" = "Global"
    "it"              = "IT"
    "m&q"             = "MQ"
    "r&d"             = "RD"
  }
  dl_functional_area       = lookup(local.data_lake_functionl_area, lower(var.functional_area), "default_value")
  st_functional_area       = lookup(local.storage_account_functional_area, lower(var.functional_area), "default_value")
  ad_group_functional_area = lookup(local.derive_functional_area, lower(var.functional_area), "default_value")
  #functional_area3 = lower(lookup(local.derive_functional_area, lower(var.functional_area), "default_value"))
  spn_functional_area = lower(lookup(local.derive_functional_area, lower(var.functional_area), "default_value"))
  synapsefunctional_area       = lookup(local.synapse_functionl_area, lower(var.functional_area), "default_value")

  # Derived variables

  region = {
    eastus      = "E1"
    westus      = "W1"
    westeurope  = "WE"
    northeurope = "NE"
    amsterdam   = "AM"
    ashburn     = "AB"
  }
  app                    = upper(var.appmnemonic)
  env1                   = upper(var.environment) == "PROD" ? "PROD" : "NONPROD"
  env2                   = upper(substr(var.environment, 0, 1))
  env3                   = upper(var.environment) == "PROD" ? "Prod" : "NonProd"
  ad_admins_group        = "AD-SEC-ALL-${local.ad_group_functional_area}-${local.app}-ADMINS"
  ad_developers_group    = "AD-SEC-ALL-${local.ad_group_functional_area}-${local.app}-DEVELOPERS"
  az_ad_admins_group     = "AZ-SEC-${local.env1}-${local.ad_group_functional_area}-${local.app}-ADMINS"
  az_ad_developers_group = "AZ-SEC-${local.env1}-${local.ad_group_functional_area}-${local.app}-DEVELOPERS"
  # rg_name                = "B${local.env2}AZE1I${local.app}RG01"
  rg_name              = "B${local.env2}AZ${local.region[var.location]}I${local.app}RG01"
  kv_name              = "B${local.env2}AZE1I${local.app}KV01"
  df_name              = upper("B${local.env2}AZE1I${local.app}DF01")
  la_name              = "B${local.env2}AZE1I${local.app}LA01"
  service_principal    = lower("app-${local.spn_functional_area}-${local.app}-${local.env3}")
  service_account_name = upper("SVC-${local.app}-${replace(var.data_product_name, " ", "")}-${upper(var.environment)}")
  ########################################################################
  dl_rg_name         = upper("b${lower(local.env2)}aze1i${local.st_functional_area}rg01}}")
  dl_storage_account = lower("b${lower(local.env2)}aze1i${local.st_functional_area}dl01")
  dl_container       = replace(lower("${local.dl_functional_area}-${var.data_product_name}"), " ", "")
  
  synapse_name     = upper(var.environment) == "DEV" ? "b${lower(local.env2)}aze1isqdwdb01" : "b${lower(local.env2)}aze1iednadb01"
  
  synapse_server     = upper(var.environment) == "DEV" ? "b${lower(local.env2)}aze1isqdwdb01.database.windows.net" : "b${lower(local.env2)}aze1iednadb01.database.windows.net"
  synapse_db         = upper(var.environment) == "DEV" ? "B${local.env2}AZE1ISQDWSV01" : "B${local.env2}AZE1IEDNADW01"
  

  
  #dw_synapse_db        = var.env == "DEV" ? "b${lower(local.env2)}aze1isqdwdb01.database.windows.net\${local.synapse_db}" : "b${lower(local.env2)}aze1iednadb01.database.windows.net\${local.synapse_db}"
  schema_readers_group = "AZ-SEC-${local.env1}-${local.ad_group_functional_area}-${local.app}-${upper(local.dl_functional_area)}${replace(var.data_product_name, " ", "")}Readers"

  schema_reader_role = "${local.synapsefunctional_area}${replace(var.data_product_name, " ", "")}DataReader"
  reader_role_name   = "${local.synapsefunctional_area}${replace(var.data_product_name, " ", "")}DataReader"
  reader_member_name = local.schema_readers_group

  schema_writer_role = "${local.synapsefunctional_area}${replace(var.data_product_name, " ", "")}DataWriter"

  schema_developer_role = "${local.synapsefunctional_area}${replace(var.data_product_name, " ", "")}Developer"
  developer_role_name   = "${local.synapsefunctional_area}${replace(var.data_product_name, " ", "")}Developer"
  developer_member_name = local.az_ad_developers_group

  schema_owner_role   = "${local.synapsefunctional_area}${replace(var.data_product_name, " ", "")}Owner"
  owner_role_name     = "${local.synapsefunctional_area}${replace(var.data_product_name, " ", "")}Owner"
  owner_member_name   = local.az_ad_admins_group
  owner_member_name_2 = "${local.env3}${local.synapsefunctional_area}Admins"

  ddl_admin_role_name  = "db_ddladmin"
  ddl_admin_membername = "${local.dl_functional_area}${replace(var.data_product_name, " ", "")}Owner"

  schema            = "${local.synapsefunctional_area}${replace(var.data_product_name, " ", "")}"
  authorization     = "${local.dl_functional_area}${replace(var.data_product_name, " ", "")}Owner"
  svc_account_email = lower("${local.service_account_name}@rgtechlabsoutlook.onmicrosoft.com")
  # databrick-host-url        = "https://${data.azurerm_databricks_workspace.dbs-ws.workspace_url}"
}