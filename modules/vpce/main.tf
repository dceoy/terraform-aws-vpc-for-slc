resource "aws_vpc_endpoint" "s3_gateway" {
  vpc_id            = local.vpc_id
  service_name      = "com.amazonaws.${local.region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = var.private_route_table_ids
  tags = {
    Name        = "${var.project_name}-${var.env_type}-vpce-gw-s3"
    ProjectName = var.project_name
    EnvType     = var.env_type
  }
}

resource "aws_vpc_endpoint" "dynamodb_gateway" {
  vpc_id            = local.vpc_id
  service_name      = "com.amazonaws.${local.region}.dynamodb"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = var.private_route_table_ids
  tags = {
    Name        = "${var.project_name}-${var.env_type}-vpce-gw-dynamodb"
    ProjectName = var.project_name
    EnvType     = var.env_type
  }
}

resource "aws_vpc_endpoint" "ec2_interface" {
  vpc_id              = local.vpc_id
  service_name        = "com.amazonaws.${local.region}.ec2"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  security_group_ids  = var.security_group_ids
  subnet_ids          = var.private_subnet_ids
  tags = {
    Name        = "${var.project_name}-${var.env_type}-vpce-if-ec2"
    ProjectName = var.project_name
    EnvType     = var.env_type
  }
}

resource "aws_vpc_endpoint" "ec2_messages_interface" {
  vpc_id              = local.vpc_id
  service_name        = "com.amazonaws.${local.region}.ec2messages"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  security_group_ids  = var.security_group_ids
  subnet_ids          = var.private_subnet_ids
  tags = {
    Name        = "${var.project_name}-${var.env_type}-vpce-if-ec2messages"
    ProjectName = var.project_name
    EnvType     = var.env_type
  }
}

resource "aws_vpc_endpoint" "ssm_interface" {
  vpc_id              = local.vpc_id
  service_name        = "com.amazonaws.${local.region}.ssm"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  security_group_ids  = var.security_group_ids
  subnet_ids          = var.private_subnet_ids
  tags = {
    Name        = "${var.project_name}-${var.env_type}-vpce-if-ssm"
    ProjectName = var.project_name
    EnvType     = var.env_type
  }
}

resource "aws_vpc_endpoint" "ssm_messages_interface" {
  vpc_id              = local.vpc_id
  service_name        = "com.amazonaws.${local.region}.ssmmessages"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  security_group_ids  = var.security_group_ids
  subnet_ids          = var.private_subnet_ids
  tags = {
    Name        = "${var.project_name}-${var.env_type}-vpce-if-ssmmessages"
    ProjectName = var.project_name
    EnvType     = var.env_type
  }
}

resource "aws_vpc_endpoint" "secrets_manager_interface" {
  vpc_id              = local.vpc_id
  service_name        = "com.amazonaws.${local.region}.secretsmanager"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  security_group_ids  = var.security_group_ids
  subnet_ids          = var.private_subnet_ids
  tags = {
    Name        = "${var.project_name}-${var.env_type}-vpce-if-secretsmanager"
    ProjectName = var.project_name
    EnvType     = var.env_type
  }
}

resource "aws_vpc_endpoint" "ecr_dkr_interface" {
  vpc_id              = local.vpc_id
  service_name        = "com.amazonaws.${local.region}.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  security_group_ids  = var.security_group_ids
  subnet_ids          = var.private_subnet_ids
  tags = {
    Name        = "${var.project_name}-${var.env_type}-vpce-if-ecr-dkr"
    ProjectName = var.project_name
    EnvType     = var.env_type
  }
}

resource "aws_vpc_endpoint" "ecr_api_interface" {
  vpc_id              = local.vpc_id
  service_name        = "com.amazonaws.${local.region}.ecr.api"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  security_group_ids  = var.security_group_ids
  subnet_ids          = var.private_subnet_ids
  tags = {
    Name        = "${var.project_name}-${var.env_type}-vpce-if-ecr-api"
    ProjectName = var.project_name
    EnvType     = var.env_type
  }
}

resource "aws_vpc_endpoint" "ecs_interface" {
  vpc_id              = local.vpc_id
  service_name        = "com.amazonaws.${local.region}.ecs"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  security_group_ids  = var.security_group_ids
  subnet_ids          = var.private_subnet_ids
  tags = {
    Name        = "${var.project_name}-${var.env_type}-vpce-if-ecs"
    ProjectName = var.project_name
    EnvType     = var.env_type
  }
}

resource "aws_vpc_endpoint" "ecs_agent_interface" {
  vpc_id              = local.vpc_id
  service_name        = "com.amazonaws.${local.region}.ecs-agent"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  security_group_ids  = var.security_group_ids
  subnet_ids          = var.private_subnet_ids
  tags = {
    Name        = "${var.project_name}-${var.env_type}-vpce-if-ecs-agent"
    ProjectName = var.project_name
    EnvType     = var.env_type
  }
}

resource "aws_vpc_endpoint" "ecs_telemetry_interface" {
  vpc_id              = local.vpc_id
  service_name        = "com.amazonaws.${local.region}.ecs-telemetry"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  security_group_ids  = var.security_group_ids
  subnet_ids          = var.private_subnet_ids
  tags = {
    Name        = "${var.project_name}-${var.env_type}-vpce-if-ecs-telemetry"
    ProjectName = var.project_name
    EnvType     = var.env_type
  }
}

resource "aws_vpc_endpoint" "logs_interface" {
  vpc_id              = local.vpc_id
  service_name        = "com.amazonaws.${local.region}.logs"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  security_group_ids  = var.security_group_ids
  subnet_ids          = var.private_subnet_ids
  tags = {
    Name        = "${var.project_name}-${var.env_type}-vpce-if-logs"
    ProjectName = var.project_name
    EnvType     = var.env_type
  }
}
