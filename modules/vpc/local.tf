data "aws_availability_zones" "az" {
  state = "available"
}

locals {
  availability_zones = slice(
    data.aws_availability_zones.az.names,
    0,
    length(var.private_subnet_cidrs)
  )
}
