resource "aws_ssm_document" "session" {
  count           = var.create_ssm_session_document ? 1 : 0
  name            = local.ssm_session_document_name
  document_type   = "Session"
  document_format = "JSON"
  target_type     = "/AWS::SSM::ManagedInstance"
  content = jsonencode({
    schemaVersion = "1.0"
    description   = "Document to hold regional settings for Session Manager"
    sessionType   = "Standard_Stream"
    parameters = {
      linuxShellProfile = {
        type        = "String"
        description = "The shell profile to use for Linux instances"
        default     = "exec bash -l"
      }
    }
    inputs = {
      s3BucketName        = var.ssm_session_log_s3_bucket_id
      s3KeyPrefix         = var.ssm_s3_key_prefix
      s3EncryptionEnabled = true
      kmsKeyId            = var.kms_key_arn
      idleSessionTimeout  = tostring(var.ssm_session_idle_session_timeout)
      runAsEnabled        = true
      runAsDefaultUser    = "ec2-user"
      shellProfile = {
        linux = "{{ linuxShellProfile }}"
      }
    }
  })
  tags = {
    Name       = local.ssm_session_document_name
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}

resource "aws_iam_policy" "server" {
  count       = length(aws_ssm_document.session) > 0 ? 1 : 0
  name        = "${var.system_name}-${var.env_type}-ssm-session-server-iam-policy"
  description = "SSM session server IAM policy"
  path        = "/"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = concat(
      [
        {
          Sid      = "SSMSessionLogsGetS3BucketAcl"
          Effect   = "Allow"
          Action   = ["s3:GetBucketAcl"]
          Resource = ["arn:aws:s3:::${var.ssm_session_log_s3_bucket_id}"]
        },
        {
          Sid      = "SSMSessionLogsPutS3Objects"
          Effect   = "Allow"
          Action   = ["s3:PutObject"]
          Resource = ["arn:aws:s3:::${var.ssm_session_log_s3_bucket_id}/${var.ssm_s3_key_prefix}/*"]
          Condition = {
            StringEquals = {
              "s3:x-amz-acl"      = "bucket-owner-full-control"
              "AWS:SourceAccount" = local.account_id
            }
          }
        }
      ],
      (
        var.kms_key_arn != null ? [
          {
            Sid    = "SSMSessionLogsEncryptAndDecryptS3Objects"
            Effect = "Allow"
            Action = [
              "kms:Decrypt",
              "kms:GenerateDataKey"
            ]
            Resource = var.kms_key_arn
            Condition = {
              StringEquals = {
                "AWS:SourceAccount" = local.account_id
              }
            }
          }
        ] : []
      )
    )
  })
  tags = {
    Name       = "${var.system_name}-${var.env_type}-ssm-session-server-iam-policy"
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}

resource "aws_iam_policy" "client" {
  count       = length(aws_ssm_document.session) > 0 ? 1 : 0
  name        = "${var.system_name}-${var.env_type}-ssm-session-client-iam-policy"
  description = "SSM session client IAM policy"
  path        = "/"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = concat(
      [
        {
          Effect   = "Allow"
          Action   = ["ssm:StartSession"]
          Resource = [for d in aws_ssm_document.session : d.arn]
          Condition = {
            BoolIfExists = {
              "ssm:SessionDocumentAccessCheck" = "true"
            }
          }
        }
      ],
      (
        var.kms_key_arn != null ? [
          {
            Effect   = "Allow"
            Action   = ["kms:GenerateDataKey"]
            Resource = [var.kms_key_arn]
          }
        ] : []
      )
    )
  })
  tags = {
    Name       = "${var.system_name}-${var.env_type}-ssm-session-client-iam-policy"
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}
