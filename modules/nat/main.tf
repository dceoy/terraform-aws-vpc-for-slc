resource "aws_nat_gateway" "nat" {
  count             = var.create_nat_gateway ? 1 : 0
  connectivity_type = "public"
  availability_mode = "regional"
  tags = {
    Name       = "${var.system_name}-${var.env_type}-nat-regional"
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}

resource "aws_route" "nat" {
  count                  = length(aws_nat_gateway.nat)
  route_table_id         = var.private_route_table_ids[count.index]
  nat_gateway_id         = aws_nat_gateway.nat[count.index].id
  destination_cidr_block = "0.0.0.0/0"
}
