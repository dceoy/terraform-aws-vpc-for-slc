# trivy:ignore:AVD-AWS-0104
resource "aws_security_group" "vpce" {
  # checkov:skip=CKV_AWS_382:Allow outbound traffic for VPC interface endpoints.
  count       = length(var.vpc_interface_endpoint_services) > 0 ? 1 : 0
  name        = "${var.system_name}-${var.env_type}-sg-vpce"
  description = "Security group for VPC interface endpoints"
  vpc_id      = var.vpc_id
  ingress {
    description = "Allow all inbound traffic from the security group itself"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }
  egress {
    description      = "Allow all outbound traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  dynamic "ingress" {
    for_each = length(var.vpc_cidr_blocks) > 0 ? [true] : []
    content {
      description = "Allow all inbound traffic in the VPC"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = var.vpc_cidr_blocks
    }
  }
  tags = {
    Name       = "${var.system_name}-${var.env_type}-sg-vpce"
    SystemName = var.system_name
    EnvType    = var.env_type
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_vpc_endpoint" "interface" {
  for_each            = toset(var.vpc_interface_endpoint_services)
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${local.region}.${each.key}"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  security_group_ids  = aws_security_group.vpce[*].id
  subnet_ids          = var.private_subnet_ids
  tags = {
    Name       = "${var.system_name}-${var.env_type}-vpce-if-${replace(each.key, ".", "-")}"
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}
