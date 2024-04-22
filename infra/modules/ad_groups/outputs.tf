output "ad_admins_group_object_id" {
  value = azuread_group.ad_admins.object_id
}
output "ad_dev_group_object_id" {
  value = azuread_group.ad_dev.object_id
}