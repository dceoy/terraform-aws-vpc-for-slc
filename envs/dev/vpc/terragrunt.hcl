include "root" {
  path = find_in_parent_folders()
}

dependency "kms" {
  config_path = "../kms"
  mock_outputs = {
    kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
  }
  mock_outputs_merge_strategy_with_state = "shallow"
}

dependency "s3" {
  config_path = "../s3"
  mock_outputs = {
    log_s3_bucket_id      = "log-s3-bucket-id"
    log_s3_iam_policy_arn = "arn:aws:iam::123456789012:policy/log-s3-iam-policy"
  }
  mock_outputs_merge_strategy_with_state = "shallow"
}

inputs = {
  vpc_flow_log_s3_bucket_id      = dependency.s3.outputs.log_s3_bucket_id
  vpc_flow_log_s3_iam_policy_arn = dependency.s3.outputs.log_s3_iam_policy_arn
  kms_key_arn                    = dependency.kms.outputs.kms_key_arn
}

terraform {
  source = "${get_repo_root()}/modules/vpc"
}
