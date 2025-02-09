data "aws_region" "current" {}

data "aws_availability_zones" "az" {
  state = "available"
}

locals {
  region = data.aws_region.current.name
  azs    = data.aws_availability_zones.az.names
}
