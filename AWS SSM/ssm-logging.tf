resource "aws_s3_bucket" "session_logs" {
  count  = var.enable_session_logging ? 1 : 0
  bucket = "${var.project_name}-session-manager-logs-${var.environment}-${random_id.bucket_suffix.hex}"

  tags = {
    Name        = "${var.project_name}-session-logs"
    Environment = var.environment
    Purpose     = "Session Manager logging"
  }
}

resource "aws_s3_bucket_versioning" "session_logs" {
  count  = var.enable_session_logging ? 1 : 0
  bucket = aws_s3_bucket.session_logs[0].id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_encryption" "session_logs" {
  count  = var.enable_session_logging ? 1 : 0
  bucket = aws_s3_bucket.session_logs[0].id

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.session_manager.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "session_logs" {
  count  = var.enable_session_logging ? 1 : 0
  bucket = aws_s3_bucket.session_logs[0].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "session_logs" {
  count  = var.enable_session_logging ? 1 : 0
  bucket = aws_s3_bucket.session_logs[0].id

  rule {
    id     = "session_logs_lifecycle"
    status = "Enabled"

    expiration {
      days = 90
    }

    noncurrent_version_expiration {
      noncurrent_days = 30
    }
  }
}

# CloudWatch Log Group for Session Manager
resource "aws_cloudwatch_log_group" "session_logs" {
  count             = var.enable_session_logging ? 1 : 0
  name              = "/aws/sessionmanager/${var.project_name}-${var.environment}"
  retention_in_days = 30
  kms_key_id        = aws_kms_key.session_manager.arn

  tags = {
    Name        = "${var.project_name}-session-manager-logs"
    Environment = var.environment
  }
}