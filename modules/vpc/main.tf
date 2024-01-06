variable "project_name" {
  description = "Project name"
  type        = string
  default     = "slc"
}

variable "env_type" {
  description = "Environment type"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for the private subnets"
  type        = list(string)
  default     = ["10.0.0.0/24", "10.0.16.0/24", "10.0.32.0/24"]
}

data "aws_availability_zones" "az" {
  state = "available"
}

locals {
  availability_zones = slice(
    data.aws_availability_zones.az.names,
    0,
    length(var.private_subnet_cidrs)
  )
}

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

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.vpc.id
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = aws_subnet.private_subnet[*].id
}

output "vpc_flow_log" {
  description = "VPC flow log"
  value       = aws_flow_log.flow_log.id
}

output "vpc_flow_log_group" {
  description = "VPC flow log group"
  value       = aws_cloudwatch_log_group.vpc_logs_group.name
}

output "vpc_flow_log_iam_role" {
  description = "VPC flow log IAM role"
  value       = aws_iam_role.vpc_logs_iam_role.name
}
