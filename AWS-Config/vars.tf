variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

variable "config_recorder_name" {
  description = "The name of the AWS Config configuration recorder"
  type        = string
  default     = "default"
}

variable "recording_all_resource_types" {
  description = "Whether to record all supported AWS resource types"
  type        = bool
  default     = true
}

variable "include_global_resource_types" {
  description = "Whether to include global resource types in the recording group"
  type        = bool
  default     = false
}

variable "resource_types_to_record" {
  description = "List of specific resource types to record if not recording all"
  type        = list(string)
  default     = []
}

variable "enable_config_recorder" {
  description = "Whether to enable the AWS Config configuration recorder"
  type        = bool
  default     = true
}

variable "include_config_aggregator" {
  description = "Whether to include the AWS Config configuration aggregator"
  type        = bool
  default     = true
}

variable "account_aggregator_name" {
  description = "The name of the AWS Config configuration aggregator"
  type        = string
  default     = "default"
}

variable "config_aggregator_collection_account_id" {
  description = "The AWS account ID to collect aggregated data from"
  type        = string
  default     = " "
}

variable "config_aggregation_collection_region" {
  description = "The AWS region to collect aggregated data from"
  type        = string
  default     = " "
}

variable "config_recorder_role" {
  description = "The ARN of the IAM role for AWS Config Recorder"
  type        = string
  default     = " " 
  
}

variable "config_aggregation_all_regions" {
  description = "Whether to aggregate AWS Config data from all regions"
  type        = bool
  default     = true
}

variable "aggregator_role_arn" {
  description = "The ARN of the IAM role that has permissions to read AWS Config data across accounts"
  type        = string
  default     = " " 
  
}


variable "delivery_channel_name" {
  description = "The name of the AWS Config delivery channel"
  type        = string
  default     = "default"
}

variable "s3_config_bucket" {
  description = "The name of the S3 bucket for AWS Config delivery"
  type        = string
  default     = " "  
}

variable "snapshot_delivery_frequency" {
  description = "The frequency at which AWS Config delivers configuration snapshots"
  type        = string
  default     = "One_Hour"
}

variable "managed_rules" {
  description = "Map of AWS Config managed rules to be created"
  type        = map(object({
    identifier   = string
    description  = optional(string)
    parameters   = optional(string)
  }))
  default     = {}
  
}

