# AWS Config Terraform Module

This Terraform module provisions AWS Config resources, including configuration recorder, delivery channel, aggregator, and managed config rules, with support for multi-account and multi-region aggregation.

## Features

- AWS Config configuration recorder
- Delivery channel with S3 bucket integration
- Aggregator for organization-wide config aggregation
- Managed AWS Config rules (parameterized)
- Flexible variable support for multi-account and multi-region setups

## Usage

```hcl
module "aws_config" {
  source = "path/to/this/module"

  aws_region                        = "us-east-1"
  config_recorder_name              = "central-config-recorder"
  config_recorder_role              = "arn:aws:iam::123456789012:role/aws_config_role"
  recording_all_resource_types      = true
  include_global_resource_types     = true
  resource_types_to_record          = []
  enable_config_recorder            = true

  include_config_aggregator         = true
  account_aggregator_name           = "central-config-aggregator"
  config_aggregator_collection_account_id = "123456789012"
  config_aggregation_collection_region    = "us-east-1"
  aggregator_role_arn               = "arn:aws:iam::123456789012:role/config-aggregator-role"
  config_aggregation_all_regions    = true

  delivery_channel_name             = "central-config-delivery-channel"
  s3_config_bucket                  = "my-config-bucket"
  snapshot_delivery_frequency       = "One_Hour"

  managed_rules = {
    root_account_mfa = {
      identifier  = "ROOT_ACCOUNT_MFA_ENABLED"
      description = "Checks whether the root user of your AWS account requires multi-factor authentication for console sign-in."
    },
    restricted_ssh = {
      identifier  = "RESTRICTED_INCOMING_TRAFFIC"
      description = "Checks whether security groups disallow unrestricted incoming SSH traffic."
      parameters  = jsonencode({ blockedPort1 = "22" })
    }
  }
}


