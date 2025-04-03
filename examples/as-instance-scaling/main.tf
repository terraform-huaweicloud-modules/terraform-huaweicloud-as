data "huaweicloud_availability_zones" "this" {}

data "huaweicloud_images_image" "this" {
  name        = "Ubuntu 18.04 server 64bit"
  visibility  = "public"
  most_recent = true
}

data "huaweicloud_compute_flavors" "this" {
  availability_zone = try(data.huaweicloud_availability_zones.this.names[0], "")
  performance_type  = "normal"
  cpu_core_count    = 2
  memory_size       = 4
}

resource "random_password" "this" {
  length           = 16
  special          = true
  min_numeric      = 1
  min_special      = 1
  min_lower        = 1
  min_upper        = 1
  override_special = "!#"
}

module "vpc_network" {
  source = "github.com/terraform-huaweicloud-modules/terraform-huaweicloud-vpc?ref=v1.2.0"

  # Security Group
  availability_zone   = try(data.huaweicloud_availability_zones.this.names[0], "")
  security_group_name = var.security_group_name

  # VPC
  vpc_name = var.vpc_name
  vpc_cidr = var.vpc_cidr

  # VPC subnet
  subnets_configuration = var.subnets_configuration
}

module "ecs_instance" {
  source = "github.com/terraform-huaweicloud-modules/terraform-huaweicloud-ecs"

  availability_zone = try(data.huaweicloud_availability_zones.this.names[0], "")

  instance_flavor_cpu_core_count      = var.instance_flavor_cpu_core_count
  instance_flavor_memory_size         = var.instance_flavor_memory_size
  instance_image_os_type              = var.instance_image_os_type
  instance_image_architecture         = var.instance_image_architecture
  instance_name                       = var.instance_name
  instance_admin_pass                 = random_password.this.result
  instance_security_group_ids         = [try(module.vpc_network.security_group_id, "")]
  use_inside_data_disks_configuration = true
  instance_disks_configuration        = var.instance_disks_configuration

  instance_networks_configuration = try(module.vpc_network.subnet_ids[0], "") != "" ? [
    {
      uuid = try(module.vpc_network.subnet_ids[0], "")
    }
  ] : []
}

module "as_instance_scaling" {
  source = "../../modules/as-instance-scaling"

  # AS configuration
  configuration_name               = var.configuration_name
  configuration_flavor             = try(data.huaweicloud_compute_flavors.this.ids[0], "")
  configuration_image              = try(data.huaweicloud_images_image.this.id, "")
  configuration_security_group_ids = [try(module.vpc_network.security_group_id, "")]
  configuration_metadata           = var.configuration_metadata
  configuration_user_data          = var.configuration_user_data
  configuration_disk               = var.configuration_disk
  configuration_public_ip          = var.configuration_public_ip

  # AS group
  group_name                   = var.group_name
  group_min_instance_number    = var.group_min_instance_number
  group_max_instance_number    = var.group_max_instance_number
  group_desire_instance_number = var.group_desire_instance_number
  group_vpc_id                 = try(module.vpc_network.vpc_id, "")
  group_delete_instances       = var.group_delete_instances

  group_networks = [
    {
      id                = try(module.vpc_network.subnet_ids[0], "")
      source_dest_check = var.group_source_dest_check
    }
  ]

  group_security_groups = [
    {
      id = try(module.vpc_network.security_group_id, "")
    }
  ]

  # AS instance attach
  attach_instances_configuration = [
    {
      instance_id = module.ecs_instance.instance_id
    }
  ]

  # AS policy
  policy_name                  = var.policy_name
  policy_type                  = var.policy_type
  policy_scaling_policy_action = var.policy_scaling_policy_action
  policy_scheduled_policy      = var.policy_scheduled_policy
  policy_action                = var.policy_action
}
