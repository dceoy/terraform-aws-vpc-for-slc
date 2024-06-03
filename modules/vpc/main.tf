# tfsec:ignore:aws-ec2-require-vpc-flow-logs-for-all-vpcs
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

resource "aws_flow_log" "log" {
  count                = length(aws_iam_role.log) > 0 ? 1 : 0
  vpc_id               = aws_vpc.main.id
  log_destination_type = "s3"
  log_destination      = "arn:aws:s3:::${var.vpc_flow_log_s3_bucket_id}/${var.system_name}/${var.env_type}/vpc/${aws_vpc.main.tags.Name}"
  iam_role_arn         = aws_iam_role.log[count.index].arn
  traffic_type         = "ALL"
  tags = {
    Name       = "${aws_vpc.main.tags.Name}-flow-log"
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}

resource "aws_iam_role" "log" {
  count = var.vpc_flow_log_s3_bucket_id != null && var.vpc_flow_log_s3_iam_policy_arn != null ? 1 : 0
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
  managed_policy_arns = [var.vpc_flow_log_s3_iam_policy_arn]
  path                = "/"
  tags = {
    Name       = "${aws_vpc.main.tags.Name}-flow-log-role"
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}
