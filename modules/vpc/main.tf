resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
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

resource "aws_flow_log" "flow_log" {
  iam_role_arn    = aws_iam_role.vpc_logs_iam_role.arn
  log_destination = aws_cloudwatch_log_group.vpc_logs_group.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.vpc.id
  tags = {
    Name        = "${var.project_name}-${var.env_type}-vpc-flow-logs"
    ProjectName = var.project_name
    EnvType     = var.env_type
  }
}

resource "aws_cloudwatch_log_group" "vpc_logs_group" {
  name              = "/aws/vpc-flow-logs/${aws_vpc.vpc.id}"
  retention_in_days = 14
  tags = {
    Name        = "${var.project_name}-${var.env_type}-vpc-logs-group"
    ProjectName = var.project_name
    EnvType     = var.env_type
  }
}

resource "aws_iam_role" "vpc_logs_iam_role" {
  name = "${var.project_name}-${var.env_type}-vpc-logs-role"
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
    name = "vpc-logs-policy"
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
          Resource = aws_cloudwatch_log_group.vpc_logs_group.arn
        }
      ]
    })
  }
  tags = {
    Name        = "${var.project_name}-${var.env_type}-vpc-logs-role"
    ProjectName = var.project_name
    EnvType     = var.env_type
  }
}

resource "aws_subnet" "private_subnet" {
  count                   = length(local.availability_zones)
  cidr_block              = var.private_subnet_cidrs[count.index]
  availability_zone       = local.availability_zones[count.index]
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = false
  tags = {
    Application = "${var.project_name}-${var.env_type}-subnet-private${count.index}"
    Network     = "Private"
    Name        = "${var.project_name}-${var.env_type}-subnet-private${count.index}-${local.availability_zones[count.index]}"
    ProjectName = var.project_name
    EnvType     = var.env_type
  }
}
