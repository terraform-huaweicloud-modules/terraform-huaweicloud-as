output "configuration_id" {
  description = "The ID of the AS configuration"
  value       = module.as_instance_scaling.configuration_id
}

output "group_id" {
  description = "The ID of the AS group"
  value       = module.as_instance_scaling.group_id
}

output "policy_id" {
  description = "The ID of the AS policy"
  value       = module.as_instance_scaling.policy_id
}
