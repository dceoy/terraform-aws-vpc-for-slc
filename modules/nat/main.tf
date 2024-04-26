resource "aws_nat_gateway" "nat" {
  count             = length(aws_eip.nat)
  allocation_id     = aws_eip.nat[count.index].id
  subnet_id         = var.public_subnet_ids[count.index]
  connectivity_type = "public"
  tags = {
    Name       = "${var.system_name}-${var.env_type}-nat-public${count.index}"
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}

resource "aws_eip" "nat" {
  count  = var.nat_gateway_count
  domain = "vpc"
  tags = {
    Name       = "${var.system_name}-${var.env_type}-eip${count.index}"
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
