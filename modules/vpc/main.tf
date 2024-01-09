resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Application = "${var.project_name}-${var.env_type}-vpc"
    Network     = "Public"
    Name        = "${var.project_name}-${var.env_type}-vpc"
    ProjectName = var.project_name
    EnvType     = var.env_type
  }
}

resource "aws_cloudwatch_log_group" "flow_log" {
  count             = var.enable_vpc_flow_log ? 1 : 0
  name              = "/aws/vpc/flow-logs/${aws_vpc.main.id}"
  retention_in_days = 14
  kms_key_id        = aws_kms_key.flow_log[0].arn
  tags = {
    Name        = "${var.project_name}-${var.env_type}-vpc-flow-log-group"
    ProjectName = var.project_name
    EnvType     = var.env_type
  }
}

resource "aws_flow_log" "flow_log" {
  count           = length(aws_cloudwatch_log_group.flow_log) > 0 ? 1 : 0
  iam_role_arn    = aws_iam_role.flow_log[0].arn
  log_destination = aws_cloudwatch_log_group.flow_log[0].arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.main.id
  tags = {
    Name        = "${var.project_name}-${var.env_type}-vpc-flow-log"
    ProjectName = var.project_name
    EnvType     = var.env_type
  }
}

resource "aws_iam_role" "flow_log" {
  count = length(aws_cloudwatch_log_group.flow_log) > 0 ? 1 : 0
  name  = "${var.project_name}-${var.env_type}-vpc-flow-log-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = ["sts:AssumeRole"],
        Effect = "Allow",
        Principal = {
          Service = "vpc-flow-logs.amazonaws.com"
        }
      }
    ]
  })
  inline_policy {
    name = "${var.project_name}-${var.env_type}-vpc-flow-log-role-policy"
    policy = jsonencode({
      Version = "2012-10-17",
      Statement = [
        {
          Action = [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents",
            "logs:DescribeLogGroups",
            "logs:DescribeLogStreams"
          ],
          Effect   = "Allow",
          Resource = [aws_cloudwatch_log_group.flow_log[0].arn]
        }
      ]
    })
  }
  path = "/"
  tags = {
    Name        = "${var.project_name}-${var.env_type}-vpc-flow-log-role"
    ProjectName = var.project_name
    EnvType     = var.env_type
  }
}

resource "aws_kms_key" "flow_log" {
  count                   = var.enable_vpc_flow_log ? 1 : 0
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
    Name        = "${var.project_name}-${var.env_type}-vpc-flow-log-kms-key"
    ProjectName = var.project_name
    EnvType     = var.env_type
  }
}

resource "aws_kms_alias" "flow_log" {
  count         = length(aws_kms_key.flow_log) > 0 ? 1 : 0
  name          = "alias/${var.project_name}-${var.env_type}-vpc-flow-log-kms-key"
  target_key_id = aws_kms_key.flow_log[0].key_id
}
