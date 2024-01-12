resource "aws_ssm_document" "session" {
  name            = local.ssm_session_document_name
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
      kmsKeyId                    = aws_kms_key.session.arn
      idleSessionTimeout          = "20"
      runAsEnabled                = true
      runAsDefaultUser            = "ec2-user"
      shellProfile = {
        linux = "cd && exec bash -l"
      }
    }
  })
  target_type = "/AWS::SSM::ManagedInstance"
  tags = {
    Name        = local.ssm_session_document_name
    ProjectName = var.project_name
    EnvType     = var.env_type
  }
}

resource "aws_cloudwatch_log_group" "session" {
  name              = local.ssm_session_cloudwatch_log_group_name
  retention_in_days = 14
  kms_key_id        = aws_kms_key.session.arn
  tags = {
    Name        = "${local.ssm_session_document_name}-log-group"
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
          ArnEquals = {
            "kms:EncryptionContext:aws:logs:arn" = "arn:aws:logs:${local.region}:${local.account_id}:log-group:${local.ssm_session_cloudwatch_log_group_name}"
          }
        }
      }
    ]
  })
  tags = {
    Name        = "${local.ssm_session_document_name}-log-kms-key"
    ProjectName = var.project_name
    EnvType     = var.env_type
  }
}

resource "aws_kms_alias" "session" {
  name          = "alias/${aws_kms_key.session.tags.Name}"
  target_key_id = aws_kms_key.session.arn
}

# tfsec:ignore:aws-iam-no-policy-wildcards
resource "aws_iam_policy" "session" {
  name = "${local.ssm_session_document_name}-log-policy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = ["kms:Decrypt"],
        Effect   = "Allow",
        Resource = [aws_kms_key.session.arn]
      },
      {
        Action = [
          # "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ],
        Effect   = "Allow",
        Resource = ["arn:aws:logs:${local.region}:${local.account_id}:log-group:*"]
      }
    ]
  })
  path = "/"
  tags = {
    Name        = "${local.ssm_session_document_name}-log-policy"
    ProjectName = var.project_name
    EnvType     = var.env_type
  }
}

resource "aws_iam_role_policy_attachment" "session" {
  role       = element(split("/", var.ec2_instance_role_arn), 1)
  policy_arn = aws_iam_policy.session.arn
}

resource "aws_iam_role" "client" {
  name = "${local.ssm_session_document_name}-start-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = ["sts:AssumeRole"]
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
  inline_policy {
    name = "${local.ssm_session_document_name}-start-policy"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action = ["ssm:StartSession"]
          Effect = "Allow"
          Resource = [
            var.ec2_instance_role_arn,
            aws_ssm_document.session.arn
          ]
          Condition = {
            BoolIfExists = {
              "ssm:SessionDocumentAccessCheck" = "true"
            }
          }
        }
      ]
    })
  }
  path = "/"
  tags = {
    Name        = "${local.ssm_session_document_name}-start-role"
    ProjectName = var.project_name
    EnvType     = var.env_type
  }
}
