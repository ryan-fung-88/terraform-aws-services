# Outputs
output "kms_key_id" {
  description = "KMS key ID for Session Manager encryption"
  value       = aws_kms_key.session_manager.key_id
}

output "kms_key_arn" {
  description = "KMS key ARN for Session Manager encryption"
  value       = aws_kms_key.session_manager.arn
}

output "instance_profile_name" {
  description = "Instance profile name for EC2 instances"
  value       = aws_iam_instance_profile.session_manager_instance_profile.name
}

output "instance_profile_arn" {
  description = "Instance profile ARN for EC2 instances"
  value       = aws_iam_instance_profile.session_manager_instance_profile.arn
}

output "vpc_endpoint_ids" {
  description = "VPC endpoint IDs for Session Manager"
  value = {
    ssm         = aws_vpc_endpoint.ssm.id
    ssmmessages = aws_vpc_endpoint.ssmmessages.id
    ec2messages = aws_vpc_endpoint.ec2messages.id
  }
}

output "s3_bucket_name" {
  description = "S3 bucket name for session logs"
  value       = var.enable_session_logging ? aws_s3_bucket.session_logs[0].bucket : null
}

output "cloudwatch_log_group_name" {
  description = "CloudWatch log group name for session logs"
  value       = var.enable_session_logging ? aws_cloudwatch_log_group.session_logs[0].name : null
}

output "user_policy_arn" {
  description = "IAM policy ARN for Session Manager users"
  value       = aws_iam_policy.session_manager_user_policy.arn
}

output "user_group_name" {
  description = "IAM group name for Session Manager users"
  value       = aws_iam_group.session_manager_users.name
}