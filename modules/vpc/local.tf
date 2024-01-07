data "aws_region" "region" {}

data "aws_availability_zones" "az" {
  state = "available"
}

locals {
  region = data.aws_region.region.name
  private_subnet_azs = slice(
    data.aws_availability_zones.az.names,
    0,
    length(var.private_subnet_cidrs)
  )
  public_subnet_azs = slice(
    data.aws_availability_zones.az.names,
    0,
    length(var.public_subnet_cidrs)
  )
}
