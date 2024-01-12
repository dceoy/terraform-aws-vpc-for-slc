data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
  region     = data.aws_region.current.name
  vpc_name   = "${var.project_name}-${var.env_type}-vpc"
}

locals {
  vpc_flow_log_cloudwatch_log_group_name = "/aws/vpc/flow-logs/${local.vpc_name}"
}
