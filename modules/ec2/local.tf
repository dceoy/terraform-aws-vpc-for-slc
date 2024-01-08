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
  image_id = var.image_id != null ? var.image_id : data.aws_ami.latest.id
}
