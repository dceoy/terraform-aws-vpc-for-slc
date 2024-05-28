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

resource "aws_vpc_ipv4_cidr_block_association" "main" {
  for_each   = toset(var.vpc_secondary_cidr_blocks)
  vpc_id     = aws_vpc.main.id
  cidr_block = each.key
}

resource "aws_cloudwatch_log_group" "flow_log" {
  count             = var.enable_vpc_flow_log ? 1 : 0
  name              = local.vpc_flow_log_cloudwatch_log_group_name
  retention_in_days = var.cloudwatch_logs_retention_in_days
  kms_key_id        = var.kms_key_arn
  tags = {
    Name       = local.vpc_flow_log_cloudwatch_log_group_name
    SystemName = var.system_name
    EnvType    = var.env_type
  }
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
  name  = "${aws_vpc.main.tags.Name}-flow-log-role"
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
    name = "${aws_vpc.main.tags.Name}-flow-log-role-policy"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = concat(
        [
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
  }
  path = "/"
  tags = {
    Name       = "${aws_vpc.main.tags.Name}-flow-log-role"
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}
