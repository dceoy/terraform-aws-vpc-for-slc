resource "aws_vpc_endpoint" "ec2_interface" {
  count               = contains(var.vpc_interface_endpoint_services, "ec2") ? 1 : 0
  vpc_id              = var.vpc_id
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
  count               = contains(var.vpc_interface_endpoint_services, "ec2messages") ? 1 : 0
  vpc_id              = var.vpc_id
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
  count               = contains(var.vpc_interface_endpoint_services, "ssm") ? 1 : 0
  vpc_id              = var.vpc_id
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
  count               = contains(var.vpc_interface_endpoint_services, "ssmmessages") ? 1 : 0
  vpc_id              = var.vpc_id
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
  count               = contains(var.vpc_interface_endpoint_services, "secretsmanager") ? 1 : 0
  vpc_id              = var.vpc_id
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
  count               = contains(var.vpc_interface_endpoint_services, "ecr.dkr") ? 1 : 0
  vpc_id              = var.vpc_id
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
  count               = contains(var.vpc_interface_endpoint_services, "ecr.api") ? 1 : 0
  vpc_id              = var.vpc_id
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
  count               = contains(var.vpc_interface_endpoint_services, "ecs") ? 1 : 0
  vpc_id              = var.vpc_id
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
  count               = contains(var.vpc_interface_endpoint_services, "ecs-agent") ? 1 : 0
  vpc_id              = var.vpc_id
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
  count               = contains(var.vpc_interface_endpoint_services, "ecs-telemetry") ? 1 : 0
  vpc_id              = var.vpc_id
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
  count               = contains(var.vpc_interface_endpoint_services, "logs") ? 1 : 0
  vpc_id              = var.vpc_id
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

resource "aws_vpc_endpoint" "kms_interface" {
  count               = contains(var.vpc_interface_endpoint_services, "kms") ? 1 : 0
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${local.region}.kms"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  security_group_ids  = var.security_group_ids
  subnet_ids          = var.private_subnet_ids
  tags = {
    Name       = "${var.system_name}-${var.env_type}-vpce-if-kms"
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}
