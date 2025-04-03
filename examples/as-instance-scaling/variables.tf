######################################################################
# Configurations of VPC networking secgroup
######################################################################

variable "security_group_name" {
  type        = string
  description = "The security group name"
}

######################################################################
# Configurations of VPC
######################################################################

variable "vpc_name" {
  type        = string
  description = "The name of the VPC"
}

variable "vpc_cidr" {
  type        = string
  description = "The range of available subnets in the VPC"
}

######################################################################
# Configurations of VPC subnet
######################################################################

variable "subnets_configuration" {
  description = "The configuration for the subnet resources to which the VPC belongs"

  type = list(object({
    name         = string
    cidr         = string
    gateway_ip   = optional(string)
    description  = optional(string)
    ipv6_enabled = optional(bool)
    dhcp_enabled = optional(bool)
    dns_list     = optional(list(string))
    tags         = optional(map(string))
  }))
  nullable = false
}

######################################################################
# Configurations of ECS
######################################################################

variable "instance_flavor_cpu_core_count" {
  type        = number
  description = "The CPU core number of the ECS instance flavor to be queried"
}

variable "instance_flavor_memory_size" {
  type        = number
  description = "The memory size of the ECS instance flavor to be queried"
}

variable "instance_image_os_type" {
  type        = string
  description = "The OS type of the IMS image to be queried that the ECS instance used"
}

variable "instance_image_architecture" {
  type        = string
  description = "The architecture of the IMS image to be queried that the ECS instance used"
}

variable "instance_name" {
  type        = string
  description = "The name of the ECS instance"
}

variable "instance_disks_configuration" {
  type = list(object({
    is_system_disk = bool
    name           = optional(string)
    type           = string
    size           = number
  }))

  description = "The disks configuration to attach to the ECS instance"
}

######################################################################
# Configurations of AS configuration
######################################################################

variable "configuration_name" {
  type        = string
  description = "The AS configuration name"
}

variable "configuration_disk" {
  type = list(object({
    size                 = optional(number)
    volume_type          = optional(string)
    disk_type            = optional(string)
    kms_id               = optional(string)
    iops                 = optional(number)
    throughput           = optional(number)
    dedicated_storage_id = optional(string)
    data_disk_image_id   = optional(string)
    snapshot_id          = optional(string)
  }))
  description = "The disk group information"
}

variable "configuration_public_ip" {
  type = list(object({
    eip = list(object({
      ip_type   = optional(string)
      bandwidth = list(object({
        share_type    = optional(string)
        charging_mode = optional(string)
        size          = optional(number)
        id            = optional(string)
      }))
    }))
  }))
  description = "The EIP of the ECS instance"
}

variable "configuration_user_data" {
  type        = string
  description = "The user data to be injected during the ECS creation process"
}

variable "configuration_metadata" {
  type        = map(string)
  description = "The key/value pairs to make available from within the instance"
}

######################################################################
# Configurations of AS group
######################################################################

variable "group_name" {
  type        = string
  description = "The name of the scaling group"
}

variable "group_min_instance_number" {
  type        = number
  description = "The minimum number of instances"
}

variable "group_max_instance_number" {
  type        = number
  description = "The maximum number of instances"
}

variable "group_desire_instance_number" {
  type        = number
  description = "The expected number of instances"
}

variable "group_delete_instances" {
  type        = string
  description = "Whether to delete the instances in the AS group when deleting the AS group"
}

variable "group_source_dest_check" {
  type        = bool
  description = "Whether process only traffic that is destined specifically for it"
}

######################################################################
# Configurations of AS policy
######################################################################

variable "policy_name" {
  type        = string
  description = "the name of the AS policy"
}

variable "policy_type" {
  type        = string
  description = "the AS policy type"
}

variable "policy_scheduled_policy" {
  type = list(object({
    launch_time      = optional(string)
    recurrence_type  = optional(string)
    recurrence_value = optional(string)
    start_time       = optional(string)
    end_time         = optional(string)
  }))
  description = "the periodic or scheduled AS policy"
}

variable "policy_scaling_policy_action" {
  type = list(object({
    operation           = optional(string)
    instance_number     = optional(number)
    instance_percentage = optional(number)
  }))
  description = "the action of the AS policy"
}

variable "policy_action" {
  type        = string
  description = "the operation for the AS policy"
}
