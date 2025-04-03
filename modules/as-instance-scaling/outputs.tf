output "configuration_id" {
  description = "The ID of the AS configuration"
  value       = try(huaweicloud_as_configuration.this[0].id, "")
}

output "group_id" {
  description = "The ID of the AS group"
  value       = try(huaweicloud_as_group.this[0].id, "")
}

output "policy_id" {
  description = "The ID of the AS policy"
  value       = try(huaweicloud_as_policy.this[0].id, "")
}

