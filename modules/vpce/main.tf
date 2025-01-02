resource "aws_vpc_endpoint" "interface" {
  for_each            = toset(var.vpc_interface_endpoint_services)
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${local.region}.${each.key}"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  security_group_ids  = var.security_group_ids
  subnet_ids          = var.private_subnet_ids
  tags = {
    Name       = "${var.system_name}-${var.env_type}-vpce-if-${replace(each.key, ".", "-")}"
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}
