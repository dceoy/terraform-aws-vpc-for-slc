data "aws_region" "current" {}

data "aws_availability_zones" "az" {
  # checkov:skip=CKV_AWS_394:AZ discovery is intentionally dynamic across each region.
  state = "available"
}

locals {
  region = data.aws_region.current.id
  azs    = data.aws_availability_zones.az.names
}
