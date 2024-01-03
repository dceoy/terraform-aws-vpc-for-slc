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

resource "aws_vpc" "main" {
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

resource "aws_subnet" "private" {
  count                   = length(local.availability_zones)
  cidr_block              = var.private_subnet_cidrs[count.index]
  availability_zone       = local.availability_zones[count.index]
  vpc_id                  = aws_vpc.main.id
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
  value = aws_vpc.main.id
}

output "private_subnet_ids" {
  description = "Private Subnet IDs"
  value = aws_subnet.private[*].id
}
