resource "aws_ssm_document" "session" {
  count           = var.create_ssm_session_document ? 1 : 0
  name            = local.ssm_session_document_name
  document_type   = "Session"
  document_format = "JSON"
  target_type     = "/AWS::SSM::ManagedInstance"
  content = jsonencode({
    schemaVersion = "1.0"
    description   = "Document to hold regional settings for Session Manager"
    sessionType   = "Port"
    parameters = {
      linuxShellProfile = {
        type        = "String"
        description = "The shell profile to use for Linux instances"
        default     = "exec bash -l"
      }
      portNumber = {
        type           = "String"
        description    = "(Optional) Port number of SSH server on the instance"
        allowedPattern = "^([1-9]|[1-9][0-9]{1,3}|[1-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|655[0-2][0-9]|6553[0-5])$"
        default        = tostring(var.ssm_session_ssh_port_number)
      }
    }
    properties = {
      portNumber = "{{ portNumber }}"
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
