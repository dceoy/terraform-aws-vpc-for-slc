resource "aws_ssm_document" "session" {
  name            = local.ssm_session_document_name
  document_type   = "Session"
  document_format = "JSON"
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
      cloudWatchLogGroupName      = aws_cloudwatch_log_group.session.name
      cloudWatchEncryptionEnabled = true
      cloudWatchStreamingEnabled  = true
      kmsKeyId                    = var.kms_key_arn
      idleSessionTimeout          = tostring(var.idle_session_timeout)
      runAsEnabled                = true
      runAsDefaultUser            = "ec2-user"
      shellProfile = {
        linux = "{{ linuxShellProfile }}"
      }
    }
  })
  target_type = "/AWS::SSM::ManagedInstance"
  tags = {
    Name       = local.ssm_session_document_name
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}

resource "aws_cloudwatch_log_group" "session" {
  name              = local.ssm_session_cloudwatch_log_group_name
  retention_in_days = var.cloudwatch_logs_retention_in_days
  kms_key_id        = var.kms_key_arn
  tags = {
    Name       = local.ssm_session_cloudwatch_log_group_name
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}

resource "aws_iam_policy" "session" {
  name = "${aws_ssm_document.session.name}-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["logs:DescribeLogGroups"]
        Resource = ["arn:aws:logs:${local.region}:${local.account_id}:log-group:*"]
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams"
        ]
        Resource = ["${aws_cloudwatch_log_group.session.arn}:*"]
      },
      {
        Effect   = "Allow"
        Action   = ["kms:Decrypt"]
        Resource = compact([var.kms_key_arn])
      }
    ]
  })
  path = "/"
  tags = {
    Name       = "${aws_ssm_document.session.name}-policy"
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}
