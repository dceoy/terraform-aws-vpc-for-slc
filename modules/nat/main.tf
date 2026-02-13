locals {
  create_nat_gateway = coalesce(var.nat_gateway_count, 1) > 0
}

resource "aws_nat_gateway" "nat" {
  count             = local.create_nat_gateway ? 1 : 0
  allocation_id     = aws_eip.nat[0].id
  subnet_id         = var.public_subnet_ids[0]
  connectivity_type = "public"
  tags = {
    Name       = "${var.system_name}-${var.env_type}-nat-public-regional"
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}

resource "aws_eip" "nat" {
  count  = local.create_nat_gateway ? 1 : 0
  domain = "vpc"
  tags = {
    Name       = "${var.system_name}-${var.env_type}-eip-regional"
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}

resource "aws_route" "nat" {
  count                  = local.create_nat_gateway ? length(var.private_route_table_ids) : 0
  route_table_id         = var.private_route_table_ids[count.index]
  nat_gateway_id         = aws_nat_gateway.nat[0].id
  destination_cidr_block = "0.0.0.0/0"
}
