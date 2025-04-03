# AS instance scaling example

Configuration in this directory manages AS instance scaling.

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan -var-file=variables.json
$ terraform apply -var-file=variables.json
```

Run `terraform destroy -var-file=variables.json` when you don't need these resources.

## Requirements

| Name                 | Version   |
|----------------------|-----------|
| Terraform            | >= 1.3.0  |
| Huaweicloud Provider | >= 1.73.0 |

## Modules

<!-- markdownlint-disable MD013 -->
| Name                | Source                                                                                                  | Version |
|---------------------|---------------------------------------------------------------------------------------------------------|---------|
| vpc_network         | [terraform-huaweicloud-vpc](https://github.com/terraform-huaweicloud-modules/terraform-huaweicloud-vpc) | v1.2.0  |
| ecs_instance        | [terraform-huaweicloud-ecs](https://github.com/terraform-huaweicloud-modules/terraform-huaweicloud-ecs) | N/A     |
| as_instance_scaling | [../../modules/as-instance-scaling](../../modules/as-instance-scaling)                                  | N/A     |
<!-- markdownlint-enable MD013 -->

## Resources

| Name                                     | Type        |
|------------------------------------------|-------------|
| random_password.this                     | resource    |
| data.huaweicloud_availability_zones.this | data source |
| data.huaweicloud_images_image.this       | data source |
| data.huaweicloud_compute_flavors.this    | data source |

## Inputs

<!-- markdownlint-disable MD013 -->
| Name                           | Description                                                                | Value                                                                                                                                                                                                                                                   |
|--------------------------------|----------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| security_group_name            | The security group name                                                    | `"test-sg-name"`                                                                                                                                                                                                                                        |
| vpc_name                       | The name of the VPC                                                        | `"test-vpc-name"`                                                                                                                                                                                                                                       |
| vpc_cidr                       | The range of available subnets in the VPC                                  | `"192.168.0.0/16"`                                                                                                                                                                                                                                      |
| subnets_configuration          | The configuration for the subnet resources to which the VPC belongs        | <pre>[{<br>  "name": "test-subnet-name",<br>  "cidr": "192.168.0.0/24",<br>  "gateway_ip": "192.168.0.1"<br>}]</pre>                                                                                                                                    |
| instance_flavor_cpu_core_count | The CPU core number of the ECS instance flavor to be queried               | `4`                                                                                                                                                                                                                                                     |
| instance_flavor_memory_size    | The memory size of the ECS instance flavor to be queried                   | `8`                                                                                                                                                                                                                                                     |
| instance_image_os_type         | The OS type of the IMS image to be queried that the ECS instance used      | `"CentOS"`                                                                                                                                                                                                                                              |
| instance_image_architecture    | The architecture of the IMS image to be queried that the ECS instance used | `"x86"`                                                                                                                                                                                                                                                 |
| instance_name                  | The name of the ECS instance                                               | `"ecs-test-module"`                                                                                                                                                                                                                                     |
| instance_disks_configuration   | The disks configuration to attach to the ECS instance                      | <pre>[{<br>  "is_system_disk": true,<br>  "type": "SSD",<br>  "size": 200<br>}]</pre>                                                                                                                                                                   |
| configuration_name             | The AS configuration name                                                  | `"test-configuration-name"`                                                                                                                                                                                                                             |
| configuration_disk             | The disk group information                                                 | <pre>[{<br>  "size": 40,<br>  "volume_type": "SSD",<br>  "disk_type": "SYS"<br>}]</pre>                                                                                                                                                                 |
| configuration_public_ip        | The EIP of the ECS instance                                                | <pre>[{<br>  "eip": [<br>    {<br>      "ip_type": "5_bgp",<br>      "bandwidth": [<br>        {<br>          "size": 10,<br>          "share_type": "PER",<br>          "charging_mode": "traffic"<br>        }<br>      ]<br>    }<br>  ]<br>}]</pre> |
| configuration_user_data        | The user data to be injected during the ECS creation process               | `"test-user-data"`                                                                                                                                                                                                                                      |
| configuration_metadata         | The key/value pairs to make available from within the instance             | <pre>{<br>  "some_key": "some_value"<br>}</pre>                                                                                                                                                                                                         |
| group_name                     | The name of the scaling group                                              | `"test-group-name"`                                                                                                                                                                                                                                     |
| group_min_instance_number      | The minimum number of instances                                            | `0`                                                                                                                                                                                                                                                     |
| group_max_instance_number      | The maximum number of instances                                            | `2`                                                                                                                                                                                                                                                     |
| group_desire_instance_number   | The expected number of instances                                           | `1`                                                                                                                                                                                                                                                     |
| group_delete_instances         | Whether to delete the instances in the AS group when deleting the AS group | `"yes"`                                                                                                                                                                                                                                                 |
| group_source_dest_check        | Whether process only traffic that is destined specifically for it          | `false`                                                                                                                                                                                                                                                 |
| policy_name                    | the name of the AS policy                                                  | `"test-policy-name"`                                                                                                                                                                                                                                    |
| policy_type                    | the AS policy type                                                         | `"SCHEDULED"`                                                                                                                                                                                                                                           |
| policy_scheduled_policy        | the periodic or scheduled AS policy                                        | <pre>[<br>  {<br>    "launch_time": "2099-12-22T12:00Z"<br>  }<br>]</pre>                                                                                                                                                                               |
| policy_scaling_policy_action   | the action of the AS policy                                                | <pre>[<br>  {<br>    "operation": "ADD",<br>    "instance_number": 1<br>  }<br>]</pre>                                                                                                                                                                  |
| policy_action                  | the operation for the AS policy                                            | `"pause"`                                                                                                                                                                                                                                               |
<!-- markdownlint-enable MD013 -->

## Outputs

| Name             | Description                    |
|------------------|--------------------------------|
| configuration_id | The ID of the AS configuration |
| group_id         | The ID of the AS group         |
| policy_id        | The ID of the AS policy        |
