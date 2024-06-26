data "aws_region" "current" {}

data "aws_availability_zones" "az" {
  state = "available"
}

locals {
  region             = data.aws_region.current.name
  private_subnet_azs = slice(data.aws_availability_zones.az.names, 0, var.private_subnet_count)
  public_subnet_azs  = slice(data.aws_availability_zones.az.names, 0, var.public_subnet_count)
  az_count           = length(data.aws_availability_zones.az.names)
}
