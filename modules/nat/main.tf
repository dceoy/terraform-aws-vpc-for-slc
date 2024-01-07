resource "aws_nat_gateway" "nat" {
  count             = local.nat_gateway_count
  allocation_id     = aws_eip.nat[count.index].id
  subnet_id         = var.public_subnet_ids[count.index]
  connectivity_type = "public"
  tags = {
    Name        = "${var.project_name}-${var.env_type}-nat-public${count.index}-${local.nat_gateway_azs[count.index]}"
    ProjectName = var.project_name
    EnvType     = var.env_type
  }
}

resource "aws_eip" "nat" {
  count  = local.nat_gateway_count
  domain = "vpc"
  tags = {
    Name        = "${var.project_name}-${var.env_type}-eip${count.index}"
    ProjectName = var.project_name
    EnvType     = var.env_type
  }
}

resource "aws_route" "nat" {
  count                  = local.nat_gateway_count
  route_table_id         = var.private_route_table_ids[count.index]
  nat_gateway_id         = aws_nat_gateway.nat[0].id
  destination_cidr_block = "0.0.0.0/0"
}
