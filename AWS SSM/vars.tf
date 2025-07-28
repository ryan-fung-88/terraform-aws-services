variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "myproject"
}

variable "vpc_id" {
  description = "VPC ID where Session Manager will be deployed"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for VPC endpoints"
  type        = list(string)
}

variable "session_timeout" {
  description = "Session timeout in minutes"
  type        = number
  default     = 60
}

variable "enable_session_logging" {
  description = "Enable session logging to CloudWatch and S3"
  type        = bool
  default     = true
}

variable "kms_key_deletion_window" {
  description = "KMS key deletion window in days"
  type        = number
  default     = 7
}

variable "enable_kms_key_rotation" {
  description = "value to enable KMS key rotation"
  type        = bool
  default     = true
}

variable "security_group_ids" {
  description = "Security group IDs for VPC endpoints"
  type        = list(string)
}

variable "value" {
  description = "Value of the parameter"
  type        = string
  default     = null
}

variable "values" {
  description = "List of values of the parameter (will be jsonencoded to store as string natively in SSM)"
  type        = list(string)
  default     = []
}

variable "secure_type" {
  description = "Whether the type of the value should be considered as secure or not?"
  type        = bool
  default     = false
}

variable "type" {
  description = "Type of the parameter. Valid types are String, StringList and SecureString."
  type        = string
  default     = null
}

variable "allowed_pattern" {
  description = "Regular expression used to validate the parameter value."
  type        = string
  default     = null
}
