resource "aws_kms_key" "custom" {
  count                   = var.create_kms_key ? 1 : 0
  description             = "KMS key for CloudWatch Logs"
  deletion_window_in_days = var.kms_key_deletion_window_in_days
  enable_key_rotation     = true
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowKMSAccess"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${local.account_id}:root"
        }
        Action   = ["kms:*"]
        Resource = "*"
      },
      {
        Sid    = "AllowCloudWatchLogsToEncrypt"
        Effect = "Allow"
        Principal = {
          Service = "logs.${local.region}.amazonaws.com"
        }
        Action = [
          "kms:Encrypt*",
          "kms:Decrypt*",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:Describe*"
        ]
        Resource = "*"
        Condition = {
          ArnLike = {
            "kms:EncryptionContext:aws:logs:arn" = "arn:aws:logs:${local.region}:${local.account_id}:log-group:*"
          }
        }
      }
    ]
  })
  tags = {
    Name       = "${var.system_name}-${var.env_type}-kms-key"
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}

resource "aws_kms_alias" "custom" {
  count         = length(aws_kms_key.custom) > 0 ? 1 : 0
  name          = "alias/${aws_kms_key.custom[count.index].tags.Name}"
  target_key_id = aws_kms_key.custom[count.index].arn
}
