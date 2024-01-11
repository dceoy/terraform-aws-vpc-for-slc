resource "aws_ssm_document" "session" {
  name            = "${var.project_name}-${var.env_type}-ssm-session-document"
  document_type   = "Session"
  document_format = "JSON"
  content = jsonencode({
    schemaVersion = "1.0"
    description   = "Document to hold regional settings for Session Manager"
    sessionType   = "Standard_Stream"
    inputs = {
      cloudWatchLogGroupName      = aws_cloudwatch_log_group.session.name
      cloudWatchEncryptionEnabled = true
      cloudWatchStreamingEnabled  = true
      idleSessionTimeout          = 20
      # s3BucketName = "DOC-EXAMPLE-BUCKET"
      # s3KeyPrefix = "MyBucketPrefix"
      # s3EncryptionEnabled = true
      # kmsKeyId = "MyKMSKeyID"
      # runAsEnabled = false
      # runAsDefaultUser = "MyDefaultRunAsUser"
      # shellProfile = {
      #   windows = "example commands"
      #   linux = "example commands"
      # }
    }
  })
  tags = {
    Name        = "${var.project_name}-${var.env_type}-ssm-session-document"
    ProjectName = var.project_name
    EnvType     = var.env_type
  }
}

resource "aws_cloudwatch_log_group" "session" {
  name              = "/aws/ssm/session/${var.project_name}-${var.env_type}-ssm"
  retention_in_days = 14
  kms_key_id        = aws_kms_key.session.arn
  tags = {
    Name        = "${var.project_name}-${var.env_type}-ssm-session-log-group"
    ProjectName = var.project_name
    EnvType     = var.env_type
  }
}

resource "aws_kms_key" "session" {
  description             = "KMS key for encrypting CloudWatch Logs"
  deletion_window_in_days = 14
  enable_key_rotation     = true
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "Enable IAM User Permissions",
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${local.account_id}:root"
        },
        Action   = "kms:*",
        Resource = "*"
      },
      {
        Sid    = "Allow CloudWatch to encrypt logs",
        Effect = "Allow",
        Principal = {
          Service = "logs.${local.region}.amazonaws.com"
        },
        Action = [
          "kms:Encrypt*",
          "kms:Decrypt*",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:Describe*"
        ],
        Resource = "*",
        Condition = {
          ArnLike = {
            "kms:EncryptionContext:aws:logs:arn" = "arn:aws:logs:${local.region}:${local.account_id}:log-group:*"
          }
        }
      }
    ]
  })
  tags = {
    Name        = "${var.project_name}-${var.env_type}-ssm-session-log-kms-key"
    ProjectName = var.project_name
    EnvType     = var.env_type
  }
}

resource "aws_kms_alias" "session" {
  name          = "alias/${aws_kms_key.session.tags.Name}"
  target_key_id = aws_kms_key.session.arn
}
