data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
  region     = data.aws_region.current.id
  s3_bucket_names = {
    for k, v in {
      io      = var.create_io_s3_bucket
      awslogs = var.create_awslogs_s3_bucket
      s3logs  = var.create_s3logs_s3_bucket && (var.create_io_s3_bucket || var.create_awslogs_s3_bucket)
    } : k => "${var.system_name}-${var.env_type}-${k}-${local.region}-${local.account_id}" if v
  }
}
