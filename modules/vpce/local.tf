data "aws_region" "current" {}

data "aws_subnet" "private" {
  id = var.private_subnet_ids[0]
}

locals {
  region = data.aws_region.current.name
  vpc_id = data.aws_subnet.private.vpc_id
}
