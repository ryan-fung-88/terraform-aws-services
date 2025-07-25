variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

variable "organization_id" {
  description = "The ID of the AWS Organization. If not provided, the module will use the current organization ID."
  type        = string
  default     = null
}

variable "scps" {
  description = "A map of SCPs to create. Each SCP should have a name, description, policy content, and tags."
  type = map(object({
    name           = string
    description    = string
    policy_content = string
    tags           = map(string)
  }))
  default = {}
}

variable "target_ou_id" {
  description = "The ID of the Organizational Unit (OU) to attach the SCP to."
  type        = string
  default     = null
}