# AWS Session Manager Terraform Module
> **Secure, auditable shell access to EC2 instances without SSH keys or bastion hosts**

This Terraform module deploys AWS Session Manager following security best practices, enabling zero-trust access to your EC2 instances with comprehensive logging and monitoring. Please note that this module is not intended to be deployed as is. Additional alterations/enhancements will need to be preformed to better cater towards Cargill environment. This code should just be used as a baseline/starter to build upon.

## ✨ Features

- 🔒 **Zero-Trust Security** - No SSH keys, no bastion hosts, no direct internet access
- 🔐 **End-to-End Encryption** - KMS encryption for all session data and logs
- 📊 **Comprehensive Logging** - CloudWatch and S3 integration with retention policies
- 🌐 **Private Network Access** - VPC endpoints for secure AWS API communication
- 👥 **Granular Access Control** - Tag-based and user-specific permissions
- 📈 **Built-in Monitoring** - CloudWatch dashboard and metrics
- 💰 **Cost Optimized** - Lifecycle policies and efficient resource usage



## 🚀 Quick Start

### Prerequisites

- Terraform >= 1.0
- AWS Verion ~> 5.0


## 📋 Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `project_name` | Project name for resource naming | `string` | `"myproject"` | no |
| `environment` | Environment name (dev, staging, prod) | `string` | `"dev"` | no |
| `vpc_id` | VPC ID where Session Manager will be deployed | `string` | n/a | yes |
| `private_subnet_ids` | Private subnet IDs for VPC endpoints | `list(string)` | n/a | yes |
| `session_timeout` | Session timeout in minutes | `number` | `60` | no |
| `enable_session_logging` | Enable session logging to CloudWatch and S3 | `bool` | `true` | no |
| `kms_key_deletion_window` | KMS key deletion window in days | `number` | `7` | no |
|`security_group_ids` | Security group IDs for VPC endpoints | `list(string)` | no | no |
| `value` | Value of SSM parameter | `string` | `null` | no |
| `values` | List of values of the SSM parameter (will be jsonencoded to store as string natively in SSM) | `list(string)` | `[]` | no |
| `secure_type` |Whether the type of the value should be considered as secure or not | `bool` | `false` | no |
| `type` | Type of the SSM parameter. Valid types are String, StringList and SecureString. | `string` | `null` | no |
| `allowed_pattern` | Regular expression used to validate the parameter value | `string` | `null` | no |



## 📤 Outputs

| Name | Description |
|------|-------------|
| `kms_key_id` | KMS key ID for Session Manager encryption |
| `kms_key_arn` | KMS key ARN for Session Manager encryption |
| `instance_profile_name` | Instance profile name for EC2 instances |
| `instance_profile_arn` | Instance profile ARN for EC2 instances |
| `vpc_endpoint_ids` | VPC endpoint IDs for Session Manager |
| `s3_bucket_name` | S3 bucket name for session logs |
| `cloudwatch_log_group_name` | CloudWatch log group name for session logs |
| `user_policy_arn` | IAM policy ARN for Session Manager users |
| `user_group_name` | IAM group name for Session Manager users |

## 🔐 Security Best Practices

### ✅ What This Module Implements

- **🔒 Encryption at Rest & Transit** - All session data encrypted with customer-managed KMS keys
- **🌐 Private Network Communication** - VPC endpoints eliminate internet traffic
- **👤 Least Privilege Access** - Role-based permissions with resource restrictions
- **📝 Complete Audit Trail** - All sessions logged with user attribution
- **⏱️ Session Timeouts** - Automatic session termination
- **🏷️ Tag-Based Access Control** - Fine-grained permissions using resource tags


## 📊 Monitoring & Logging

### Session Logs

Session activities are logged to:
- **CloudWatch Logs** - Real-time session monitoring
- **S3 Bucket** - Long-term storage with lifecycle policies


