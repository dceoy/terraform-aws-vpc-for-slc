data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_ami" "latest" {
  most_recent = true
  filter {
    name   = "name"
    values = ["al2023-ami-*-kernel-*-arm64"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["amazon"]
}

locals {
  account_id = data.aws_caller_identity.current.account_id
  region     = data.aws_region.current.name
  image_id   = var.image_id != null ? var.image_id : data.aws_ami.latest.id
}
