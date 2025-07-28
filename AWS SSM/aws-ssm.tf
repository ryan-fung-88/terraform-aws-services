locals {
  type = var.type != null ? var.type : (
    length(var.values) > 0 ? "StringList" : (
      can(tostring(var.value)) ? (try(tobool(var.secure_type) == true, false) ? "SecureString" : "String") : "StringList"
  ))
  secure_type = local.type == "SecureString"
  list_type   = local.type == "StringList"
  string_type = local.type == "String"
  value       = local.list_type ? (length(var.values) > 0 ? jsonencode(var.values) : var.value) : var.value
}

# Data sources
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_vpc" "main" {
  id = var.vpc_id
}

resource "aws_ssm_parameter" "this" {
  name        = "${var.project_name}-session-manager-parameter-${var.environment}"
  type        = local.type
  description = "Parameter for Session Manager configuration"

  value          = local.secure_type ? local.value : null
  insecure_value = local.list_type || local.string_type ? local.value : null

  key_id          = local.secure_type ? aws_kms_key.session_manager.id : null
  allowed_pattern = var.allowed_pattern
}

# IAM Role for EC2 instances
resource "aws_iam_role" "session_manager_instance_role" {
  name = "${var.project_name}-session-manager-instance-role-${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name        = "${var.project_name}-session-manager-instance-role"
    Environment = var.environment
  }
}

# Attach AWS managed policy for Session Manager
resource "aws_iam_role_policy_attachment" "session_manager_instance_policy" {
  role       = aws_iam_role.session_manager_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Custom policy for enhanced Session Manager functionality
resource "aws_iam_role_policy" "session_manager_logging" {
  count = var.enable_session_logging ? 1 : 0
  name  = "${var.project_name}-session-manager-logging-${var.environment}"
  role  = aws_iam_role.session_manager_instance_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams",
          "logs:PutLogEvents",
          "logs:PutRetentionPolicy"
        ]
        Resource = "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/sessionmanager/*"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetEncryptionConfiguration"
        ]
        Resource = var.enable_session_logging ? "${aws_s3_bucket.session_logs[0].arn}/*" : ""
      },
      {
        Effect = "Allow"
        Action = [
          "kms:Decrypt",
          "kms:GenerateDataKey"
        ]
        Resource = aws_kms_key.session_manager.arn
      }
    ]
  })
}

# Instance profile
resource "aws_iam_instance_profile" "session_manager_instance_profile" {
  name = "${var.project_name}-session-manager-instance-profile-${var.environment}"
  role = aws_iam_role.session_manager_instance_role.name

  tags = {
    Name        = "${var.project_name}-session-manager-instance-profile"
    Environment = var.environment
  }
}

# Session Manager preferences
resource "aws_ssm_document" "session_manager_preferences" {
  name          = "${var.project_name}-SessionManagerRunShell-${var.environment}"
  document_type = "Session"
  document_format = "JSON"

  content = jsonencode({
    schemaVersion = "1.0"
    description   = "Document to hold regional settings for Session Manager"
    sessionType   = "Standard_Stream"
    inputs = {
      s3BucketName                = var.enable_session_logging ? aws_s3_bucket.session_logs[0].bucket : ""
      s3KeyPrefix                 = "session-logs/"
      s3EncryptionEnabled         = var.enable_session_logging
      cloudWatchLogGroupName      = var.enable_session_logging ? aws_cloudwatch_log_group.session_logs[0].name : ""
      cloudWatchEncryptionEnabled = var.enable_session_logging
      kmsKeyId                    = aws_kms_key.session_manager.arn
      idleSessionTimeout          = var.session_timeout
      maxSessionDuration          = "3600"
      runAsEnabled                = false
      runAsDefaultUser            = ""
      shellProfile = {
        windows = "date"
        linux   = "PS1=\"[\\u@\\h \\W]\\$ \""
      }
    }
  })

  tags = {
    Name        = "${var.project_name}-session-manager-preferences"
    Environment = var.environment
  }
}

# IAM policies for users/roles that need Session Manager access
resource "aws_iam_policy" "session_manager_user_policy" {
  name        = "${var.project_name}-session-manager-user-policy-${var.environment}"
  description = "Policy for users to access Session Manager"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ssm:StartSession"
        ]
        Resource = [
          "arn:aws:ec2:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:instance/*"
        ]
        Condition = {
          StringEquals = {
            "ssm:resourceTag/Environment" = var.environment
            "ssm:resourceTag/Project"     = var.project_name
          }
        }
      },
      {
        Effect = "Allow"
        Action = [
          "ssm:StartSession"
        ]
        Resource = [
          "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:document/${aws_ssm_document.session_manager_preferences.name}"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "ssm:DescribeSessions",
          "ssm:GetConnectionStatus",
          "ssm:DescribeInstanceInformation",
          "ssm:DescribeInstanceProperties",
          "ec2:DescribeInstances"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ssm:TerminateSession",
          "ssm:ResumeSession"
        ]
        Resource = [
          "arn:aws:ssm:*:*:session/$${aws:username}-*"
        ]
      }
    ]
  })

  tags = {
    Name        = "${var.project_name}-session-manager-user-policy"
    Environment = var.environment
  }
}

# Example user group for Session Manager access
resource "aws_iam_group" "session_manager_users" {
  name = "${var.project_name}-session-manager-users-${var.environment}"
}

resource "aws_iam_group_policy_attachment" "session_manager_users" {
  group      = aws_iam_group.session_manager_users.name
  policy_arn = aws_iam_policy.session_manager_user_policy.arn
}

