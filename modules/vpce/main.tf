resource "aws_vpc_endpoint" "ec2_interface" {
  vpc_id              = local.vpc_id
  service_name        = "com.amazonaws.${local.region}.ec2"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  security_group_ids  = var.security_group_ids
  subnet_ids          = var.private_subnet_ids
  tags = {
    Name       = "${var.system_name}-${var.env_type}-vpce-if-ec2"
    SystemName = var.system_name
    EnvType    = var.env_type
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
    Name       = "${var.system_name}-${var.env_type}-vpce-if-ec2messages"
    SystemName = var.system_name
    EnvType    = var.env_type
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
    Name       = "${var.system_name}-${var.env_type}-vpce-if-ssm"
    SystemName = var.system_name
    EnvType    = var.env_type
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
    Name       = "${var.system_name}-${var.env_type}-vpce-if-ssmmessages"
    SystemName = var.system_name
    EnvType    = var.env_type
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
    Name       = "${var.system_name}-${var.env_type}-vpce-if-secretsmanager"
    SystemName = var.system_name
    EnvType    = var.env_type
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
    Name       = "${var.system_name}-${var.env_type}-vpce-if-ecr-dkr"
    SystemName = var.system_name
    EnvType    = var.env_type
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
    Name       = "${var.system_name}-${var.env_type}-vpce-if-ecr-api"
    SystemName = var.system_name
    EnvType    = var.env_type
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
    Name       = "${var.system_name}-${var.env_type}-vpce-if-ecs"
    SystemName = var.system_name
    EnvType    = var.env_type
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
    Name       = "${var.system_name}-${var.env_type}-vpce-if-ecs-agent"
    SystemName = var.system_name
    EnvType    = var.env_type
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
    Name       = "${var.system_name}-${var.env_type}-vpce-if-ecs-telemetry"
    SystemName = var.system_name
    EnvType    = var.env_type
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
    Name       = "${var.system_name}-${var.env_type}-vpce-if-logs"
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}
