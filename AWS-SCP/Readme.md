# AWS Service Control Policies (SCP) Terraform Module

This Terraform module manages AWS Service Control Policies (SCPs) for AWS Organizations. It allows you to define, create, and attach SCPs to Organizational Units (OUs) with flexible variable support.

## Features

- Create multiple SCPs with custom names, descriptions, policy content, and tags
- Attach SCPs to a specified Organizational Unit (OU)
- Automatically fetch the current AWS Organization ID if not provided

## Usage

```hcl
module "aws_scp" {
  source = "path/to/this/module"

  aws_region      = "us-east-1"
  organization_id = null # Optional, will use current organization if not set
  target_ou_id    = "ou-xxxx-xxxxxxxx"

  scps = {
    deny_ec2 = {
      name           = "DenyEC2"
      description    = "Denies all EC2 actions"
      policy_content = <<EOF
        {
          "Version": "2012-10-17",
          "Statement": [
            {
              "Effect": "Deny",
              "Action": "ec2:*",
              "Resource": "*"
            }
          ]
        }
      EOF
      tags = {
        Environment = "Production"
      }
    },
    allow_s3 = {
      name           = "AllowS3"
      description    = "Allows all S3 actions"
      policy_content = <<EOF
        {
          "Version": "2012-10-17",
          "Statement": [
            {
              "Effect": "Allow",
              "Action": "s3:*",
              "Resource": "*"
            }
          ]
        }
      EOF
      tags = {
        Environment = "Development"
      }
    }
  }
}


module "aws_scp" {
  source = "path/to/this/module"

  aws_region      = "us-east-1"
  organization_id = null # Optional, will use current organization if not set
  target_ou_id    = "ou-xxxx-xxxxxxxx"

  scps = {
    deny_ec2 = {
      name           = "DenyEC2"
      description    = "Denies all EC2 actions"
      policy_content = data.some-scp-policy.json
      tags = {
        Environment = "Production"
      }
    }
  }
}
```

## Inputs

| Name           | Description                                                      | Type     | Default | Required |
|----------------|------------------------------------------------------------------|----------|---------|----------|
| aws_region     | The AWS region to deploy resources in                            | string   | "us-east-1" | no   |
| organization_id| The ID of the AWS Organization                                  | string   | null    | no       |
| scps           | Map of SCPs to create (name, description, policy_content, tags)  | map(object) | {}   | yes      |
| target_ou_id   | The ID of the Organizational Unit (OU) to attach the SCP to      | string   | null    | yes      |

## Outputs

This module does not explicitly define outputs, but you can reference the created policies and attachments using Terraform resource references.

##