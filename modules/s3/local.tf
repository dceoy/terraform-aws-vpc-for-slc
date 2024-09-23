data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

locals {
  account_id             = data.aws_caller_identity.current.account_id
  region                 = data.aws_region.current.name
  awslogs_s3_bucket_name = "${var.system_name}-${var.env_type}-awslogs-${local.region}-${local.account_id}"
}
