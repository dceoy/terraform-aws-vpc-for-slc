include "root" {
  path   = find_in_parent_folders()
  expose = true
}

dependency "s3" {
  config_path = "../s3"
  mock_outputs = {
    log_s3_bucket_id = "log-s3-bucket"
  }
  mock_outputs_merge_strategy_with_state = "shallow"
}

dependency "kms" {
  config_path = "../kms"
  mock_outputs = {
    kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
  }
  mock_outputs_merge_strategy_with_state = "shallow"
}

inputs = {
  ssm_session_log_s3_bucket_id = dependency.s3.outputs.log_s3_bucket_id
  kms_key_arn                  = include.root.inputs.create_kms_key ? dependency.kms.outputs.kms_key_arn : null
}

terraform {
  source = "${get_repo_root()}/modules/ssm"
}
