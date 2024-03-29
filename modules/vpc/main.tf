resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Application = local.vpc_name
    Network     = "Public"
    Name        = local.vpc_name
    SystemName  = var.system_name
    EnvType     = var.env_type
  }
}

resource "aws_cloudwatch_log_group" "flow_log" {
  count             = var.enable_vpc_flow_log ? 1 : 0
  name              = local.vpc_flow_log_cloudwatch_log_group_name
  retention_in_days = 14
  kms_key_id        = aws_kms_key.flow_log[count.index].arn
  tags = {
    Name       = local.vpc_flow_log_cloudwatch_log_group_name
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}

resource "aws_kms_key" "flow_log" {
  count                   = var.enable_vpc_flow_log ? 1 : 0
  description             = "KMS key for encrypting CloudWatch Logs"
  deletion_window_in_days = 30
  enable_key_rotation     = true
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${local.account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Sid    = "Allow CloudWatch to encrypt logs"
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
          ArnEquals = {
            "kms:EncryptionContext:aws:logs:arn" = "arn:aws:logs:${local.region}:${local.account_id}:log-group:${local.vpc_flow_log_cloudwatch_log_group_name}"
          }
        }
      }
    ]
  })
  tags = {
    Name       = "${local.vpc_flow_log_cloudwatch_log_group_name}-kms-key"
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}

resource "aws_kms_alias" "flow_log" {
  count         = length(aws_kms_key.flow_log) > 0 ? 1 : 0
  name          = "alias/${aws_kms_key.flow_log[count.index].tags.Name}"
  target_key_id = aws_kms_key.flow_log[count.index].key_id
}

resource "aws_flow_log" "flow_log" {
  count           = length(aws_cloudwatch_log_group.flow_log) > 0 ? 1 : 0
  iam_role_arn    = aws_iam_role.flow_log[count.index].arn
  log_destination = aws_cloudwatch_log_group.flow_log[count.index].arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.main.id
  tags = {
    Name       = "${aws_vpc.main.tags.Name}-flow-log"
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}

resource "aws_iam_role" "flow_log" {
  count = length(aws_cloudwatch_log_group.flow_log) > 0 ? 1 : 0
  name  = "${aws_cloudwatch_log_group.flow_log[count.index].name}-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = ["sts:AssumeRole"]
        Effect = "Allow"
        Principal = {
          Service = "vpc-flow-logs.amazonaws.com"
        }
      }
    ]
  })
  inline_policy {
    name = "${aws_cloudwatch_log_group.flow_log[count.index].name}-role-policy"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Effect   = "Allow"
          Action   = ["kms:Decrypt"]
          Resource = [aws_kms_key.flow_log[count.index].arn]
        },
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
          Resource = ["${aws_cloudwatch_log_group.flow_log[count.index].arn}:*"]
        }
      ]
    })
  }
  path = "/"
  tags = {
    Name       = "${aws_cloudwatch_log_group.flow_log[count.index].name}-role"
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}
