data "aws_subnet" "public" {
  count = min(length(var.public_subnet_ids), length(var.private_route_table_ids))
  id    = var.public_subnet_ids[count.index]
}

locals {
  nat_gateway_count = length(data.aws_subnet.public[*].availability_zone)
  nat_gateway_azs   = data.aws_subnet.public[*].availability_zone
}
