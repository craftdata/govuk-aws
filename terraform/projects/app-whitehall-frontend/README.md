## Project: app-whitehall-frontend

Whitehall Frontend nodes


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aws_environment | AWS Environment | string | - | yes |
| aws_region | AWS region | string | `eu-west-1` | no |
| elb_internal_certname | The ACM cert domain name to find the ARN of | string | - | yes |
| instance_ami_filter_name | Name to use to find AMI images | string | `` | no |
| remote_state_bucket | S3 bucket we store our terraform state in | string | - | yes |
| remote_state_infra_aws_logging_key_stack | Override stackname path to infra_aws_logging remote state | string | `` | no |
| remote_state_infra_networking_key_stack | Override infra_networking remote state path | string | `` | no |
| remote_state_infra_security_groups_key_stack | Override infra_security_groups stackname path to infra_vpc remote state | string | `` | no |
| remote_state_infra_stack_dns_zones_key_stack | Override stackname path to infra_vpc remote state | string | `` | no |
| remote_state_infra_stack_sns_alerts_key_stack | Override stackname path to infra_stack_sns_alerts remote state | string | `` | no |
| remote_state_infra_vpc_key_stack | Override infra_vpc remote state path | string | `` | no |
| ssh_public_key | whitehall-frontend default public key material | string | - | yes |
| stackname | Stackname | string | - | yes |
| user_data_snippets | List of user-data snippets | list | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| service_dns_name | DNS name to access the node service |
| whitehall-frontend_elb_address | AWS' internal DNS name for the whitehall-frontend ELB |
