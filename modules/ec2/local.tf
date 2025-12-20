data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_ssm_parameter" "ecs_ami" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2023/arm64/recommended"
}

locals {
  account_id   = data.aws_caller_identity.current.account_id
  region       = data.aws_region.current.id
  ec2_image_id = var.ec2_image_id != null ? var.ec2_image_id : jsondecode(data.aws_ssm_parameter.ecs_ami.value).image_id
}
