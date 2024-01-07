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

resource "aws_subnet" "private_subnets" {
  count                   = length(local.private_subnet_azs)
  cidr_block              = var.private_subnet_cidrs[count.index]
  availability_zone       = local.private_subnet_azs[count.index]
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = false
  tags = {
    Application = "${var.project_name}-${var.env_type}-subnet-private${count.index}"
    Network     = "Private"
    Name        = "${var.project_name}-${var.env_type}-subnet-private${count.index}-${local.private_subnet_azs[count.index]}"
    ProjectName = var.project_name
    EnvType     = var.env_type
  }
}

resource "aws_route_table" "private_route_tables" {
  count  = length(local.private_subnet_azs)
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name        = "${var.project_name}-${var.env_type}-rtb-private${count.index}"
    ProjectName = var.project_name
    EnvType     = var.env_type
  }
}

resource "aws_route_table_association" "private_route_table_associations" {
  count          = length(local.private_subnet_azs)
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_route_tables[count.index].id
}

resource "aws_vpc_endpoint" "s3_gateway_endpoint" {
  vpc_id            = aws_vpc.vpc.id
  service_name      = "com.amazonaws.${local.region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = aws_route_table.private_route_tables[*].id
  tags = {
    Name        = "${var.project_name}-${var.env_type}-vpce-gw-s3"
    ProjectName = var.project_name
    EnvType     = var.env_type
  }
}

resource "aws_vpc_endpoint" "dynamodb_gateway_endpoint" {
  vpc_id            = aws_vpc.vpc.id
  service_name      = "com.amazonaws.${local.region}.dynamodb"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = aws_route_table.private_route_tables[*].id
  tags = {
    Name        = "${var.project_name}-${var.env_type}-vpce-gw-dynamodb"
    ProjectName = var.project_name
    EnvType     = var.env_type
  }
}

resource "aws_subnet" "public_subnets" {
  count                   = length(local.public_subnet_azs)
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = local.public_subnet_azs[count.index]
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = true
  tags = {
    Application = "${var.project_name}-${var.env_type}-subnet-public${count.index}"
    Network     = "Public"
    Name        = "${var.project_name}-${var.env_type}-subnet-public${count.index}-${local.public_subnet_azs[count.index]}"
    ProjectName = var.project_name
    EnvType     = var.env_type
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name        = "${var.project_name}-${var.env_type}-rtb-public"
    ProjectName = var.project_name
    EnvType     = var.env_type
  }
}

resource "aws_route_table_association" "public_route_table_associations" {
  count          = length(local.public_subnet_azs)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Application = "${var.project_name}-${var.env_type}-vpc"
    Network     = "Public"
    Name        = "${var.project_name}-${var.env_type}-igw"
    ProjectName = var.project_name
    EnvType     = var.env_type
  }
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_route_table.id
  gateway_id             = aws_internet_gateway.internet_gateway.id
  destination_cidr_block = "0.0.0.0/0"
}
