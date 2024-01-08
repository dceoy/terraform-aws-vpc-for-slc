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

resource "aws_flow_log" "flow_log" {
  iam_role_arn    = aws_iam_role.flow_log.arn
  log_destination = aws_cloudwatch_log_group.flow_log.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.main.id
  tags = {
    Name        = "${var.project_name}-${var.env_type}-vpc-flow-log"
    ProjectName = var.project_name
    EnvType     = var.env_type
  }
}

resource "aws_cloudwatch_log_group" "flow_log" {
  name              = "/aws/vpc-flow-logs/${aws_vpc.main.id}"
  retention_in_days = 14
  tags = {
    Name        = "${var.project_name}-${var.env_type}-vpc-flow-log-group"
    ProjectName = var.project_name
    EnvType     = var.env_type
  }
}

resource "aws_iam_role" "flow_log" {
  name = "${var.project_name}-${var.env_type}-vpc-flow-log-role"
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
          Resource = [aws_cloudwatch_log_group.flow_log.arn]
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
