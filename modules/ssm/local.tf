data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

locals {
  account_id                            = data.aws_caller_identity.current.account_id
  region                                = data.aws_region.current.name
  ssm_session_document_name             = "${var.system_name}-${var.env_type}-ssm-session-document"
  ssm_session_cloudwatch_log_group_name = "/${var.system_name}/${var.env_type}/ssm/${local.ssm_session_document_name}"
}
