output "adgroupmembers" {
  value = data.azuread_group.existingazadgroup.members
}