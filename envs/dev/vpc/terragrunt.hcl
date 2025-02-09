include "root" {
  path = find_in_parent_folders("root.hcl")
}

dependency "s3" {
  config_path = "../s3"
  mock_outputs = {
    awslogs_s3_bucket_id = "log-s3-bucket"
  }
  mock_outputs_merge_strategy_with_state = "shallow"
}

inputs = {
  vpc_logs_s3_bucket_id = dependency.s3.outputs.awslogs_s3_bucket_id
}

terraform {
  source = "${get_repo_root()}/modules/vpc"
}
